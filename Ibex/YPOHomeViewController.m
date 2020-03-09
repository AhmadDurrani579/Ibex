//
//  YPOHomeViewController.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOHomeViewController.h"
#import "Utility.h"
#import "UIViewController+LGSideMenuController.h"
#import "SideMenuViewController.h"
#import "YPOMediaPublication.h"
#import "EventSelectionViewController.h"
#import "YPOMySchedule.h"
#import "YPOContainerViewController.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "WAHomePageContainerVC.h"
#import "YPOFeatureEventVc.h"
#import "YPOSplashForWhileVc.h"
#import "AppDelegate.h"
#import "DBChatManager.h"
#import "XMPPvCardTemp.h"
#import "YPORecentChatVc.h"
#import "YPONotificationVC.h"
#import "YPOSearchContainerVC.h"
#import "YPOSearchEventListVc.h"
#import "UIButton+Badge.h"
#import "Constant.h"
#import "YPOGoldAndYPOMemberVc.h"
#import "AppDelegate.h"
#import "NYAlertViewController.h"
#import "YPOMySchedule.h"
#import "Webclient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SVHTTPRequest.h"
#import "MOGroup.h"
#import "ChatRooms+CoreDataClass.h"

//#import <GoogleAnalytics/GAI.h>
//#import <GoogleAnalytics/GAIDictionaryBuilder.h>
//#import <GAIFields.h>



@interface YPOHomeViewController ()
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *viewOfMySchedule;
    __weak IBOutlet UIView *viewOfCalender;
    __weak IBOutlet UIView *viewOfFeatureEvents;
    __weak IBOutlet UIView *viewOfResource;
    __weak IBOutlet UIView *viewOfMembers;
    __weak IBOutlet UIView *viewOfBoardMember;
    __weak IBOutlet UIView *viewOfAlert;
    IBOutlet UIButton *btnChat;
    AppDelegate *app ;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnNotify;
}
@property (nonatomic,strong) ChatRooms *roomChat;

@end

@implementation YPOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (!AppUtility.isOnlineForChat) {
//        [SharedDBChatManager makeConnectionWithChatServer];
//    }
    
//    UserInfo *u = [MOUser getUser].loginUserId;
    
    app = (AppDelegate*) [UIApplication sharedApplication].delegate;

              
   
                 
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [lblTitle addGestureRecognizer:singleFingerTap];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [Utility setViewBorder:viewOfMySchedule withWidth:2.0 andColor:[UIColor colorWithRed:2/255 green:38/255 blue:60/255 alpha:1.0]];
    [Utility setViewBorder:viewOfCalender withWidth:2.0 andColor:[UIColor colorWithRed:2/255 green:38/255 blue:60/255 alpha:1.0]];
    [Utility setViewBorder:viewOfFeatureEvents withWidth:2.0 andColor:[UIColor colorWithRed:2/255 green:38/255 blue:60/255 alpha:1.0]];
    [Utility setViewBorder:viewOfResource withWidth:2.0 andColor:[UIColor colorWithRed:2/255 green:38/255 blue:60/255 alpha:1.0]];
    [Utility setViewBorder:viewOfMembers withWidth:2.0 andColor:[UIColor colorWithRed:2/255 green:38/255 blue:60/255 alpha:1.0]];
    [Utility setViewBorder:viewOfBoardMember withWidth:2.0 andColor:[UIColor colorWithRed:2/255 green:38/255 blue:60/255 alpha:1.0]];
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasInternetConnection) name:@"HasInternetConnection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noInternetConnection) name:@"NoInternetConnection" object:nil];

    
   


//    dispatch_async(dispatch_get_main_queue(), ^{
//        if([[NSUserDefaults standardUserDefaults] boolForKey:@"logged_inFirstTime"]) {
//
//        } else {
//            [self getAllGroup];
//        }
//    });
    
//    [[NSNotificationCenter defaultCenter] addObserver: self
//                                             selector: @selector(reachabilityChanged:)
//                                                 name: kReachabilityChangedNotification
//                                               object: nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"registerDeviceFirstTime"]) {
        
        } else {
            [self registerDevice];
    }
        

    });
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSString *fullActionLabel = [NSString stringWithFormat:@"%@ (%@) %@" , obj.loginDisplayName,obj.loginUserID ,@"starts app"];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"App open"
                                                           label:fullActionLabel
                                                           value:nil] build]];

        
    
}

-(void) getAllGroup {
   
 if([Utility connectedToNetwork]){
    
    NSString *serviceName  = [NSString stringWithFormat:WEBService_ChatRoomGroup];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    [SVHTTPRequest GetAllGroup:serviceName parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (response!=nil) {
//            if ([response isKindOfClass:[NSData class]] || ((NSData *)response).length > 0) {

            MOGroup *group = [[MOGroup alloc]initWithDictionary:response];
            [group.ownerOfGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *member  ;
                id  groupMember = [obj valueForKey:@"members"] ;

                if (groupMember == [NSNull null]){
                    NSLog(@"No member");
                } else {
//                    if ([[obj objectForKey:@"members"] isKindOfClass:[NSDictionary class]]) {
//                        member    = [[obj valueForKey:@"members"]objectForKey:@"member"];
//                    }
//                    else if ([[obj objectForKey:@"members"] isKindOfClass:[NSArray class]]) {
//                        member    = [[obj valueForKey:@"members"]objectForKey:@"member"];
//                    }

                    member    = [[obj valueForKey:@"members"]objectForKey:@"member"];

                }
                NSString *owner          = [[obj valueForKey:@"owners"]objectForKey:@"owner"];
                NSString *myJID          = [NSString stringWithFormat:@"%@@ibexglobal.com", userInfo.loginUserID]; //
                NSString *subject        = [obj valueForKey:@"subject"]; //
                NSString *roomName       = [obj valueForKey:@"roomName"]; //
                

                if ([member containsObject:myJID] || [owner isEqualToString:myJID]) {
                    
                    _roomChat = (ChatRooms *)[ChatRooms create];
                    _roomChat.room_Name  = subject ;
                    _roomChat.roomJbID = [NSString stringWithFormat:@"%@%@ibexglobal.com",roomName,kBaseConfrence] ;
                    _roomChat.userJbID = [NSString stringWithFormat:@"%@",[SharedDBChatManager xmppStream].myJID.user] ;
                    [ChatRooms save];

                } else {
                    NSLog(@"Not Contain");
                }
                
            
            }] ;
            
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_inFirstTime"];

//        }
    }
        
        
    }] ;
    
    } else {
        [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];

    }
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:true animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotificationScreen:) name:@"Push" object:nil];
    app.isNotifyOfGroupChat = false ;
//    if([Utility connectedToNetwork]){
//        if (!AppUtility.isOnlineForChat) {
//            [SharedDBChatManager makeConnectionWithChatServer];
//        }
//
//    }else {
//
//    }
    
}

-(void)hasInternetConnection{
    NSLog(@"Internet Conneection") ;
//    [self setupConnection];

        dispatch_async(dispatch_get_main_queue(), ^{
            [SharedDBChatManager makeConnectionWithChatServer];

        });
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Home Screen"];
//    [tracker sendView:@"Home Screen"];
//    [tracker setScreen:@"Home Screen"];
//    [tracker send:[[[GAIDictionaryBuilder createScreenView] set:@"Home Screen"
//                                                         forKey:@"Home Screen"] build]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

-(void)noInternetConnection{
    NSLog(@"No Internet Conneection") ;
    
//    [[SharedDBChatManager xmppStream] removeDelegate:self];
//    [[SharedDBChatManager xmppStream] disconnect];

//        [SharedDBChatManager teardownStream];

//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });


}


-(void) registerDevice {
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"fcmToken"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
   [[Webclient sharedWeatherHTTPClient] registerDeviceToken:savedValue createDate:@"" modifiedDate:@"" deviceType:@"iOS" userID:obj.loginUserID viewController:nil CompletionBlock:^(NSObject *responseObject) {
        NSLog(@"print it %@", responseObject);
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"registerDeviceFirstTime"];

        
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.ypowpo.org/"]];
}

- (void)notifiationRemoved:(NSNotification*)notif
{
    btnChat.badgeValue = @"" ;
}
- (void)notifiationReceiveced:(NSNotification*)notif
{
    NSString *myString ;
    int myInt = [btnChat.badgeValue intValue];// I assume you need it as an integer.
    myString= [NSString stringWithFormat:@"%d",++myInt];
    btnChat.badgeValue = myString ;
}


//
//override var preferredStatusBarStyle: UIStatusBarStyle {
//    return .lightContent }
//



-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Push" object:nil];
    
}
- (IBAction)btnChat_Pressed:(UIButton *)sender {
    YPORecentChatVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPORecentChatVc"];
    [self makeConnectionWithXmppAgain];
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btnNotification_Pressed:(UIButton *)sender {
    YPONotificationVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPONotificationVC"];
    [self makeConnectionWithXmppAgain];
//    [FIRAnalytics logEventWithName:@"notification_ScreenAppear" parameters:nil];
    [self.navigationController pushViewController:vc animated:true];
}


- (IBAction)btnSearch_Pressed:(UIButton *)sender {
    
    YPOSearchEventListVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSearchEventListVc"];
    [self makeConnectionWithXmppAgain];

    [self.navigationController pushViewController:vc animated:true];

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
                                                              [self.navigationController pushViewController:faqVC animated:true] ;

                                                              
//                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                                              YPOMySchedule *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOMySchedule"];
//                                                              faqVC.pushType = 1 ;
//
//                                                              [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
//                                                                  [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
//                                                              }];
                                                              
                                                          }]];
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Annual"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              
                                                              
                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                              YPOSplashForWhileVc *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"YPOSplashForWhileVc"];
                                                              [self.navigationController pushViewController:faqVC animated:true] ;
//                                                              [[self sideMenuController] hideLeftViewAnimated:NO completionHandler:^{
//                                                                  [[[[[self sideMenuController] rootViewController] childViewControllers] objectAtIndex:0].navigationController pushViewController:faqVC animated:YES];
//                                                              }];
                                                              
                                                          }]] ;
    
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}



#pragma mark - Custome Methods -
- (void) showNotificationScreen:(NSNotification *)notification
{
    NSDictionary *userInfoss = notification.userInfo ;
    NSDictionary *message   = [userInfoss valueForKey:@"groupId"];
//    NSString *titleOfAlert = [message valueForKey:@"title"];
//    NSString *bodyOfAlert = [message valueForKey:@"body"];
    YPORecentChatVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPORecentChatVc"];
    vc.jabberIdOfPush = message ;
    
    [self.navigationController pushViewController:vc animated:true];

    
//    NUSubmitQuoteViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NUSubmitQuoteViewController"];
//    NSDictionary *data = notification.userInfo[@"data"];
//    NSString *alert = [data utilities_objectForKeyNotNull:@"alert"];
//    NSError *jsonError;
//    NSData *objectData = [alert dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                         options:NSJSONReadingMutableContainers
//                                                           error:&jsonError];
//    NSMutableArray *arrayOfPostData = [json valueForKey:@"postData"];
//    NSString *jobId = [arrayOfPostData valueForKey:@"jobId"];
//    vc.jobID = jobId ;
//    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btnToggleOffOn_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// btn Action Method


- (IBAction)btnYPOCalender:(UIButton *)sender {
    
//    EventSelectionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EventSelectionViewController"];
//    [self makeConnectionWithXmppAgain];
//
//    [self.navigationController pushViewController:vc animated:true];
    [self popUpForCalender];
}

- (IBAction)btnSideMenu_Presses:(UIButton *)sender {
    [self openLeftList];
    [self makeConnectionWithXmppAgain];
}
- (IBAction)btnMedia_Pressed:(UIButton *)sender {
    
    YPOMediaPublication *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMediaPublication"];
    [self makeConnectionWithXmppAgain];

    [self.navigationController pushViewController:vc animated:true];
//
    
}
- (IBAction)btnMySchedule_Pressed:(UIButton *)sender {
    
    YPOMySchedule *faqVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMySchedule"];
    [self makeConnectionWithXmppAgain];
    app.slectedView = 1 ;
//    faqVC.pushType = 2 ;
    [self.navigationController pushViewController:faqVC animated:true] ;

    //    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//
//    YPOSplashForWhileVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSplashForWhileVc"];
//    [self makeConnectionWithXmppAgain];
//
//    appDelegate.slectedView = 1 ;
//
//
//    [self.navigationController pushViewController:vc animated:true];

}

- (IBAction)btnEventFeature:(UIButton *)sender {
    
    YPOFeatureEventVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOFeatureEventVc"];
    [self makeConnectionWithXmppAgain];

    [self.navigationController pushViewController:vc animated:true];
}


- (IBAction)btnMember :(UIButton *)sender {
    
    YPOGoldAndYPOMemberVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGoldAndYPOMemberVc"];
    vc.valueForMember = 1 ;
    vc.titleOfSelected = @"Members and Spouses" ;

    [self makeConnectionWithXmppAgain];

//    WAHomePageContainerVC
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btnBoardMemver :(UIButton *)sender {
    [self makeConnectionWithXmppAgain];

    YPOGoldAndYPOMemberVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGoldAndYPOMemberVc"];
    vc.valueForMember = 2 ;
    vc.titleOfSelected = @"Board Members" ;

    [self.navigationController pushViewController:vc animated:true];
}

-(void)makeConnectionWithXmppAgain {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//    [SharedDBChatManager makeConnectionWithChatServer] ;

    if (!AppUtility.isOnlineForChat) {
        [SharedDBChatManager makeConnectionWithChatServer] ;
      }
        XMPPvCardTemp *myVcardTemp = [[DBChatManager shareInstance].xmppvCardTempModule myvCardTemp];
        if (!myVcardTemp) {
            myVcardTemp = [XMPPvCardTemp vCardTemp];
        }
    
        [myVcardTemp setFormattedName:obj.loginUserName];
        [myVcardTemp setNickname:obj.loginDisplayName];
    
        NSXMLElement *email  = [NSXMLElement elementWithName:@"NAME"];
        NSXMLElement *home   = [NSXMLElement elementWithName:@"HOME"];
        NSXMLElement *userId = [NSXMLElement elementWithName:@"USERID" stringValue:obj.loginUserName];
        [email addChild:home];
        [email addChild:userId];
        [myVcardTemp addChild:email];
    
        [[DBChatManager shareInstance].xmppvCardTempModule updateMyvCardTemp:myVcardTemp];
}

-(void)openLeftList{
    [[self sideMenuController] showLeftViewAnimated:true completionHandler:nil];
}

- (IBAction)btnCross_Pressed:(UIButton *)sender {
    [viewOfAlert setHidden:true];
    
}


@end
