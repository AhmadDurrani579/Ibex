//
//  ForgotPasswordViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "DAAlertController.h"
#import "InvalidTooltipView.h"
#import "Webclient.h"
#import "ForgotPasswordResponse.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize tfEmailAddress;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) resignKeyboard{
    [self.view endEditing:YES];
}

-(IBAction)submitButtonPressed:(id)sender{
    [self validateFormFields];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"Home Screen"
           value:@"Home Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
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
    
    [validator putRule:[Rules checkIsValidEmailWithFailureString:@"Please enter the correct email address." forTextField:tfEmailAddress]];
    
    [validator validate];
}

-(void) authenticate{
    
    NSString *emailAdd = [NSString stringWithFormat:@"%@", tfEmailAddress.text];
    
    [[Webclient sharedWeatherHTTPClient] forgotPassword:emailAdd viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        ForgotPasswordResponse *obj = [[ForgotPasswordResponse alloc] init];
        
        if(responseObject){
            obj = (ForgotPasswordResponse*)responseObject;
        }
        
        if([[NSString stringWithFormat:@"%@", obj.status] isEqualToString:@"1"]){
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                          
                                                                      }];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Success" message:[NSString stringWithFormat:@"%@", obj.message] actions:@[dismissAction]];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", obj.message] actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{

                                                                  }];

            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    
//    [[Webclient sharedWeatherHTTPClient] forgotPassword:emailAdd viewController:self CompletionBlock:^(NSObject *responseObject) {
//        
//        if(responseObject){
//            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                    style:DAAlertActionStyleCancel
//                                                                  handler:^{
//                                                                      [self dismissViewControllerAnimated:YES completion:^{
//                                                                          
//                                                                      }];
//                                                                  }];
//            
//            [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:[NSString stringWithFormat:@"Please check your email."] actions:@[dismissAction]];
//        }
//        else{
//            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                    style:DAAlertActionStyleCancel
//                                                                  handler:^{
//                                                                      
//                                                                  }];
//            
//            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"Please try again later."] actions:@[dismissAction]];
//        }
//    } FailureBlock:^(NSError *error) {
//        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                style:DAAlertActionStyleCancel
//                                                              handler:^{
//                                                                  
//                                                              }];
//        
//        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
//    }];
//    
    
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
