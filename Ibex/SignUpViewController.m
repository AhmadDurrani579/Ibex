//
//  SignUpViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SignUpViewController.h"
#import "Validator.h"
#import "InvalidTooltipView.h"
#import "DAAlertController.h"
#import "Webclient.h"
#import "SignupResponse.h"
#import "GetJobTitleResponse.h"
#import "Utility.h"
#import "JobTitleObject.h"
#import "Constant.h"
#import "UITextField+Additions.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface SignUpViewController (){
    GetJobTitleResponse *masterJobList;
    AppDelegate *app ;
}

@end

@implementation SignUpViewController
@synthesize tfPassword,tfEmailAddress,tfCompany,tfJobTitle,tfLastName,tfFirstName,tfPhoneNumber,tfConfirmPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;

    tfJobTitle.font = [UIFont fontWithName:@"Axiforma-Book" size:tfJobTitle.font.pointSize];;
    // Do any additional setup after loading the view.
    [tfJobTitle setShowAutoCompleteTableWhenEditingBegins:YES];
    [tfJobTitle setAutoCompleteTableCellTextColor:[UIColor blackColor]];
    [tfJobTitle setAutoCompleteTableBorderColor:[UIColor colorWithRed:175.0f/255.0f
                                                                green:30.0f/255.0f
                                                                 blue:35.0f/255.0f
                                                                alpha:1.0f]];
    
//    @property (strong, nonatomic) IBOutlet UITextField *tfFirstName;
//    @property (strong, nonatomic) IBOutlet UITextField *tfLastName;
//    @property (strong, nonatomic) IBOutlet MLPAutoCompleteTextField *tfJobTitle;
//    @property (strong, nonatomic) IBOutlet UITextField *tfEmailAddress;
//    @property (strong, nonatomic) IBOutlet UITextField *tfCompany;
//    @property (strong, nonatomic) IBOutlet UITextField *tfPhoneNumber;
//    @property (strong, nonatomic) IBOutlet UITextField *tfPassword;
//    @property (strong, nonatomic) IBOutlet UITextField *tfConfirmPassword;

    
    [tfJobTitle setAutoCompleteTableCornerRadius:0.0f];
    [tfJobTitle setMaximumNumberOfAutoCompleteRows:4];

//    [tfFirstName setupLeftViewWithImage:UIImageWithName(@"icon_lock")];
//    [tfLastName setupLeftViewWithImage:UIImageWithName(@"icon_lock")];
//    [tfEmailAddress setupLeftViewWithImage:UIImageWithName(@"icon_lock")];
//    [tfCompany setupLeftViewWithImage:UIImageWithName(@"icon_lock")];
//    [tfPhoneNumber setupLeftViewWithImage:UIImageWithName(@"icon_lock")];
//    [tfPassword setupLeftViewWithImage:UIImageWithName(@"icon_lock")];
//    [tfConfirmPassword setupLeftViewWithImage:UIImageWithName(@"icon_lock")];

    
//    [self fetchJobTitleList];

}

#pragma mark - MLPAutoCompleteTextField DataSource

//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    
    for(JobTitleObject *jobObj in masterJobList.list){
        if([[NSString stringWithFormat:@"%@", jobObj.jobisActive] isEqualToString:@"1"]){
            [tempArr addObject:jobObj.jobTitle];
        }
    }

    handler(tempArr);
}

#pragma mark - MLPAutoCompleteTextField Delegate

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    /*NSString *filename = [autocompleteString stringByAppendingString:@".png"];
     filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
     filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
     [cell.imageView setImage:[UIImage imageNamed:filename]];*/
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
}



- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) fetchJobTitleList{
    [[Webclient sharedWeatherHTTPClient] getJobTitles:WEBSERVICE_GET_JOBTITLE viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        masterJobList = (GetJobTitleResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", masterJobList.success] isEqualToString:@"1"]){

            [tfJobTitle reloadInputViews];

        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self dismissViewControllerAnimated:YES completion:^{
                                                                          
                                                                      }];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self dismissViewControllerAnimated:YES completion:^{
                                                                      
                                                                  }];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
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
    
    [validator putRule:[Rules checkRange:NSMakeRange(2, 30) withFailureString:@"Should be in range 2 to 30" forTextField:tfFirstName]];
    [validator putRule:[Rules checkRange:NSMakeRange(2, 30) withFailureString:@"Should be in range 2 to 30" forTextField:tfLastName]];
    [validator putRule:[Rules checkIsValidEmailWithFailureString:@"Please enter correct Email address" forTextField:tfEmailAddress]];
    [validator putRule:[Rules checkRange:NSMakeRange(2, 30) withFailureString:@"Should be in range 2 to 30" forTextField:tfCompany]];
    
    [validator putRule:[Rules checkRange:NSMakeRange(11, 13) withFailureString:@"Number should be in range 11 - 13 digits" forTextField:tfPhoneNumber]];
    
    
   // [validator putRule:[Rules checkRange:NSMakeRange(4, 30) withFailureString:@"Should be in range 4 to 30" forTextField:tfPassword]];
    
//    [validator putRule:[Rules checkRange:NSMakeRange(2, 30) withFailureString:@"Should be in range 2 to 30" forTextField:tfCompany]];
//    
//    [validator putRule:[Rules checkRange:NSMakeRange(2, 30) withFailureString:@"Should be in range 2 to 30" forTextField:tfUserName]];
//    
//    [validator putRule:[Rules checkIsValidEmailWithFailureString:@"Please enter correct Email address" forTextField:tfEmailAddress]];
//    
//    [validator putRule:[Rules checkRange:NSMakeRange(11, 15) withFailureString:@"Should be in range 11 to 15" forTextField:tfCellNo]];
//    
//    [validator putRule:[Rules checkRange:NSMakeRange(4, 30) withFailureString:@"Should be in range 4 to 30" forTextField:tfPassword]];
//    
    [validator validate];
}

-(BOOL)isValidPassword:(NSString *)checkString{
    
    NSString *passRegex = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{7,}";
    
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passRegex];
    return [passwordTest evaluateWithObject:checkString];
}

-(void) authenticate{

    
    if([self isValidPassword:tfPassword.text]){
        
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Alert!" message:[NSString stringWithFormat:@"password must contain 7 characters with lowercase, uppercase, digit & special characters."] actions:@[dismissAction]];
        
        return;
    }
    
    if([tfPassword.text isEqualToString:[NSString stringWithFormat:@"%@", tfConfirmPassword.text]]){
        
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Alert!" message:[NSString stringWithFormat:@"Password does not match the confirm password."] actions:@[dismissAction]];
        
        return;
        
    }
    NSString *jobID = @"0";
    
    for(JobTitleObject *obj in masterJobList.list){
        
        if([[NSString stringWithFormat:@"%@", [obj.jobTitle lowercaseString]] isEqualToString:[NSString stringWithFormat:@"%@", [tfJobTitle.text lowercaseString]]]){
            jobID = [NSString stringWithFormat:@"%@", obj.jobID];
            break;
        }
    }
    
    
    [[Webclient sharedWeatherHTTPClient] signUP:[NSString stringWithFormat:@"%@", tfFirstName.text] lastName:[NSString stringWithFormat:@"%@", tfLastName.text] email:[NSString stringWithFormat:@"%@", tfEmailAddress.text] company:[NSString stringWithFormat:@"%@", tfCompany.text] phoneNumber:[NSString stringWithFormat:@"%@", tfPhoneNumber.text] jobTitleID:jobID password:[NSString stringWithFormat:@"%@", tfPassword.text] viewController:self CompletionBlock:^(NSObject *responseObject) {
//       fromLoginOrSignUp
        SignupResponse *obj = (SignupResponse*) responseObject;
        
            if([[NSString stringWithFormat:@"%@", obj.status] isEqualToString:@"1"]){
                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                        style:DAAlertActionStyleCancel
                                                                      handler:^{
                                                                          
                                                                          if(_isJoinRequest == true){
                                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                              UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
                                                                              
                                                                              UIViewController *presentingVC = [self presentingViewController];
                                                                              
                                                                              [self dismissViewControllerAnimated:YES completion:
                                                                               ^{
                                                                                   [presentingVC presentViewController:vc animated:YES completion:nil];
                                                                               }];
                                                                          }
                                                                          else{
                                                                              [self dismissViewControllerAnimated:YES completion:^{
                                                                                  
                                                                              }];
                                                                          }
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
