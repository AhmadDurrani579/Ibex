//
//  UserProfileViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 10/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "loginResponse.h"
#import "UserProfileResponse.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "Utility.h"
#import "ProfileUpdateViewController.h"
#import "CardView.h"
#import "YPOChatViewController.h"
#import "DBChatManager.h"
#import "XMPPvCardTemp.h"

@interface UserProfileViewController (){
    UserProfileResponse *masterObj;
    
    __weak IBOutlet UIButton *btnLinkAngelOpen;
    
    __weak IBOutlet UIButton *btnLinkedIn;
    __weak IBOutlet UIButton *btnFb;
    
    __weak IBOutlet UIButton *btnTwitter;
    
    __weak IBOutlet NSLayoutConstraint *btnAngelListLeading;
    __weak IBOutlet CardView *viewOfSocial;
    
    __weak IBOutlet NSLayoutConstraint *btnTwitterLeading;
    __weak IBOutlet NSLayoutConstraint *topConstraintOfTheInfo;
    
    __weak IBOutlet NSLayoutConstraint *btnLeadingOfLinkedIn;
    __weak IBOutlet UIImageView *imageChat;
}

@end

@implementation UserProfileViewController
@synthesize ivPRofilePic, tfName,tfIndustry,tfCompany,tfEmail,tfFunction,tfJobTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ivPRofilePic.layer.cornerRadius = ivPRofilePic.frame.size.height/2;
    ivPRofilePic.clipsToBounds = YES;
    
    [tfName setEnabled:NO];
    [tfIndustry setEnabled:NO];
    [tfCompany setEnabled:NO];
    [tfEmail setEnabled:NO];
    [tfFunction setEnabled:NO];
    [tfJobTitle setEnabled:NO];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    //    self.ivProfilePic.isUserInteractionEnabled = true ;
    [imageChat setUserInteractionEnabled:true];
    [imageChat addGestureRecognizer:singleFingerTap];

}


- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self fetchUser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self.navigationController setNavigationBarHidden:true];

    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
//    [vc.navigationController setHidesBarsOnTap:false];
    [self.navigationController pushViewController:vc animated:true];
}



-(IBAction)editButtonPressed:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileUpdateViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"profileupdateVC"];
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction)angelListButtonPressed:(id)sender {
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerWebsite]]){
        if([[masterObj.user.speakerWebsite lowercaseString] containsString:@"http://"] || [[masterObj.user.speakerWebsite lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:masterObj.user.speakerWebsite]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", masterObj.user.speakerWebsite]]];
        }
        
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
}

- (IBAction)fbButtonPressed:(id)sender {
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerFBURL]]){
        if([[masterObj.user.speakerFBURL lowercaseString] containsString:@"http://"] || [[masterObj.user.speakerFBURL lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:masterObj.user.speakerFBURL]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", masterObj.user.speakerFBURL]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
}

- (IBAction)linkedinButtonPressed:(id)sender {
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerLinkedinURL]]){
        if([[masterObj.user.speakerLinkedinURL lowercaseString] containsString:@"http://"] || [[masterObj.user.speakerLinkedinURL lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:masterObj.user.speakerLinkedinURL]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", masterObj.user.speakerLinkedinURL]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
    
    

}

- (IBAction)twitterButtonPressed:(id)sender {
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerTwitterURL]]){
        if([[masterObj.user.speakerTwitterURL lowercaseString] containsString:@"http://"] || [[masterObj.user.speakerTwitterURL lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:masterObj.user.speakerTwitterURL]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", masterObj.user.speakerTwitterURL]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)btnBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}


-(BOOL)prefersStatusBarHidden{
    return NO;
}


-(void) restoreData{
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[masterObj.user.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL, masterObj.user.speakerThumbImg]];
    [ivPRofilePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
    
    ivPRofilePic.layer.cornerRadius = ivPRofilePic.frame.size.height/2;
    ivPRofilePic.clipsToBounds = YES;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    BOOL boolValue = [obj.isBoardMember boolValue];

    if (boolValue == true){
        [_txtPhoneNumber setHidden:true];
        [_lblPhone setHidden:true];
        
    } else  {
        [_txtPhoneNumber setHidden:false];
        [_lblPhone setHidden:false];
        _txtPhoneNumber.text = masterObj.user.phoneNumber ;
        }
    
    
    [tfName setText:[NSString stringWithFormat:@"%@ %@", masterObj.user.speakerFirstName, masterObj.user.speakerLastName]];
    [tfEmail setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerEmailAddress]];
    [tfCompany setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerCompany]];
    [tfJobTitle setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerJobTitle]];
    [tfIndustry setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerIndustry]];
    [tfFunction setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerFunction]];
}

-(void) fetchUser{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSString *userId ;
    
    if ([self.selectedVc isEqualToString:@"VCChat_Detail"]){
        userId = self.loginUserId ;
        
    } else {
        userId = obj.loginUserID ;
    }
    [[Webclient sharedWeatherHTTPClient] getUserProfile:[NSString stringWithFormat:@"%@", userId] viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        masterObj = (UserProfileResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
            [self restoreData];

//            if ([masterObj.user.speakerWebsite isEqualToString:@"<null>"] && [masterObj.user.speakerFBURL isEqualToString:@"<null>"] && [masterObj.user.speakerLinkedinURL isEqualToString:@"<null>"] && [masterObj.user.speakerTwitterURL isEqualToString:@"<null>"]){
//                [viewOfSocial setHidden:true];
//                topConstraintOfTheInfo.constant = -50 ;
//            }else {
//
//                if ([masterObj.user.speakerWebsite isEqualToString:@""]){
//                    [btnLinkAngelOpen setHidden:true];
//                }else {
//                    [btnLinkAngelOpen setHidden:false];
//
//                }
//
//                if ([masterObj.user.speakerFBURL isEqualToString:@""]){
//                    [btnFb setHidden:true];
//                    btnAngelListLeading.constant = 80 ;
//                    btnLeadingOfLinkedIn.constant = -80 ;
//                } else {
//                    [btnFb setHidden:false];
//                    btnAngelListLeading.constant = 0 ;
//                    btnLeadingOfLinkedIn.constant = 0 ;
//
//                }
//                if ([masterObj.user.speakerTwitterURL isEqualToString:@""]){
//                    [btnTwitter setHidden:true];
//                }
//                if ([masterObj.user.speakerLinkedinURL isEqualToString:@""]){
//                    [btnLinkedIn setHidden:true];
//                    btnTwitterLeading.constant = -80 ;
//                }else {
//                    [btnLinkedIn setHidden:false];
//                    btnTwitterLeading.constant = 0 ;
//
//                }

                
//            }
            
         
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", masterObj.message] actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
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
