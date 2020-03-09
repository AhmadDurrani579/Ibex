//
//  AppDelegate.m
//  Ibex
//
//  Created by Sajid Saeed on 22/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "AppDelegate.h"
#import "Webclient.h"
#import "MainViewController.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "ViewController.h"
#import "Notification+CoreDataClass.h"
#import "Utility.h"
#import "DBChatManager.h"
#import "GroupChatMessageStatus+CoreDataClass.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>

//#import <Fabric/Fabric.h>
////#import <Crashlytics/Crashlytics.h>
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate , TWMessageBarStyleSheet>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@import FirebaseMessaging;
@import FirebaseInstanceID;
@import Firebase;
@import GoogleMaps;


@interface AppDelegate () <CLLocationManagerDelegate, FIRMessagingDelegate>{
    NSString *InstanceID;
    
}
@property (nonatomic,strong) Notification *eventNotification;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic,strong) GroupChatMessageStatus *userMessageStatus;




@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _groupsMembers_Detail = [[NSMutableArray alloc] init];
    
    GAI *gai = [GAI sharedInstance];
    [gai trackerWithTrackingId:@"UA-123160879-1"];
    [GAI sharedInstance].dispatchInterval = 5;

    // Optional: automatically report uncaught exceptions.
    gai.trackUncaughtExceptions = YES;

    // Optional: set Logger to VERBOSE for debug information.
    // Remove before app release.
     gai.logger.logLevel = kGAILogLevelVerbose;
    
    _pushType = 0 ;
//    [Fabric with:@[[Crashlytics class]]];
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    reachability = [Reachability reachabilityForInternetConnection];
//    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleNetworkChange:) name: @"Notify" object: nil];
//
//    [reachability startNotifier];
    
    [self startMonitoringInternetConnection];

    _isViewVisible = true ;
    _userList = [[YPOSearchEventList alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    application.applicationIconBadgeNumber = 0;
    
    
    if(self.window == nil)
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    [GMSServices provideAPIKey:@"AIzaSyC5F-N1pmMBg8LpGMmZyBlTMh9GTeLoY8Q"];


    [locationManager startUpdatingLocation];

    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]) {
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
//                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    
    

    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];

    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    if (obj == nil)
    {
        [self loadSplashController];
    }
    else
    {
        [self gotoDashboard];
        
    }

    

//    [self gotoDashboard];
    

    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//    UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//    UINavigationBar.appearance().shadowImage = UIImage()

    
    
    [FIRApp configure];
  
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [FIRMessaging messaging].delegate = self;

    });
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:
     [UIUserNotificationSettings settingsForTypes:
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
    [application registerForRemoteNotifications];

    return YES;
}

-(void)startMonitoringInternetConnection{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BOOL hasInternet = (status != AFNetworkReachabilityStatusNotReachable && status != AFNetworkReachabilityStatusUnknown);
        
        if (hasInternet) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HasInternetConnection" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoInternetConnection" object:nil];
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}



#pragma mark- AlertDelegate

- (UIColor *)backgroundColorForMessageType:(TWMessageBarMessageType)type{
    //    return [UIColor colorWithRed:0.0 green:0.482 blue:1.0 alpha:0.96]; //[UIColor colorWithRed:(52/255.0) green:133/255.0 blue:204/255.0 alpha:1.0];
    return  [UIColor colorWithRed:13/255.0 green:62/255.0 blue:91/255.0 alpha:1.0];
}

- (UIColor *)strokeColorForMessageType:(TWMessageBarMessageType)type{
    return  [UIColor blackColor];
    
    //    return [UIColor colorWithRed:0.0f green:0.415f blue:0.803f alpha:1.0f];
}

- (UIImage *)iconImageForMessageType:(TWMessageBarMessageType)type{
    return self.image?:[UIImage imageNamed:@"ph_user_medium"];
}

- (void)loadSplashController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    [SharedDBChatManager setupStream];
    ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginVc"];
    self.window.rootViewController = controller;
}

- (void)loadDashboardController {
}

//-(void)registerForRemoteNotifications{
//
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
//        UIUserNotificationType allNotificationTypes =
//        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings =
//        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        // iOS 10 or later
//#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//        UNAuthorizationOptions authOptions =
//        UNAuthorizationOptionAlert
//        | UNAuthorizationOptionSound
//        | UNAuthorizationOptionBadge;
//        [[UNUserNotificationCenter currentNotificationCenter]
//         requestAuthorizationWithOptions:authOptions
//         completionHandler:^(BOOL granted, NSError * _Nullable error) {
//         }
//         ];
//
//        // For iOS 10 display notification (sent via APNS)
//        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
//        // For iOS 10 data message (sent via FCM)
//        [[FIRMessaging messaging] setRemoteMessageDelegate:self];
//#endif
//    }
//
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//}


- (void)tokenRefreshNotification:(NSNotification *)notification {

    NSString *refreshedToken = [[FIRInstanceID instanceID] token];

    if (![[[FIRInstanceID instanceID] token] isKindOfClass:[NSNull class]] && [[FIRInstanceID instanceID] token]!=nil) {

//        NSLog(@"what's here %@",refreshedToken);
//        SetNSUserDefault([[FIRInstanceID instanceID] token], kDeviceToken);
//        SyncroniseNSUserDefault;

        [self connectToFcm];
    }

    NSLog(@"InstanceID token: %@", refreshedToken);


}


// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    NSDictionary *userInfo = notification.request.content.userInfo;
    NSDictionary *message   = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
    
    NSString *title = [message valueForKey:@"title"];

    NSString *titleOfAlert  = [message valueForKey:@"message"];
    NSString *bodyOfAlert   = [message valueForKey:@"body"];
    NSString *groupName     = [userInfo valueForKey:@"groupName"];
    NSString *senderName    = [userInfo valueForKey:@"senderName"];

    NSString *groupId       = [userInfo valueForKey:@"groupId"];
    NSString *receiverId    =   [message valueForKey:@"receiverId"];


    
    if (groupName == nil){
        
    }else {
        NSString *txtString = [NSString stringWithFormat:@"%@", bodyOfAlert];
        NSString *finlaNameOfRoom ;
        NSString *nameOfGroup ;
        if(self.isNotifyOfGroupChat == false){
            
            _userMessageStatus = (GroupChatMessageStatus *)[GroupChatMessageStatus create];
            _userMessageStatus.messageStatus = @"Unread";
            _userMessageStatus.jabberIdOfUser = groupId ;
            [GroupChatMessageStatus save];
            
            [NotifCentre postNotificationName:kGroupChatMessageReceived object:nil];
            [NotifCentre postNotificationName:kGroupChatUIUpdate object:nil];

            [NotifCentre postNotificationName:kChatNotificationReceived object:nil];

            if ([groupName containsString:@"@"]) {
                groupName = [groupName substringWithRange: NSMakeRange(0, [groupName rangeOfString: @"@"].location)];
                finlaNameOfRoom = [[groupName componentsSeparatedByCharactersInSet:
                                              [[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
                NSString *newString = [finlaNameOfRoom substringToIndex:[finlaNameOfRoom length]-1];
                nameOfGroup = [newString substringToIndex:[newString length]-1];

                NSLog(@"print it %@", nameOfGroup);
                
                //                NSString *start = [groupName stringByReplacingOccurrencesOfString:@"T"
//                                                                           withString:@"  "];

            }
            
            [TWMessageBarManager sharedInstance].styleSheet = self;
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [[TWMessageBarManager sharedInstance] showMessageWithTitle:groupName description:txtString type:TWMessageBarMessageTypeSuccess statusBarStyle:UIStatusBarStyleDefault callback:^{
                    
                }];
            });
        }
     
    }
  
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

   

    if (userInfo[kGCMMessageIDKey]) {
        NSNumber *value = [prefs objectForKey:@"notificationNumber"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Push" object:nil userInfo:userInfo];

        // NSNumber *feedNotif = [prefs objectForKey:@"notificationFeedbackNumber"];
        //NSNumber *normalNotif = [prefs objectForKey:@"notificationNormalNumber"];
        
        int count = [value intValue];
        count++;
        value = [NSNumber numberWithInt:count];
        [prefs setObject:value forKey:@"notificationNumber"];
        [prefs synchronize];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushCount"
         object:self];
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}
#endif
// [END ios_10_message_handling]

// [START refresh_token]
- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    
//    NSString *fcmTokenOfObj = [FIRMessaging messaging].FCMToken;
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:@"fcmToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}
// [END ios_10_data_message]

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
// the FCM registration token.



- (void)messaging:(FIRMessaging* )messaging didReceiveRegistrationToken:(NSString* )fcmToken {
  
  
    NSLog(@"FCM registration token: %@", fcmToken);
    
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}


-(void)application:(UIApplication *)application
                        didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    [FIRMessaging messaging].APNSToken = deviceToken ;
}

//- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//{
//    NSLog(@"My token is: %@", deviceToken);
//
//
//
//
//    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
//                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:@"deviceToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//
//
//
//    [prefs setObject:newToken forKey:@"token"];
//    [prefs synchronize];
//
//
//    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
//
//    [[FIRMessaging messaging] subscribeToTopic:@"ios"];
//}

//- (void)tokenRefreshNotification:(NSNotification *)notification {
//    NSLog(@"instanceId_notification=>%@",[notification object]);
//
//
//
//    InstanceID = [NSString stringWithFormat:@"%@",[notification object]];
//
//     [self connectToFcm];
//}

- (void)connectToFcm {
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            
            NSLog(@"InstanceID_connectToFcm = %@", InstanceID);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                     [self sendDeviceInfo];
                    NSLog(@"instanceId_tokenRefreshNotification22=>%@",[[FIRInstanceID instanceID] token]);
                    
                });
            });
            
            
        }
    }];
}


//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
//
//    handler(UIBackgroundFetchResultNewData);
//
//}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if([[userInfo objectForKey:@"action"] isEqualToString:@"PARSE_MSG"]){
        NSNumber *msgVal = [prefs objectForKey:@"msgNumber"];

        int count = [msgVal intValue];
        count++;
        msgVal = [NSNumber numberWithInt:count];
        [prefs setObject:msgVal forKey:@"msgNumber"];
        [prefs synchronize];

        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushMsgCount"
         object:self];

        NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
        [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

        completionHandler(UIBackgroundFetchResultNewData);
    }
    else if(userInfo[kGCMMessageIDKey]){
        
//        {
//            aps =     {
//                alert =         {
//                    body = ".................";
//                    title = test;
//                };
//                sound = "'Default'";
//            };
//            "gcm.message_id" = "0:1508938648888932%e9e07d95e9e07d95";
//        }
        
        
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
        
        
        
        NSDictionary *message   = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
        NSString *titleOfAlert = [message valueForKey:@"title"];
        NSString *bodyOfAlert = [message valueForKey:@"body"];
        
        
//        NSDate *date = [NSDate date];
//
        _eventNotification  = (Notification *)[Notification create];

        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSString *hourCountString = [dateFormatter stringFromDate:[NSDate date]];
        
//        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//        [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
//        [outputFormatter setDateFormat:@"HH:mm"];
//        NSDate * now = [NSDate date];
//        NSString *newDateString = [outputFormatter stringFromDate:now];

//        NSString *hourCountString = [dateFormatter stringFromDate:[NSDate date]];

//        _eventNotification.notification_message = bodyOfAlert ;
//        _eventNotification.notification_icon    = titleOfAlert ;
//        _eventNotification.notification_Time    = hourCountString ;
////
//////        notification_Time
//        [Notification save];


        // Print full message.
        NSLog(@"%@", userInfo);

        completionHandler(UIBackgroundFetchResultNewData);
    }

    else{
        NSNumber *value = [prefs objectForKey:@"notificationNumber"];
        // NSNumber *feedNotif = [prefs objectForKey:@"notificationFeedbackNumber"];
        //NSNumber *normalNotif = [prefs objectForKey:@"notificationNormalNumber"];

        int count = [value intValue];
        count++;
        value = [NSNumber numberWithInt:count];
        [prefs setObject:value forKey:@"notificationNumber"];
        [prefs synchronize];

        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushCount"
         object:self];
        completionHandler(UIBackgroundFetchResultNewData);

    }
    
    //comment test purpose
    
    
}



- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs removeObjectForKey:@"token"];
    [prefs synchronize];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    [SharedDBChatManager goOffline];
//    [SharedDBChatManager xmppStreamManagement] = XMPPStreamManagement(storage: XMPPStreamManagementMemoryStorage(), dispatchQueue: dispatch_get_main_queue()) ;
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 
    
}

-(void) gotoDashboard{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"eventListVC"];
    
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainVC"];

    [mainViewController setLeftViewSwipeGestureEnabled:false];
    
    
//    BOOL value = mainViewController.isLeftViewSwipeGestureEnabled ;
//
//    value = false ;
    
//    mainViewController.isLeftViewSwipeGestureEnabled.en
//    
//    mainViewController.interactivePopGestureRecognizer.enabled = NO;
//    
    // OR
    
    
//    [SharedDBChatManager makeConnectionWithChatServer];

    
//    _fromLoginOrSignUp =  @"fromLogin" ;
    [mainViewController setRootViewController:navigationController];
    
    [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:1];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    
    self.location = @"";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        self.longtitude =  currentLocation.coordinate.longitude;
        self.latitude = currentLocation.coordinate.latitude;
        
        CLLocation *location = [[CLLocation alloc]
                                initWithLatitude:self.latitude
                                longitude:self.longtitude];
        
        myGeocoder = [[CLGeocoder alloc] init];
        
        [myGeocoder
         reverseGeocodeLocation:location
         completionHandler:^(NSArray *placemarks, NSError *error) {
             
             if (error == nil &&
                 [placemarks count] > 0){
                 
                 CLPlacemark *placemark = placemarks[0];
                 NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
                 self.location = [lines componentsJoinedByString:@"\n"];
                 //NSLog(@"Address: %@", self.location);
                 
//                 self.countryCode = placemark.ISOcountryCode;
                 
                 [manager stopUpdatingLocation];
                 
             }
         }];
    }
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//
//    dispatch_async(dispatch_get_main_queue(),^{
//
//        NSLog(@"alertbody ..%@",  notification.alertBody);
//        NSLog(@"title ..%@",  notification.alertTitle);
//        NSLog(@"action ..%@",  notification.alertAction);
//        NSLog(@"userinfo..%@",  notification.userInfo);
//        [[NSNotificationCenter defaultCenter]postNotificationName:kChatMessageReceived object:nil userInfo:notification.userInfo];
//    });
//
//
////    NSLog(@"didReceiveLocalNotification: %@,\n Body: %@,\n Action:  %@", notification.userInfo, notification.alertBody, notification.alertAction);
////    if ([[notification alertAction] isEqualToString:@"Receive"]) {
////
////    }
////    else{
////        NSLog(@"From Appdelegate");
//////        [NotifCentre postNotificationName:@"gotoChatViewController" object:notification.userInfo];
////    }
//
//}


@end
