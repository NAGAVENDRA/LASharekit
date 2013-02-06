//
//  ViewController.m
//  LASharekitExample
//
//  Created by Luis Ascorbe on 12/11/12.
//  Copyright (c) 2012 Luis Ascorbe. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LASharekit.h"
#import "RDActionSheet.h"

#define PINTEREST_IMAGE_URL         @"https://raw.github.com/Lascorbe/LASharekit/master/captura.png"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *txtTitle;
    IBOutlet UITextField *txtUrl;
    IBOutlet UITextField *txtText;
    IBOutlet UIImageView *imgView;
    
    LASharekit *laSharekit;
}

- (IBAction) share;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    // ** NAVIGATIONBAR CUSTOMIZATION ** //
    self.navigationController.navigationBar.tintColor   = [UIColor darkGrayColor];
    UIImageView *retval             = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    retval.contentMode              = UIViewContentModeScaleAspectFit;
    retval.frame                    = CGRectMake(0.0, 0.0, 130.0, 30.0);
    self.navigationItem.titleView   = retval;
    
#if !__has_feature(objc_arc)
    [retval release];
#endif
    
    if (!self.navigationItem.rightBarButtonItem)
    {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share it!", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(share)];
        
        self.navigationItem.rightBarButtonItem = barButton;
        
#if !__has_feature(objc_arc)
        [barButton release];
#endif
    }
    
    
    // UIIMAGEVIEW GESTURE RECOGNIZER //
    // add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [imgView addGestureRecognizer:singleTap];
#if !__has_feature(objc_arc)
    [singleTap release];
#endif
    
    
    
    //////////////////////
    // ** LASharekit ** //
    //////////////////////
    
    // INIT
    // The parameter passed (self) is the ViewController to load the modal views
    laSharekit = [[LASharekit alloc] init:self];
    
    // COMPLETION BLOCKS
    [laSharekit setCompletionDone:^{
        UIImageView *Checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [APPDELEGATE mostratHUD:YES conTexto:NSLocalizedString(@"Shared!", @"") conView:Checkmark dimBackground:YES];
        [APPDELEGATE ocultarHUDConCustomView:YES despuesDe:2.0];
#if !__has_feature(objc_arc)
        [Checkmark release];
#endif
    }];
    [laSharekit setCompletionCanceled:^{
        UIImageView *errorMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Errormark"]];
        [APPDELEGATE mostratHUD:YES conTexto:NSLocalizedString(@"Canceled", @"") conView:errorMark dimBackground:YES];
        [APPDELEGATE ocultarHUDConCustomView:YES despuesDe:2.0];
#if !__has_feature(objc_arc)
        [errorMark release];
#endif
    }];
    [laSharekit setCompletionFailed:^{
        UIImageView *errorMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Errormark"]];
        [APPDELEGATE mostratHUD:YES conTexto:NSLocalizedString(@"Failed", @"") conView:errorMark dimBackground:YES];
        [APPDELEGATE ocultarHUDConCustomView:YES despuesDe:2.0];
#if !__has_feature(objc_arc)
        [errorMark release];
#endif
    }];
    [laSharekit setCompletionSaved:^{
        UIImageView *Checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [APPDELEGATE mostratHUD:YES conTexto:NSLocalizedString(@"Saved!", @"") conView:Checkmark dimBackground:YES];
        [APPDELEGATE ocultarHUDConCustomView:YES despuesDe:2.0];
#if !__has_feature(objc_arc)
        [Checkmark release];
#endif
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GestureRecognizer

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [[self view] endEditing:YES];
    
    RDActionSheet *actionSheet = [[RDActionSheet alloc] initWithCancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                                primaryButtonTitle:nil
                                                                destroyButtonTitle:nil
                                                                 otherButtonTitles:NSLocalizedString(@"Gallery", @""), NSLocalizedString(@"Camera", @""), nil];
#if !__has_feature(objc_arc)
    [actionSheet autorelease];
#endif
    
    actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex)
    {
        switch (result) {
            case RDActionSheetButtonResultSelected:
                //NSLog(@"Pressed %i", buttonIndex);
                [APPDELEGATE performSelectorInBackground:@selector(mostratHUDCargando) withObject:nil];
                switch (buttonIndex)
            {
                case 1: // Camara
                    [self performSelector:@selector(scanCamara) withObject:nil afterDelay:.1];
                    break;
                    
                case 0: // Galeria
                    //[self scanGaleria];
                    [self performSelector:@selector(scanGaleria) withObject:nil afterDelay:.1];
                    break;
                    
                default:
                    break;
            }
                [APPDELEGATE performSelector:@selector(ocultarHUD) withObject:nil afterDelay:.1];
                
                break;
            case RDActionSheetResultResultCancelled:
                NSLog(@"Sheet cancelled");
        }
    };
    [actionSheet showFrom:self.view];
}

#pragma mark - PicImage

- (void) scanCamara
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:picker animated:YES];
#if !__has_feature(objc_arc)
    [picker release];
#endif
}
- (void) scanGaleria
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:picker animated:YES];
#if !__has_feature(objc_arc)
    [picker release];
#endif
}

#pragma mark - ImagePickerDelegate

// CAMARA - GALERIA //
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    imgView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        //[picker release];
    }];
}

#pragma mark - FUNCTIONS

- (IBAction) share
{
    [[self view] endEditing:YES];
    
    laSharekit.title    = txtTitle.text;
    laSharekit.url      = [NSURL URLWithString:txtUrl.text];
    laSharekit.text     = txtText.text;
    laSharekit.imageUrl = [NSURL URLWithString:PINTEREST_IMAGE_URL];
    laSharekit.image    = imgView.image;
    laSharekit.tweetCC  = @"cc @LuisEAM";
    
    
    RDActionSheet *actionSheet = [[RDActionSheet alloc] initWithCancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                                primaryButtonTitle:nil
                                                                destroyButtonTitle:nil
                                                                 otherButtonTitles:NSLocalizedString(@"Copy image", @""), NSLocalizedString(@"Save image", @""), @"Email", @"Pinterest", @"Twitter", @"Facebook", nil];
    
#if !__has_feature(objc_arc)
    [actionSheet autorelease];
#endif
    
    actionSheet.callbackBlock = ^(RDActionSheetResult result, NSInteger buttonIndex)
    {
        switch (result) {
            case RDActionSheetButtonResultSelected:
                //NSLog(@"Pressed %i", buttonIndex);
                [APPDELEGATE performSelectorInBackground:@selector(mostratHUDCargando) withObject:nil];
                switch (buttonIndex)
            {
                case 0: // copiar imagen al clipboard
                    [laSharekit performSelector:@selector(copyImageToPasteboard) withObject:nil afterDelay:.1];
                    break;
                    
                case 1: // guardar imagen
                    [laSharekit performSelector:@selector(saveImage) withObject:nil afterDelay:.1];
                    break;
                    
                case 2: // email
                    [laSharekit performSelector:@selector(emailIt) withObject:nil afterDelay:.1];
                    break;
                    
                case 3: // pinterest
                    
                    if (laSharekit.imageUrl)
                    {
                        if ([APPDELEGATE hayInternet] && ![[laSharekit.imageUrl absoluteString] isEqualToString:@""])
                        {
                            [laSharekit performSelector:@selector(pinIt) withObject:nil afterDelay:.1];
                        }
                        else
                        {
                            UIImageView *Checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                            [APPDELEGATE mostratHUD:YES conTexto:NSLocalizedString(@"Haven't image", @"") conView:Checkmark dimBackground:YES];
                            [APPDELEGATE ocultarHUDConCustomView:YES despuesDe:2.0];
#if !__has_feature(objc_arc)
                            [Checkmark release];
#endif
                        }
                    }
                    else
                    {
                        UIImageView *Checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
                        [APPDELEGATE mostratHUD:YES conTexto:NSLocalizedString(@"Haven't image", @"") conView:Checkmark dimBackground:YES];
                        [APPDELEGATE ocultarHUDConCustomView:YES despuesDe:2.0];
#if !__has_feature(objc_arc)
                        [Checkmark release];
#endif
                    }
                    
                    break;
                    
                case 4: // twitter
                    [laSharekit performSelector:@selector(tweet) withObject:nil afterDelay:.1];
                    break;
                    
                case 5: // facebook
                    [laSharekit performSelector:@selector(facebookPost) withObject:nil afterDelay:.1];
                    break;
                    
                default:
                    break;
            }
                [APPDELEGATE performSelector:@selector(ocultarHUD) withObject:nil afterDelay:.1];
                
                break;
            case RDActionSheetResultResultCancelled:
                NSLog(@"Sheet cancelled");
        }
    };
    [actionSheet showFrom:self.view];
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
