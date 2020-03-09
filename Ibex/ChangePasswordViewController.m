//
//  ChangePasswordViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "InvalidTooltipView.h"
#import "ValidTooltipView.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "loginResponse.h"
#import "ChangePasswordResponse.h"

@interface ChangePasswordViewController (){
    NSMutableArray *tempViews;
}

@end

@implementation ChangePasswordViewController
@synthesize lblNewPass,lblOldPass,lblConfirmPass;

- (void)viewDidLoad {
    [super viewDidLoad];
    tempViews = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
}


-(void) resignKeyboard{
    [self.view endEditing:YES];
}

-(IBAction)submitButtonPressed:(id)sender{
    [self validateFormFields];
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
    
    [validator putRule:[Rules checkRange:NSMakeRange(1, 30) withFailureString:@"Old Password should not be empty" forTextField:lblOldPass]];
    [self removeAllError];
    
   // [validator putRule:[Rules checkRange:NSMakeRange(1, 30) withFailureString:@"Old Password should not be empty" forTextField:lblOldPass]];
   // [validator putRule:[Rules checkRange:NSMakeRange(7, 30) withFailureString:@"Password must contain 7 characters with lowercase, uppercase, digit & special characters." forTextField:lblNewPass]];

    [validator validate];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Change Password Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

-(BOOL)isValidPassword:(NSString *)checkString{
    
    NSString *passRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{7,}";
    
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [passwordTest evaluateWithObject:checkString];
}

-(void) authenticate{
    
    
    if([self isValidPassword:lblNewPass.text]){
        
    }
    else{
//        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                style:DAAlertActionStyleCancel
//                                                              handler:^{
//                                                                  
//                                                              }];
//        
//        [DAAlertController showAlertViewInViewController:self withTitle:@"Alert!" message:[NSString stringWithFormat:@"New password must contains 7 characters with lowercase, uppercase, digit & special characters."] actions:@[dismissAction]];
//
        [self addErrorMsg:lblNewPass err:@"New password must contains 7 chars with lower, upper, specialcase & digits."];
        return; 
    }
    
    if([lblNewPass.text isEqualToString:[NSString stringWithFormat:@"%@", lblConfirmPass.text]]){
        
    }
    else{
//        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                style:DAAlertActionStyleCancel
//                                                              handler:^{
//                                                                  
//                                                              }];
//        
//        [DAAlertController showAlertViewInViewController:self withTitle:@"Alert!" message:[NSString stringWithFormat:@"New password does not match the confirm password."] actions:@[dismissAction]];
        [self addErrorMsg:lblConfirmPass err:@"New password does not match the confirm password."];
        return;
        
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    [[Webclient sharedWeatherHTTPClient] changePassword:[NSString stringWithFormat:@"%@", lblOldPass.text] newPassword:[NSString stringWithFormat:@"%@", lblNewPass.text] confirmPassword:[NSString stringWithFormat:@"%@", lblConfirmPass.text] userID:[NSString stringWithFormat:@"%@", obj.loginUserID] viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        ChangePasswordResponse *response = (ChangePasswordResponse *)responseObject;
        
        if([[NSString stringWithFormat:@"%@", response.status] isEqualToString:@"1"]){
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
//                                                                      [self dismissViewControllerAnimated:YES completion:^{
//                                                                          
//                                                                      }];
                                                                      
                                                                      [self logout];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Success" message:[NSString stringWithFormat:@"%@", response.message] actions:@[dismissAction]];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", response.message] actions:@[dismissAction]];
        }

         
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}

-(void) logout{
    
    [[Webclient sharedWeatherHTTPClient] logout:self CompletionBlock:^(NSObject *responseObject) {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"UserData"];
        [defaults synchronize];
      
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVc"];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVc"];
//
//        UIViewController *presentingVC = [self presentingViewController];
//
//        [self dismissViewControllerAnimated:YES completion:
//         ^{
//             [presentingVC presentViewController:vc animated:YES completion:nil];
//         }];


        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
    }];
    
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

-(void) removeAllError{
    for(UIView *view in tempViews){
        InvalidTooltipView *toolTip = [view viewWithTag:101];
        [tooltipView removeFromSuperview];
    }
}

-(void) addErrorMsg:(UITextField*)txtfield err:(NSString*)err{
    UIView *topView = (UIView*) txtfield.superview;
    
    CGPoint point           = [txtfield convertPoint:CGPointMake(0.0, txtfield.frame.size.height - 4.0) toView:topView];
    CGRect tooltipViewFrame = CGRectMake(point.x, point.y,txtfield.frame.size.width, tooltipView.frame.size.height);
    
    tooltipView       = [[InvalidTooltipView alloc] init];
    tooltipView.frame = tooltipViewFrame;
    tooltipView.text  = [NSString stringWithFormat:@"%@",err];
    tooltipView.tag = 101;
    
    [topView addSubview:tooltipView];
    
    [tempViews addObject:topView];
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



-(IBAction)backButtonPressed:(id)sender{
    
    if (_comeForSideMenuOrTab = 1) {
        [self.navigationController popViewControllerAnimated: true];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
