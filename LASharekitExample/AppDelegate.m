//
//  AppDelegate.m
//  LASharekitExample
//
//  Created by Luis Ascorbe on 12/11/12.
//  Copyright (c) 2012 Luis Ascorbe. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "ViewController.h"
#import "MyReachability.h"

#define CUSTOMVIEW_TAG      1111

@implementation AppDelegate

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_navController release];
    [_internetReachable release];
    [hud release];
    
    [super dealloc];
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Provide the FacebookAppID here or in the info.plist with the key "FacebookAppID"
    // [FBSession setDefaultAppID:@"118291674996759"];
    // BUG:
    // Nib files require the type to have been loaded before they can do the
    // wireup successfully.
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    [FBProfilePictureView class];
    
    // check for internet connection
    self.internetReachable = [MyReachability reachabilityForInternetConnection];
    
    UIWindow *window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window_;
#if !__has_feature(objc_arc)
    [window_ autorelease];
#endif
    
    // Override point for customization after application launch.
    ViewController *viewController_ = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.viewController = viewController_;
#if !__has_feature(objc_arc)
    [viewController_ autorelease];
#endif
    
    UINavigationController *navController_ = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.navController  = navController_;
#if !__has_feature(objc_arc)
    [navController_ autorelease];
#endif
    
    // add the HUD
    hud = [[MBProgressHUD alloc] initWithView:self.navController.view];
    hud.dimBackground = NO;
    //HUD.labelText = NSLocalizedString(@"txt_cargando", @"");
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    hud.delegate = self;
    [self.navController.view addSubview:hud];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.internetReachable stopNotifier];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(checkNetworkStatus) name:kReachabilityChangedNotification object: nil];
    
    // inicio la variable de internet
    self.hayInternet = NO;
	[self.internetReachable startNotifier];
	[self checkNetworkStatus];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}

#pragma mark - Facebook

// FBSample logic
// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

#pragma mark - Network

// called after network status changes
- (void) checkNetworkStatus
{
    NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
    switch (internetStatus)
    
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.hayInternet = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.hayInternet = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            // muestro un mensaje el label de salida y habilito el boton de actualizar
            self.hayInternet = YES;
            
            break;
        }
    }
}

#pragma mark - HUD

- (void) mostratHUDCargando
{
    hud.labelText = NSLocalizedString(@"Loading...", @"");
    [hud show:YES];
}

- (void) mostratHUD:(BOOL)animated conTexto:(NSString *)aTexto
{
    hud.labelText = aTexto;
    [hud show:YES];
}

- (void) mostratHUD:(BOOL)animated conTexto:(NSString *)aTexto conView:(UIView *)aView dimBackground:(BOOL)dimBackg
{
    MBProgressHUD *hudCustom = [[MBProgressHUD alloc] initWithView:self.navController.view];
#if !__has_feature(objc_arc)
    [hudCustom autorelease];
#endif
    hudCustom.dimBackground = dimBackg;
    hudCustom.customView = aView;
    hudCustom.labelText = aTexto;
    hudCustom.mode = MBProgressHUDModeCustomView;
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    hudCustom.delegate = self;
    hudCustom.tag = CUSTOMVIEW_TAG;
    [self.navController.view addSubview:hudCustom];
    [hudCustom show:animated];
}

- (void) mostratHUDConTexto:(NSString *)aTexto WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated
{
    hud.labelText = aTexto;
    [hud showWhileExecuting:method onTarget:target withObject:object animated:animated];
}

- (void) ocultarHUD
{
    [hud hide:YES];
}

- (void) ocultarHUD:(BOOL)animated
{
    [hud hide:animated];
}

- (void) ocultarHUD:(BOOL)animated despuesDe:(NSTimeInterval)delay
{
    [hud hide:animated afterDelay:delay];
}

- (void) ocultarHUDConCustomView:(BOOL)animated despuesDe:(NSTimeInterval)delay
{
    MBProgressHUD *hudCustom = (MBProgressHUD *)[self.navController.view viewWithTag:CUSTOMVIEW_TAG];
    [hudCustom hide:animated afterDelay:delay];
    
    [hudCustom performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:delay];
}


@end
