//
//  EventSelectionViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 30/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSelectionViewController.h"
#import "CAPSPageMenu.h"
#import "AppDelegate.h"
#import "ProfileMenuViewController.h"
#import "WYPopoverController.h"
#import "DAAlertController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "Webclient.h"
#import "ChangePasswordViewController.h"
#import "EventListResponse.h"

@interface EventSelectionViewController (){
    EventListResponse *tempmasterObj;
    
}
@property (nonatomic) CAPSPageMenu *pageMenu;
@end

@implementation EventSelectionViewController
@synthesize profileButton , backButton ;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setNeedsStatusBarAppearanceUpdate];
    
    [self fetchEventList];

//    if ([Utility connectedToNetwork]) {
//        [self fetchEventList];
//
//    } else {
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"dataReceived"
//         object:self];
//    }
    [self addNotificationButton];
    [self addNotificationButtonLeft];
    
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.baseController = self.navigationController;
    
    UIImageView *backgroundGradient = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 54.0)];
    [backgroundGradient setImage:[UIImage imageNamed:@"headerbg"]];
    [self.view addSubview:backgroundGradient];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller1 = [storyboard instantiateViewControllerWithIdentifier:@"eventVC"];
    controller1.title = @"Previous";
    UIViewController *controller2 = [storyboard instantiateViewControllerWithIdentifier:@"eventVC"];
    controller2.title = @"Upcoming";
    UIViewController *controller3 = [storyboard instantiateViewControllerWithIdentifier:@"eventVC"];
    controller3.title = @"Annual";
    
    NSArray *controllerArray = @[controller1, controller2, controller3];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionViewBackgroundColor:[UIColor clearColor],
                                 //CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 //CAPSPageMenuOptionSelectionIndicatorHeight:@(2.0),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor:[UIColor colorWithRed:6/255.0 green:44/255.0 blue:68/255.0 alpha:1.0],
//                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:1/255.0 green:40/255.0 blue:50/255.0 alpha:1.0],
                                 CAPSPageMenuOptionAddBottomMenuHairline: @(NO),
                                 CAPSPageMenuOptionSelectionIndicatorColor:[UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0],
                                 //CAPSPageMenuOptionSelectedMenuItemLabelColor:[UIColor colorWithRed:234.0/255.0 green:232.0/255.0 blue:235.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor:[UIColor colorWithRed:117/255.0 green:130/255.0 blue:140/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"Axiforma-Bold" size:13.0],
                                 
                                 CAPSPageMenuOptionSelectionIndicatorHeight:@(4.0),
                                 CAPSPageMenuOptionMenuHeight: @(54.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(self.view.bounds.size.width/3),
                                 CAPSPageMenuOptionMenuMargin: @(0.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 84.0 , self.view.frame.size.width, self.view.frame.size.height) options:parameters];

    [_pageMenu moveToPageWithOutAnim:1];
    
    [self.view addSubview:_pageMenu.view];
    UIScrollView *sv = [_pageMenu.view viewWithTag:102];
    
    [sv.layer insertSublayer:backgroundGradient.layer atIndex:0];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleBlackTranslucent;
//}
//

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleBlackOpaque;
//}
//
//
//-(BOOL)prefersStatusBarHidden{
//    return NO;
//}
//
- (IBAction)btnBack_Pressed:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:true];
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self.navigationItem setHidesBackButton:YES];
}


-(void) fetchEventList{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults setObject:[NSString stringWithFormat:@"%@", tfPassword.text] forKey:@"UserPass"];
    
    [defaults synchronize];
    
    
    NSString *serviceType = [[NSString alloc] init];
    
    
    
    serviceType = @"api/Event/getPastByPage/1/10";
    
    [[Webclient sharedWeatherHTTPClient] getEventList:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (EventListResponse*) responseObject;
        
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            //[tvEvents reloadData];
            [defaults rm_setCustomObject:tempmasterObj forKey:@"DataOne"];
            [defaults synchronize];
            
            [[Webclient sharedWeatherHTTPClient] getEventList:@"api/Event/GetUpComingByPage/1/10000" viewController:self CompletionBlock:^(NSObject *responseObject) {
                tempmasterObj = (EventListResponse*) responseObject;
                
                if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
                    [defaults rm_setCustomObject:tempmasterObj forKey:@"DataTwo"];
                    [defaults synchronize];
                    
//                    @"api/Event/getAllByPage/-1/1/10000"
                    [[Webclient sharedWeatherHTTPClient] getEventList:@"api/Event/getAllByPage/-1/1/10000" viewController:self CompletionBlock:^(NSObject *responseObject) {
                        tempmasterObj = (EventListResponse*) responseObject;
                        
                        [defaults rm_setCustomObject:tempmasterObj forKey:@"DataThree"];
                        [defaults synchronize];
                        
                        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
                            //[self restoreData];
                            [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"dataReceived"
                             object:self];
                        }
                        
                        
                    } FailureBlock:^(NSError *error) {
                        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                                style:DAAlertActionStyleCancel
                                                                              handler:^{
                                                                                  
                                                                              }];
                        
                        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
                    }];
                    
                }
                
                
            } FailureBlock:^(NSError *error) {
                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                        style:DAAlertActionStyleCancel
                                                                      handler:^{
                                                                          
                                                                      }];
                
                [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
            }];
        }
        
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    
    
    
    
}


-(void) addNotificationButton{
    profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame = CGRectMake(0, 0, 16, 16);
    
    //    [listButton addTarget:self action:@selector(openLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"icon_profile"];
    [profileButton setImage:backButtonImage forState:UIControlStateNormal];
    UIImage *backButtonHigh = [UIImage imageNamed:@"icon_profile"];
    [profileButton setImage:backButtonHigh forState:UIControlStateHighlighted];
    
    profileButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.rightBarButtonItem = backBarButtonItem;
    
    [profileButton addTarget:self action:@selector(profileButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileMenuViewController *profileMenu = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    
    [profileMenu setDelegate:self];
    
    popover = [[WYPopoverController alloc] initWithContentViewController:profileMenu];
    
    [popover setPopoverContentSize:CGSizeMake(200, 120)];
}

-(void) addNotificationButtonLeft{
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 16, 16);
    
    //    [listButton addTarget:self action:@selector(openLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backbutton"];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    UIImage *backButtonHigh = [UIImage imageNamed:@"backbutton"];
    [backButton setImage:backButtonHigh forState:UIControlStateHighlighted];
    
    backButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    [backButton addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ProfileMenuViewController *profileMenu = [storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
//    
//    [profileMenu setDelegate:self];
//    
//    popover = [[WYPopoverController alloc] initWithContentViewController:profileMenu];
//    
//    [popover setPopoverContentSize:CGSizeMake(200, 120)];
}

-(void)backToView {
    
    [self.navigationController popViewControllerAnimated:true];
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}


-(void) profileButtonPressed{
    

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"UserData"]){
        [popover presentPopoverFromRect:profileButton.bounds
                                 inView:profileButton
               permittedArrowDirections:WYPopoverArrowDirectionAny
                               animated:YES
                                options:WYPopoverAnimationOptionFadeWithScale];
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }


}

-(void) logout{

    [[Webclient sharedWeatherHTTPClient] logout:self CompletionBlock:^(NSObject *responseObject) {
        
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"UserData"];
            [defaults synchronize];
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
              UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVc"];
              [self presentViewController:vc animated:YES completion:^{
                                                                      
                                                                  }];
                                                                  
                                                                  //[self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"User logged out successfully." actions:@[dismissAction]];

    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
    }];
    
}

-(void) settingsButtonPressed:(id)button{
    //ChangePassword
    [popover dismissPopoverAnimated:YES completion:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChangePasswordViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"changepassVC"];
        vc.comeForSideMenuOrTab = 2 ;
        
        [self presentViewController:vc animated:YES completion:^{
            
        }];
    }];
}

-(void) editProfileButtonPressed:(id)button{
    
    [popover dismissPopoverAnimated:YES completion:^{
//        profileVC
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
        
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }];
}

-(void) logoutButtonPressed:(id)button{
    
    [popover dismissPopoverAnimated:YES completion:^{
        DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                               style:DAAlertActionStyleCancel handler:nil];
        DAAlertAction *signOutAction = [DAAlertAction actionWithTitle:@"Logout"
                                                                style:DAAlertActionStyleDestructive handler:^{
                                                                    [self logout];
                                                                }];
        [DAAlertController showAlertViewInViewController:self
                                               withTitle:@"Logout!"
                                                 message:@"Are you sure you want to log out?"
                                                 actions:@[cancelAction, signOutAction]];
    }];
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.navigationItem setTitle:@"Calender"];
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
