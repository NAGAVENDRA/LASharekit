//
//  AppDelegate.h
//  LASharekitExample
//
//  Created by Luis Ascorbe on 12/11/12.
//  Copyright (c) 2012 Luis Ascorbe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@class ViewController;
@class MyReachability;

#define APPDELEGATE             (AppDelegate *)[UIApplication sharedApplication].delegate

@interface AppDelegate : UIResponder <UIApplicationDelegate, MBProgressHUDDelegate>
{
    // HUD
    MBProgressHUD *hud;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, strong) MyReachability* internetReachable;
@property (nonatomic, assign) BOOL hayInternet;

- (void) mostratHUDCargando;
- (void) mostratHUD:(BOOL)animated conTexto:(NSString *)aTexto;
- (void) mostratHUD:(BOOL)animated conTexto:(NSString *)aTexto conView:(UIView *)aView dimBackground:(BOOL)dimBackg;
- (void) mostratHUDConTexto:(NSString *)aTexto WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated;

- (void) ocultarHUD;
- (void) ocultarHUD:(BOOL)animated;
- (void) ocultarHUD:(BOOL)animated despuesDe:(NSTimeInterval)delay;
- (void) ocultarHUDConCustomView:(BOOL)animated despuesDe:(NSTimeInterval)delay;

@end
