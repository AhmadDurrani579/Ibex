//
//  SideMenuViewController.m
//  COI
//
//  Created by Sajid Saeed on 03/10/2016.
//  Copyright © 2016 Sajid Saeed. All rights reserved.
//

#import "SideMenuViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "DAAlertController.h"
#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
//#import "HomeViewViewController.h"
#import "FAQsViewController.h"
#import "EventSpeakersViewController.h"
#import "AgendaViewController.h"
#import "SponsorsViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "AttendeesViewController.h"
#import "loginResponse.h"
#import "Webclient.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "UserProfileResponse.h"
#import "UserProfileViewController.h"
#import "Utility.h"
#import "EventDetailDocViewController.h"
#import "UITableView+Helper.h"
#import "YPOMySchedule.h"
#import "YPOMediaPublication.h"
#import "YPOContainerViewController.h"
#import "EventSelectionViewController.h"
#import "YPONotificationVC.h"
#import "YPOChatListViewController.h"
#import "YPOPolicyViewController.h"
#import "UserProfileViewController.h"
#import "YPOChatViewController.h"
#import "YPORecentChatVc.h"
#import "NYAlertViewController.h"
#import "FAQsViewController.h"
#import "DAAlertController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "Webclient.h"
#import "ChangePasswordViewController.h"
#import "YPOGoldAndYPOMemberVc.h"
#import "YPOFeatureEventVc.h"
#import "YPOGroupChatViewController.h"
#import "YPOSplashForWhileVc.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>

@interface SideMenuViewController ()<UITableViewDataSource , UITableViewDelegate>  {
    UserProfileResponse *masterObj;
    __weak IBOutlet UITableView *tblView;

}



@end

@implementation SideMenuViewController
@synthesize ivProfilePic,lblProfileName,lblProfileDesignation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    
    [_lblEmail setText:[NSString stringWithFormat:@"%@", obj.loginUserName]];
    

    [tblView removeCellSeparatorOffset];
    [tblView removeSeperateIndicatorsForEmptyCells];
    
    ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
    ivProfilePic.clipsToBounds = YES;
    /*
     
    [self addSideMenuItems];
    [self initBadge];
    defaults = [NSUserDefaults standardUserDefaults];
    userData = [defaults rm_customObjectForKey:@"UserData"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMsgNotification:)
                                                 name:@"msgCountSidePanel"
                                               object:nil];
     
     */
    
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleSingleTap:)];
////    self.ivProfilePic.isUserInteractionEnabled = true ;
//    [self.ivProfilePic setUserInteractionEnabled:true];
    
    
    
//    [self.ivProfilePic addGestureRecognizer:singleFingerTap];

    
    
}
- (IBAction)btnInfoDetailBtn_Pressed:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController *esVC = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:esVC animated:YES];
    }];

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self fetchUser];
}


//- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
//{
////    UserProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
//
//
//
//
//
////    [self.navigationController pushViewController:vc animated:true];
//
//}


- (IBAction)editProfileButtonPressed:(id)sender {
   }

-(void) restoreData{

    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[masterObj.user.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.user.speakerThumbImg]]){
        [ivProfilePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
    }
    else{
        [ivProfilePic setImage:[UIImage imageNamed:@"ph_user_medium"]];
    }
    
    [lblProfileName setText:[NSString stringWithFormat:@"%@ %@", masterObj.user.speakerFirstName, masterObj.user.speakerLastName]];

    if(![Utility isEmptyOrNull:masterObj.user.speakerCompany]){
        [lblProfileDesignation setText:[NSString stringWithFormat:@"%@", masterObj.user.speakerCompany]];
    }
    else{
        [lblProfileDesignation setText:@""];
    }
    
}

-(void) fetchUser{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    [[Webclient sharedWeatherHTTPClient] getSideMenuUserProfile:[NSString stringWithFormat:@"%@", obj.loginUserID] viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        masterObj = (UserProfileResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
            [self restoreData];
        }

        
    } FailureBlock:^(NSError *error) {

    }];
}




- (IBAction)faqButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FAQsViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"faqVC"];
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
    }];
}

- (IBAction)attendeesButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AttendeesViewController *attendiesVC = [storyboard instantiateViewControllerWithIdentifier:@"attendeesVC"];
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:attendiesVC animated:YES];
    }];
}

- (IBAction)sponsorsButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SponsorsViewController *sponsorVC = [storyboard instantiateViewControllerWithIdentifier:@"sponsorVC"];
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
       // [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0] presentViewController:sponsorVC animated:YES completion:^{
            
       // }];
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:sponsorVC animated:YES];
        
    }];
}

- (IBAction)eventDetail:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventDetailDocViewController *evdVC = [storyboard instantiateViewControllerWithIdentifier:@"eventdetaildocVC"];
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:evdVC animated:YES];
    }];
}

- (IBAction)agendaButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AgendaViewController *agendaVC = [storyboard instantiateViewControllerWithIdentifier:@"agendaVC"];
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:agendaVC animated:YES];
    }];
}

- (IBAction)eventSpeakerButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventSpeakersViewController *esVC = [storyboard instantiateViewControllerWithIdentifier:@"esVC"];
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:esVC animated:YES];
    }];
}

- (IBAction)slackButtonPressed:(id)sender {
    NSString *stringURL = @"https://ibexleadership.slack.com";
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)logoutButtonPressed:(id)sender {
    DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                           style:DAAlertActionStyleCancel handler:nil];
    DAAlertAction *signOutAction = [DAAlertAction actionWithTitle:@"YES"
                                                            style:DAAlertActionStyleDestructive handler:^{
                                                                [self logout];
                                                            }];
    [DAAlertController showAlertViewInViewController:self
                                           withTitle:nil
                                             message:@"Are you sure, you want to go to event listing?"
                                             actions:@[cancelAction, signOutAction]];
}

-(void)logout{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AppDelegate *appsDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *eventListVC = [storyboard instantiateViewControllerWithIdentifier:@"eventListVC"];
    
    [appsDelegate.window setRootViewController:eventListVC];
    [appsDelegate.window makeKeyAndVisible];
    [UIView transitionWithView:appsDelegate.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
}

- (void) receiveMsgNotification:(NSNotification *) notification{
   
}
/*
-(void) initBadge{
    
    NSNumber *value = [NSNumber numberWithInteger:0];
    CGFloat fontSize = 7;
    msgBadge = [[UILabel alloc] init];
    msgBadge.font = [UIFont systemFontOfSize:fontSize];
    msgBadge.textAlignment = NSTextAlignmentCenter;
    msgBadge.textColor = [UIColor whiteColor];
    msgBadge.backgroundColor = [UIColor redColor];
    
    // Add count to label and size to fit
    msgBadge.text = [NSString stringWithFormat:@" "];
    [msgBadge sizeToFit];
    
    // Adjust frame to be square for single digits or elliptical for numbers > 9
    CGRect frame = msgBadge.frame;
    
    frame.size.height += (int)(0.4*fontSize);
    frame.size.width = ((int)value <= 9) ? frame.size.height : frame.size.width + (int)fontSize;
    
    frame.origin.x = 80;
    frame.origin.y = 0 - ((frame.size.height/2) - 8);
    msgBadge.frame = frame;
    
    // Set radius and clip to bounds
    msgBadge.layer.cornerRadius = frame.size.height/2.0;
    msgBadge.clipsToBounds = true;
    
    msgBadge.tag = 90;
    [msgBadge setHidden:YES];
    
    //[listButton addSubview:msgBadge];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [sideMenuTableView reloadData];
    [self fetchUserDetails];
    
    
}

- (IBAction)profileButtonPressed:(id)sender {
   
   // AFNetworkReachabilityManager *reach = [[AFNetworkReachabilityManager alloc] init];
    
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
        
        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
            //  [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:controller animated:YES];
            
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0] presentViewController:controller animated:YES completion:^{
                
            }];
        }];


}


-(void) fetchUserDetails{
    
    UserObject *obj = userData.response;
    
    //[[Webclient sharedWeatherHTTPClient] showProgressAlertOnView:nil message:@"Loading" view:uvProfileDisplay];
    
    [[Webclient sharedWeatherHTTPClient] getUserDetails:obj.userLoginEmail viewController:self CompletionBlock:^(UserDetailsResponse *responseObject) {
        
      //  [[Webclient sharedWeatherHTTPClient] hideProgressAlertOnView:uvProfileDisplay];
        
        if([responseObject.status isEqualToString:@"1"]){
            UserDetailsResponse *obj = responseObject;
            [lblProfileName setText:obj.userName];
            //[lblProfileDesignation setText:obj.userDesignation];
          
            [lblProfileDesignation setText:[NSString stringWithFormat:@"%@\n%@",obj.userDesignation , obj.userCompany]];
            
            NSURL *url = [NSURL URLWithString:obj.userPicURL];
//            [ivProfilePic setImageWithURL:url];
            
            [ivProfilePic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", obj.userPicURL]] placeholderImage:[UIImage imageNamed:@"profilePH"]];
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"%@", url] forKey:@"userPic"];
            [defaults synchronize];
            ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
            ivProfilePic.clipsToBounds = YES;
            
            NSLog(@"User Name: %@, User Designation: %@, Pic: %@", obj.userName, obj.userDesignation, obj.userPicURL);
        }
        else{
            
        }
        
    } FailureBlock:^(NSError *error) {
        //[[Webclient sharedWeatherHTTPClient] hideProgressAlertOnView:uvProfileDisplay];
    }];
}

-(void) addSideMenuItems{
    
    itemList = [[NSMutableArray alloc] init];
    
    SideMenuItem *item = [[SideMenuItem alloc] init];
    
    item.name = @"Messages";
    item.imageName = @"iconMessages";
    [itemList addObject:item];
    
    item = [[SideMenuItem alloc] init];
    
    item.name = @"Event Speakers";
    item.imageName = @"iconEventSpeaker";
    [itemList addObject:item];
    
    item = [[SideMenuItem alloc] init];
    
    item.name = @"Agenda";
    item.imageName = @"iconAgenda";
    [itemList addObject:item];
    
//    item = [[SideMenuItem alloc] init];
//    
//    item.name = @"Registration";
//    item.imageName = @"iconRegistration";
//    [itemList addObject:item];
    
    item = [[SideMenuItem alloc] init];
    
    item.name = @"Sponsors";
    item.imageName = @"iconStarMarkRed";
    [itemList addObject:item];
    
//    item = [[SideMenuItem alloc] init];
//    
//    item.name = @"Event Details";
//    item.imageName = @"iconEventDetail";
//    [itemList addObject:item];
    
    item = [[SideMenuItem alloc] init];
    
    item.name = @"Attendees";
    item.imageName = @"iconSponsors";
    [itemList addObject:item];
    
    item = [[SideMenuItem alloc] init];
    
    item.name = @"Q & A";
    item.imageName = @"iconQuestionMarkRed";
    [itemList addObject:item];
    
    item = [[SideMenuItem alloc] init];
    
    item.name = @"Slack";
    item.imageName = @"iconMessages";
    [itemList addObject:item];
    
    item = [[SideMenuItem alloc] init];
    
    item.name = @"Sync Data";
    item.imageName = @"iconSync";
    [itemList addObject:item];
//    item.name = @"MIT Video";
//    item.imageName = @"iconPromotional";
//    [itemList addObject:item];

    
}

-(void) loaddataoffline{
    
    UserObject *obj = userData.response;
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[Webclient sharedWeatherHTTPClient] showProgressAlertTitle:nil message:@"Loading..." view:[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController.view];
        
    }];
    
    [[Webclient sharedWeatherHTTPClient] getPartners:obj.userLoginEmail viewController:self CompletionBlock:^(PartnersResponse *responseObject) {
        
        for(PartnersResponse *page in responseObject.partnerList){
            UIImageView *iv = [[UIImageView alloc] init];
            if(![page.partnerImage isEqual:[NSNumber numberWithInt:0]] && ![Utility isEmptyOrNull:page.partnerImage]){
                [iv setImageWithURL:[NSURL URLWithString:page.partnerImage]];
            }
        }
        
        
        [[Webclient sharedWeatherHTTPClient] getResources:obj.userLoginEmail viewController:self CompletionBlock:^(ResourcesResponse *responseObject) {
            
            for(AssociatePage *page in responseObject.associatePages){
                UIImageView *iv = [[UIImageView alloc] init];
                if(![page.pageThumbnailImage isEqual:[NSNumber numberWithInt:0]] && ![Utility isEmptyOrNull:page.pageThumbnailImage]){
                    [iv setImageWithURL:[NSURL URLWithString:page.pageThumbnailImage]];
                }
            }
            
            [[Webclient sharedWeatherHTTPClient] getSchedules:obj.userLoginEmail viewController:self CompletionBlock:^(ResourcesResponse *responseObject) {
                
                for(AssociatePage *page in responseObject.associatePages){
                    UIImageView *iv = [[UIImageView alloc] init];
                    if(![page.pageThumbnailImage isEqual:[NSNumber numberWithInt:0]] && ![Utility isEmptyOrNull:page.pageThumbnailImage]){
                        [iv setImageWithURL:[NSURL URLWithString:page.pageThumbnailImage]];
                    }
                }
                
                [[Webclient sharedWeatherHTTPClient] getAttendiesContactList:obj.userLoginEmail isSpouseList:@"0" viewController:self CompletionBlock:^(AttendiesResponse *attendiesObj) {
                    

                    
                    
                    [[Webclient sharedWeatherHTTPClient] getUserDetails:obj.userLoginEmail viewController:self CompletionBlock:^(UserDetailsResponse *responseObject) {
                        
                        UserDetailsResponse *obj = responseObject;
                        UIImageView *iv = [[UIImageView alloc] init];
                        if(![obj.userPicURL isEqual:[NSNumber numberWithInt:0]] && ![Utility isEmptyOrNull:obj.userPicURL]){
                            [iv setImageWithURL:[NSURL URLWithString:obj.userPicURL]];
                        }
                        

                        
                        [self performSelector:@selector(hideprogressbar) withObject:nil afterDelay:5];
                        
                        
                    } FailureBlock:^(NSError *error) {
                        [[Webclient sharedWeatherHTTPClient] hideProgressAlert];
                    }];
                    
                    
                } FailureBlock:^(NSError *error) {
                    [[Webclient sharedWeatherHTTPClient] hideProgressAlert];
                    
                }];
            } FailureBlock:^(NSError *error) {
                [[Webclient sharedWeatherHTTPClient] hideProgressAlert];
                
            }];
            
        } FailureBlock:^(NSError *error) {
            [[Webclient sharedWeatherHTTPClient] hideProgressAlert];
        }];
        
        
        
    } FailureBlock:^(NSError *error) {
        [[Webclient sharedWeatherHTTPClient] hideProgressAlert];
    }];
    
}

-(void) hideprogressbar{
    [[Webclient sharedWeatherHTTPClient] hideProgressAlert];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemList.count;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuItem *item = [itemList objectAtIndex:indexPath.row];
    UIViewController *controller = [[UIViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewViewController *webView = [[WebViewViewController alloc] init];

    
    if([item.name isEqualToString:@"Event Speakers"]){
        controller = [storyboard instantiateViewControllerWithIdentifier:@"ResourcesVC"];
    }
    else if([item.name isEqualToString:@"Agenda"]){
        controller = [storyboard instantiateViewControllerWithIdentifier:@"ScheduleVC"];
    }
    else if([item.name isEqualToString:@"Registration"]){
        controller = [storyboard instantiateViewControllerWithIdentifier:@"registerView"];
    }
    else if([item.name isEqualToString:@"Sponsors"]){
        controller = [storyboard instantiateViewControllerWithIdentifier:@"sponsorsView"];
    }
    else if([item.name isEqualToString:@"Event Details"]){
        controller = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailView"];
    }
    else if([item.name isEqualToString:@"Attendees"]){
        controller = [storyboard instantiateViewControllerWithIdentifier:@"GroupOneVC"];
    }
    else if([item.name isEqualToString:@"Sync Data"]){
        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
            HomeScreenViewController *homeVC = [[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0];
            [homeVC loaddataoffline:2];
        }];
        return;
    }
    else if([item.name isEqualToString:@"Travel Guide"]){
        NSString *stringURL = @"http://www.coloursofindus.com/travel-guide";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
        return;
    }
    else if([item.name isEqualToString:@"Slack"]){
        
        NSString *stringURL = @"https://mitcnc.slack.com";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];

        return;
    }
//    else if([item.name isEqualToString:@"COI'17 Video"]){
//        NSString *stringURL = @"https://www.youtube.com/watch?v=zwgewkl5Lxw";
//        NSURL *url = [NSURL URLWithString:stringURL];
//        [[UIApplication sharedApplication] openURL:url];
//        return;
//    }
    else if([item.name isEqualToString:@"Q & A"]){
        webView = [storyboard instantiateViewControllerWithIdentifier:@"qnaVC"];
        webView.heading = @"Q & A";
        webView.isURLlink = @"false";
        webView.websiteLink = @"<iframe src=\"https://app.sli.do/event/icbtyvah\"; frameborder=\"0\" height=\"400\" width=\"100%\"></iframe>";
        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:webView animated:YES];
        }];
        return;
    }
    else if([item.name isEqualToString:@"Messages"]){
        
        [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
             [self intiateCometChat];
        }];
       
       // controller = [storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
        
        return;
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  //[self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Under Construction!" message:@"This feature is under construction." actions:@[dismissAction]];

        return;
    }
    
    [[self sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
        [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:controller animated:YES];
    }];
}

-(void) intiateCometChat{
    
    //[Utility initComitChatMainScreen:[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController];
      [Utility initComitChatMainScreen:[Utility topViewController]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SideMenuCell";
    SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[SideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    
    SideMenuItem *obj = [itemList objectAtIndex:indexPath.row];

    if([[obj.name lowercaseString] isEqualToString:@"messages"]){
        NSNumber *tempMsgNumber = [defaults objectForKey:@"msgNumber"];
        if([tempMsgNumber isEqualToNumber:[NSNumber numberWithInt:0]] || tempMsgNumber==nil){
            [cell.ivAlertIcon setHidden:YES];
        }
        else{
            [cell.ivAlertIcon setHidden:NO];
        }
    }
    else{
        [cell.ivAlertIcon setHidden:YES];
    }

    [cell.itemName setText:obj.name];
    [cell.itemImageName setImage:[UIImage imageNamed:obj.imageName]];
    
    return cell;
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableView Method-


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  12 ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SideMenu"];
    
    
    
        if (indexPath.row == 0) {
            cell.textLabel.text = @"YPO Policy";
            cell.imageView.image = UIImageWithName(@"menu-policy") ;
            
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Event Calendar";
            cell.imageView.image = UIImageWithName(@"menu-calendar") ;
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"My Schedule";
            cell.imageView.image = UIImageWithName(@"menu-myschedule") ;
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"Feature Events" ;
            cell.imageView.image = UIImageWithName(@"menu-featuredevents") ;
            
        }
        else if (indexPath.row == 4)
        {
            cell.textLabel.text = @"Media" ;
            cell.imageView.image = UIImageWithName(@"menu-media") ;

        }
        else if (indexPath.row == 5)
        {
            cell.textLabel.text = @"Members and Spouses" ;
            cell.imageView.image = UIImageWithName(@"menu-members") ;
            
        }
        else if (indexPath.row == 6)
        {
            cell.textLabel.text = @"Board Members" ;
            cell.imageView.image = UIImageWithName(@"menu-boardmembers") ;
            
        }
        else if (indexPath.row == 7)
        {
            cell.textLabel.text = @"Chat" ;
            cell.imageView.image = UIImageWithName(@"menu-chat") ;
            
        }
        else if (indexPath.row == 8)
        {
            cell.textLabel.text = @"Notifications" ;
            cell.imageView.image = UIImageWithName(@"menu-notification") ;
            
        }
        else if (indexPath.row == 9)
        {
            cell.textLabel.text = @"FAQs" ;
            cell.imageView.image = UIImageWithName(@"faq") ;
            
        }
        else if (indexPath.row == 10)
        {
            cell.textLabel.text = @"Change Password" ;
            cell.imageView.image = UIImageWithName(@"changepass") ;
            
        }
        else if (indexPath.row == 11)
        {
            cell.textLabel.text = @"Logout" ;
            cell.imageView.image = UIImageWithName(@"logout") ;
            
        }
//        else if (indexPath.row == 12)
//        {
//            cell.textLabel.text = @"Group Chat" ;
//            cell.imageView.image = UIImageWithName(@"Chat") ;
//
//        }
    return cell ;
    
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        [self popUpForCalender];

        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        EventSelectionViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"EventSelectionViewController"];
//        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
//            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
//        }];
    }

    else  if (indexPath.row == 0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YPOPolicyViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOPolicyViewController"];
        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }

   else  if (indexPath.row == 2)
   {
       
       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       YPOMySchedule *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOMySchedule"];
       faqVC.pushType = 1 ;
       
       [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
           [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
       }];

//    [self popUpForCalender];
    
       
    }
    
   else  if (indexPath.row == 3)
   {
       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
       YPOFeatureEventVc *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOFeatureEventVc"];
       [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
           [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
       }];
   }
    
    else  if (indexPath.row == 4)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YPOMediaPublication *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOMediaPublication"];
        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }
    
    else if (indexPath.row == 5)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YPOGoldAndYPOMemberVc *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOGoldAndYPOMemberVc"];
        faqVC.valueForMember = 1 ;
        faqVC.titleOfSelected = @"Members";
        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }
    else  if (indexPath.row == 6)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YPOGoldAndYPOMemberVc *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOGoldAndYPOMemberVc"];
        faqVC.valueForMember = 2 ;
        faqVC.titleOfSelected = @"Board Members";

        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }
    else  if (indexPath.row == 7)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YPORecentChatVc *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPORecentChatVc"];
        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }

   
    else  if (indexPath.row == 8)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YPONotificationVC *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPONotificationVC"];
        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }
    else  if (indexPath.row == 10)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChangePasswordViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"changepassVC"];
        faqVC.comeForSideMenuOrTab = 1 ;
        
        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }
//
    
    else  if (indexPath.row == 9)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FAQsViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"faqVC"];
        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
        }];
    }
//    else  if (indexPath.row == 12)
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        YPOGroupChatViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOGroupChatViewController"];
//        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
//            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
//        }];
//    }
    else  if (indexPath.row == 11)
    {
        [self logOut];
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        FAQsViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"faqVC"];
//        [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
//            [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
//        }];
    }

    
//

}

#pragma mark - Custom Alert for Calender -
-(void)popUpForCalender
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = @"YPO";
    alertViewController.message = @"Choose Event Calendar Type?";
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithRed:15/255.0  green:45/255.0 blue:65/255.0 alpha:1.0];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Monthly"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              
                                          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                          YPOMySchedule *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOMySchedule"];
                                          faqVC.pushType = 1 ;
                                          [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
                                          [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
                                      }];

                              }]];
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Annual"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];

                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                              YPOSplashForWhileVc *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOSplashForWhileVc"];

//                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                                              EventSelectionViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"EventSelectionViewController"];
                                                              [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
                                                                  [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
                                                              }];

                                                              }]] ;
    
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}

#pragma mark - Custom Alert for Logout -
-(void)logOut
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = @"YPO";
    alertViewController.message = @"Are you sure do you want to Logout ?";
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithRed:15/255.0  green:45/255.0 blue:65/255.0 alpha:1.0];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                              if([Utility connectedToNetwork]){
                                                                  [self logoutForWeb];

                                                              } else {
                                                                  [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error"];
                                                              }
                                                              
//                                                              NUSplashScreenController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NUSplashScreenController"];
//                                                              [SessionManager saveSession:nil];
//                                                              [self.navigationController presentViewController:vc animated:true completion:^{
//
//                                                              }]
                                                              ;}]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
                                    
    -(void) logoutForWeb
        {
                                        
        [[Webclient sharedWeatherHTTPClient] logout:self CompletionBlock:^(NSObject *responseObject) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            
            NSString *fullActionLabel = [NSString stringWithFormat:@"%@ (%@) %@" , obj.loginDisplayName,obj.loginUserID ,@"logouts"];
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                                  action:@"User Logout"
                                                                   label:fullActionLabel
                                                                   value:nil] build]];
            
            [defaults removeObjectForKey:@"UserData"];
            [defaults synchronize];
            AppUtility.isOnlineForChat = NO ;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVc"];
            [self presentViewController:vc animated:YES completion:^{
                
            }];

//                                            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                                                    style:DAAlertActionStyleCancel
//                                                                                                  handler:^{
//
//                                                                                                      //[self.navigationController popViewControllerAnimated:YES];
//                                                                                                  }];
//
//                                            [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"User logged out successfully." actions:@[dismissAction]];
            
        } FailureBlock:^(NSError *error) {
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                                                    style:DAAlertActionStyleCancel
                                                  handler:^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                      }];
                                            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
                }];
                                        
    }
                                    

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60.0 ;
    
}



@end
