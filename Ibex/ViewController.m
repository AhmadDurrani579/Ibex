//
//  ViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 22/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.

#import "ViewController.h"
#import "MainViewController.h"
#import "Webclient.h"
#import "Validator.h"
#import "InvalidTooltipView.h"
#import "DAAlertController.h"
#import "loginResponse.h"
#import "Utility.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "AppDelegate.h"
#import "UIViewController+Helper.h"
//#import "XMPPvCardTemp.h"
#import "DBChatManager.h"
#import <SVHTTPRequest/SVHTTPRequest.h>
#import "MOUser.h"
#import "UserInfo+CoreDataClass.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
#import <GAIFields.h>



@interface ViewController ()
{
    AppDelegate *app ;
}
@end


@implementation ViewController
@synthesize tfPassword,tfUserName;

- (void)viewDidLoad {
    [super viewDidLoad];
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;

//    [SharedDBChatManager sadf];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) loginToHomePage{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"eventListVC"];
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    [mainViewController setRootViewController:navigationController];
    [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:1];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [mainViewController setLeftViewSwipeGestureEnabled:false];

    window.rootViewController = mainViewController;
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
}

-(void) resignKeyboard{
    [self.view endEditing:YES];
}

-(void) validateFormFields{
    
    [self resignKeyboard];
    
    if (tooltipView != nil)
    {
        [tooltipView removeFromSuperview];
        tooltipView = nil;
    }
    
    Validator *validator = [[Validator alloc] init];
    validator.delegate = self;
    
    /*
    if([tfUserName.text containsString:@"@"]){
        
    }
    else{
        [validator putRule:[Rules checkRange:NSMakeRange(4, 30) withFailureString:@"Should be in range 3 to 30" forTextField:tfUserName]];
    }
     */
     
    [validator putRule:[Rules checkIsValidEmailWithFailureString:@"Please enter correct Email address" forTextField:tfUserName]];
    [validator putRule:[Rules checkRange:NSMakeRange(1, 30) withFailureString:@"Should be in range 3 to 30" forTextField:tfPassword]];
    
    [validator validate];
}

-(void) authenticate{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [[NSString alloc] init];
    
    if([defaults objectForKey:@"token"]){
        deviceToken = [defaults objectForKey:@"token"];
    }
    else{
        deviceToken = @"";
    }
    
    NSString *emailAdd = [NSString stringWithFormat:@"%@", tfUserName.text];
    NSString *pass = [NSString stringWithFormat:@"%@", tfPassword.text];
    
//    UserInfo *user = [UserInfo fetchWithPredicate:[NSPredicate predicateWithFormat:@"loginUserName == %@", emailAdd] sortDescriptor:nil fetchLimit:1].lastObject;
//    if(user)
//    {
//        NSDictionary *user = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentuser"];
//
//
////        loginResponse *userInfo = (loginResponse *)user;
//        [defaults setObject:[NSString stringWithFormat:@"%@", tfPassword.text] forKey:@"UserPass"];
//        [defaults synchronize];
//        if (!AppUtility.isOnlineForChat) {
//            [SharedDBChatManager makeConnectionWithChatServer] ;
//        }
//
//        [self loginToHomePage];
//    }
//    else {
    

    [[Webclient sharedWeatherHTTPClient] login:emailAdd password:pass grant_type:@"password" viewController:self CompletionBlock:^(NSObject *responseObject) {
        loginResponse *obj = (loginResponse*) responseObject;
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", obj.loginAccessToken]]) {
            NSString *myString = [defaults stringForKey:@"UserPass"];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:responseObject forKey:@"UserData"];
            [defaults setObject:[NSString stringWithFormat:@"%@", tfPassword.text] forKey:@"UserPass"];
            [defaults synchronize];
            

            
            if (!AppUtility.isOnlineForChat) {
                [SharedDBChatManager makeConnectionWithChatServer] ;
            }
            
            
            NSString *fullActionLabel = [NSString stringWithFormat:@"%@ (%@) %@" , obj.loginDisplayName,obj.loginUserID ,@"Login"];
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                                  action:@"User Sign In"
                                                                  label:fullActionLabel
                                                                   value:nil] build]];
            
            
            [self loginToHomePage];
            app.fromLoginOrSignUp = @"fromLogin";

            if(_isJoin){
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"loginsuccess"
                 object:self];
            }
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", obj.loginErrorDesc] actions:@[dismissAction]];
        }
        
        
    } FailureBlock:^(NSObject *responseObject) {
        
        loginResponse *obj = (loginResponse*) responseObject;
        
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", obj.loginErrorDesc] actions:@[dismissAction]];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Login Screen"];
    //    [tracker sendView:@"Home Screen"];
    //    [tracker setScreen:@"Home Screen"];
    //    [tracker send:[[[GAIDictionaryBuilder createScreenView] set:@"Home Screen"
    //                                                         forKey:@"Home Screen"] build]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}


#pragma Mark Validation of TextField

-(BOOL)isUserInputValid
{
    BOOL valid = true ;
    if(self.tfUserName.text.length < 1)
    {
        valid = NO;
        [self showAlertViewWithTitle:@"YPO" message:@"Please Enter email."];
        return valid;
        
    }else  if(! [Utility isValidEmailAddress:self.tfUserName.text] )
    {
        valid = NO;
        
        [self showAlertViewWithTitle:@"YPO" message:@"Email is not Valid."];
        
        //        [txtEmailAddress becomeFirstResponder];
        
        return valid;
        
    }
    /*
     
     **** Password Validation *****
     
     */
    
    if(self.tfPassword.text.length < 1)
    {
        valid = NO;
        
        [self showAlertViewWithTitle:@"YPO" message:@"Please enter password."];
        
        
        // [txtPassword becomeFirstResponder];
        
        return valid;
        
    }
    else if (self.tfPassword.text.length < 6)
    {
        valid = NO;
        
        [self showAlertViewWithTitle:@"YPO" message:@"Passsword length should be greater than 6."];
        
        
        //        [txtPassword becomeFirstResponder];
        
        return valid;
        
    }
    
    return valid ;
    
}



#pragma ValidatorDelegate - Delegate methods

- (void) preValidation
{
    for (UITextField *textField in self.view.subviews) {
        textField.layer.borderWidth = 0;
    }
    
    // NSLog(@"Called before the validation begins");
}

- (void)onSuccess
{
    
    if (tooltipView != nil)
    {
        [tooltipView removeFromSuperview];
        tooltipView  = nil;
    }
    [self authenticate];
    //[self gotoPassCodeScreen];
}
- (void)onFailure:(Rule *)failedRule
{
    NSLog(@"Failed");
//    failedRule.textField.layer.borderColor   = [[UIColor redColor] CGColor];
//    failedRule.textField.layer.cornerRadius  = 5;
//    failedRule.textField.layer.borderWidth   = 2;
    
    UIView *topView = (UIView*) failedRule.textField.superview;
    
    CGPoint point           = [failedRule.textField convertPoint:CGPointMake(0.0, failedRule.textField.frame.size.height - 4.0) toView:topView];
    CGRect tooltipViewFrame = CGRectMake(point.x, point.y,failedRule.textField.frame.size.width, tooltipView.frame.size.height);
    
    tooltipView       = [[InvalidTooltipView alloc] init];
    tooltipView.frame = tooltipViewFrame;
    tooltipView.text  = [NSString stringWithFormat:@"%@",failedRule.failureMessage];
    tooltipView.rule  = failedRule;
    
    [topView addSubview:tooltipView];
    //[[self.view.subviews lastObject] addSubview:tooltipView];
}


- (IBAction)forgotPasswordButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"forgotVC"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction)signUpButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"signupVC"];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

-(IBAction)submitButtonPressed:(id)sender{

    if([self isUserInputValid])
    {
        [self authenticate];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
