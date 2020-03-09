//
//  Utility.m
//  BOL
//
//  Created by Muhammad Saood Sadiq on 31/05/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import "Utility.h"
#import "Constant.h"
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CommonCrypto/CommonDigest.h>

#import "NSUserDefaults+RMSaveCustomObject.h"

#import "DAAlertController.h"
#import "Constant.h"
#include <netinet/in.h>


// Your SDK start crashing after some data

@implementation Utility{
    
}

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


// creating a shared instance
+(Utility *)sharedUtility{
    
    // create a new class instance
    static Utility *sharedInstance = nil;
    
    // dispatch it if not initialized
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // initializing the shared instance
        
        sharedInstance = [[Utility alloc] init];
        
    });
    return sharedInstance;
    
}

+ (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    Boolean didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
    
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

- (NSString *)MD5StringOfString:(NSString *)string {
    const char *cstr = [string UTF8String];
    unsigned char result[16];
//    CC_MD(cstr, (CC_LONG)strlen(cstr), result);
//    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
//    CC_MD5(cstr ,(CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



+ (BOOL) systemVersionGreaterThanOrEqualTo:(NSString *)versionNumber{
    
    return (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(versionNumber));
    
}

+ (BOOL)isValidEmailAddress:(NSString *)emailText
{
    /* BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
     NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
     NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
     NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     BOOL isValid = [emailTest evaluateWithObject:emailText];
     return isValid;*/
    
    NSString *emailRegEx =
    @"(?:[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-zA-Z0-9](?:[a-"
    @"zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-zA-Z0-9-]*[a-zA-Z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL isValid = [regExPredicate evaluateWithObject:emailText];
    
    return isValid;
}


+ (BOOL) isIOS5orGreater{
    
    return ([Utility getSystemVersionAsAnInteger] >= __IPHONE_5_0);
}

+ (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}

+(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

+(void) addBlurScreen:(UIViewController *)vc{
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        vc.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = vc.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [blurEffectView setTag:24];
        
        [vc.view addSubview:blurEffectView];
        
        blurEffectView.alpha = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            blurEffectView.alpha = 1.0f;
        }];
        
    }

}

+ (UIViewController *) topViewController {
    UIViewController *baseVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([baseVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)baseVC).visibleViewController;
    }
    
    if ([baseVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedTVC = ((UITabBarController*)baseVC).selectedViewController;
        if (selectedTVC) {
            return selectedTVC;
        }
    }
    
    if (baseVC.presentedViewController) {
        return baseVC.presentedViewController;
    }
    return baseVC;
}

+ (NSString *)getProductUrlForProductImagePath:(NSString *)path
{
    
    return [NSString stringWithFormat:WEBSERVICE_DOMAIN_URL@"%@",path];
}
+(void)setViewCornerRadius:(UIView *)view radius:(float)radius
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}


//+ (MessageSDK *)sharedInstance
//{
//    static MessageSDK *shareMessageClient = nil;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shareMessageClient = [[MessageSDK alloc] init];
//    });
//    
//    return shareMessageClient;
//}
//
//+(void) loginCometChat:(UIViewController*)vc{
//    
//        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//        LoginResponse *userData = [defaults rm_customObjectForKey:@"UserData"];
//        UserObject *userObj = userData.response;
//
//        MessageSDK *msgSDK = [[MessageSDK alloc] init];
//
//        [msgSDK loginWithURL:WEBSERVICE_CHAT_URL username:userObj.userLoginEmail password:[defaults objectForKey:@"pass"] observer:nil success:^(NSDictionary *response) {
//            [self resetMsgCount:response];
//            NSLog(@"chat response: %@", response);
//        } userinfo:^(NSDictionary *response) {
//            [self subscribe:response];
//        } chatroominfo:^(NSDictionary *chatroominfo) {
//            [self subscribe:chatroominfo];
//            NSLog(@"ChatRoom: %@", chatroominfo);
//        } onMessageReceive:^(NSDictionary *msgReceive) {
//           // NSLog(@"Message: %@", msgReceive);
//        } failure:^(NSError *error) {
//            
//        }];
//
//
//}

+(void) addBadgeOnButton:(UIButton*)btn value:(NSNumber*)value{
    
    
    CGFloat fontSize = 7;
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    
    // Add count to label and size to fit
    label.text = [NSString stringWithFormat:@"%@", value];
    [label sizeToFit];
    
    // Adjust frame to be square for single digits or elliptical for numbers > 9
    CGRect frame = label.frame;
    frame.size.height += (int)(0.4*fontSize);
    frame.size.width = ((int)value <= 9) ? frame.size.height : frame.size.width + (int)fontSize;
    label.frame = frame;
    
    // Set radius and clip to bounds
    label.layer.cornerRadius = frame.size.height/2.0;
    label.clipsToBounds = true;
    
    label.tag = 90;
    [btn addSubview:label];

}

+(void) removeBadgeOnButton:(UIButton*)btn{
    
    UILabel *lbl = (UILabel*) [btn viewWithTag:90];
    
    [lbl removeFromSuperview];
}

/*

+(void) initComitChatWithSomeOne:(UIViewController*)vc someOne:(NSString*)someOne{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    LoginResponse *userData = [defaults rm_customObjectForKey:@"UserData"];
    UserObject *userObj = userData.response;
    
    MessageSDK *msgSDK = [[MessageSDK alloc] init];
    [msgSDK chatWith:someOne setBackButton:NO observer:vc success:^(NSDictionary *response) {
        
    } failure:^(NSError *error) {
        
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:vc withTitle:@"Internet connection error!" message:@"Please check your internet connection and try again." actions:@[dismissAction]];
    }];
    
    
}



+(void) initComitChatMainScreen:(UIViewController*)vc{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    LoginResponse *userData = [defaults rm_customObjectForKey:@"UserData"];
    UserObject *userObj = userData.response;
    
    NSLog(@"Pass: %@", [defaults objectForKey:@"pass"]);
    
    MessageSDK *msgSDK = [[MessageSDK alloc] init];

    [msgSDK loginWithURL:WEBSERVICE_CHAT_URL username:userObj.userLoginEmail password:[defaults objectForKey:@"pass"] observer:vc success:^(NSDictionary *response) {
        [self resetMsgCount:response];
    } userinfo:^(NSDictionary *userinfo) {
        [self subscribe:userinfo];
    } chatroominfo:^(NSDictionary *response) {
        //leave call back received
        [self subscribe:response];
        NSLog(@"ChatRoom: %@", response);
    } onMessageReceive:^(NSDictionary *msgReceive) {
          NSLog(@"Message: %@", msgReceive);
    } failure:^(NSError *error) {
        
        UIViewController *vc = [Utility topViewController];
        if ([NSStringFromClass([vc class]) isEqualToString: @"EmbeddedViewController"]){
            //            [vc removeFromParentViewController];
        }
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:vc withTitle:@"Chat Login error!" message:@"Please try again." actions:@[dismissAction]];
        NSLog(@"window closed");
        
    }];



}
 
 */

+(void) resetMsgCount:(NSDictionary*)response{
    
    if([[response objectForKey:@"login"] isEqualToString:@"Window Closed"]){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSNumber *value = [prefs objectForKey:@"msgNumber"];
        
        value = [[NSNumber alloc] initWithInt:0];
        
        [prefs setObject:value forKey:@"msgNumber"];
        [prefs synchronize];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pushMsgCount"
         object:nil];
    }

}

/*
+(void) subscribe:(NSDictionary*)userinfo{
    
    if(![userinfo objectForKey:@"push_channel"]){
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    
    if([defaults objectForKey:@"sub_channel"]){
        channels = [defaults rm_customObjectForKey:@"sub_channel"];
        
    }
    
    [channels addObject:[userinfo objectForKey:@"push_channel"]];
    [defaults rm_setCustomObject:channels forKey:@"sub_channel"];
    [defaults synchronize];
    
    if ([userinfo objectForKey:@"push_channel"] && ![[userinfo objectForKey:@"push_channel"] isEqualToString:@""]) {
        [[FIRMessaging messaging] subscribeToTopic:[NSString stringWithFormat:@"/topics/%@",[userinfo objectForKey:@"push_channel"]]];
    }
    if([userinfo objectForKey:@"push_an_channel"] && ![[userinfo objectForKey:@"push_an_channel"] isEqualToString:@""]) {
        [[FIRMessaging messaging] subscribeToTopic:[NSString stringWithFormat:@"/topics/%@",[userinfo objectForKey:@"push_an_channel"]]];
    }
    
}

+(void) unsubscribeAllChannels{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    
    if([defaults objectForKey:@"sub_channel"]){
        channels = [defaults rm_customObjectForKey:@"sub_channel"];
    
        for(NSString *channelString in channels){
            [[FIRMessaging messaging] unsubscribeFromTopic:channelString];
        }
    }
    
    [defaults removeObjectForKey:@"sub_channel"];
    [defaults synchronize];
    
}
 */

/*
+(void) logout{
    
    [self unsubscribeAllChannels];
    
    [[self sharedInstance] logoutWithSuccess:^(NSDictionary *response) {
        NSLog(@"Logout response : %@",response);
    } failure:^(NSError *error) {
        NSLog(@"Logout error : %@",error);
    }];
}
 */



+(BOOL)iPhone6PlusDevice{
    // Scale is 3 currently only for iPhone 6 Plus
    if ([UIScreen mainScreen].scale > 2.9) return YES;
    return NO;
}

+(void)setViewBorder:(UIView *)view withWidth:(float)width andColor:(UIColor*)color
{
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 1.;
}



+(void) removeBlurScreen:(UIViewController *)vc{
    for (UIVisualEffectView *subView in [vc.view subviews]) {
        if (subView.tag == 24) {
            subView.alpha = 1.0f;
            [UIView animateWithDuration:0.5 animations:^{
                subView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
        }
    }
}

+(void) setNavBarTitleiOS6:(UINavigationItem*)navItem title:(NSString*)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.font = [UIFont fontWithName:NAV_BAR_TITLE_FONT size:NAV_BAR_TITLE_FONTSIZE];
    label.shadowColor = [UIColor clearColor];
    label.textColor =[UIColor whiteColor];
    label.text = title;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.backgroundColor = [UIColor clearColor];
    navItem.titleView = label;
}

+(void) adjustScrollView:(UIScrollView*)scrollview min:(int)minHeight max:(int)maxHeight{
    CGRect scrollFrame = scrollview.frame;
    
    if([self hasFourInchDisplay]){
        scrollFrame.size.height = maxHeight;
        [scrollview setFrame:scrollFrame];
    }
    else{
        scrollFrame.size.height = minHeight;
        [scrollview setFrame:scrollFrame];
    }
}

+(void) adjustView:(UIView*)view min:(int)minHeight max:(int)maxHeight{
    CGRect scrollFrame = view.frame;
    
    if([self hasFourInchDisplay]){
        scrollFrame.size.height = maxHeight;
        [view setFrame:scrollFrame];
    }
    else{
        scrollFrame.size.height = minHeight;
        [view setFrame:scrollFrame];
    }
}

+ (NSInteger) getSystemVersionAsAnInteger
{
    int index = 0;
    NSInteger version = 0;
    
    NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSEnumerator* enumer = [digits objectEnumerator];
    NSString* number;
    while (number = [enumer nextObject]) {
        if (index>2) {
            break;
        }
        NSInteger multipler = powf(100, 2-index);
        version += [number intValue]*multipler;
        index++;
    }
    return version;
}

+ (BOOL) isIPhone5{
    
    return (CGSizeEqualToSize([[UIScreen mainScreen] preferredMode].size,CGSizeMake(640, 1136)));
}

+(NSString *)prettyStringFromDate:(NSDate *)date
{
    NSString * prettyTimestamp;
    
    float delta = [date timeIntervalSinceNow] * -1;
    
    if (delta < 60) {
        prettyTimestamp = @"just now";
    } else if (delta < 120) {
        prettyTimestamp = @"One Min";
    } else if (delta < 3600) {
        prettyTimestamp = [NSString stringWithFormat:@"%d Min", (int) floor(delta/60.0) ];
    } else if (delta < 7200) {
        prettyTimestamp = @"one hour";
    } else if (delta < 86400) {
        prettyTimestamp = [NSString stringWithFormat:@"%d hours", (int) floor(delta/3600.0) ];
    } else if (delta < ( 86400 * 2 ) ) {
        prettyTimestamp = @"one day";
    } else if (delta < ( 86400 * 7 ) ) {
        prettyTimestamp = [NSString stringWithFormat:@"%d days", (int) floor(delta/86400.0) ];
    } else if(delta < ( 86400 * 8 ) ){
        prettyTimestamp = [NSString stringWithFormat:@"%d week", (int) floor(delta/86400.0) ];
    }
    else if((delta < ( 86400 * 29 ) )){
        prettyTimestamp = [NSString stringWithFormat:@"%d weeks", (int) floor(delta/86400.0) ];
    }
    else if((delta < ( 86400 * 364 ) )){
        prettyTimestamp = [NSString stringWithFormat:@"one month"];
    }
    else if((delta < ( 86400 * 728) )){
        prettyTimestamp = [NSString stringWithFormat:@"%d months", (int) floor(delta/86400.0*0.03) ];
    }
    else {
        prettyTimestamp = [NSString stringWithFormat:@"%d year", (int) floor(delta/3600.0) ];
    }
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *tempFormatter = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    //return [NSString stringWithFormat:@"%@ | %@", prettyTimestamp, tempFormatter];
    return [NSString stringWithFormat:@"%@", tempFormatter];
}

+(NSString *) getDurationFromTime:(NSString *) source
{
    if (source.length == 0)
    {
        return @"";
    }
    NSDate *sourceDate;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *foramtter = [[NSDateFormatter alloc] init];
    [foramtter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [foramtter setFormatterBehavior:NSDateFormatterBehavior10_4];
    sourceDate = [foramtter dateFromString:source];
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit| NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* dateComponentsNow = [gregorian components:unitFlags fromDate:sourceDate toDate:currentDate options:0];
    
    NSInteger day     = dateComponentsNow.day;
    NSInteger weeks   = dateComponentsNow.weekOfMonth;
    NSInteger hours   = dateComponentsNow.hour;
    NSInteger minutes = dateComponentsNow.minute;
    NSInteger second  = dateComponentsNow.second;
    NSInteger month   = dateComponentsNow.month;
    NSInteger year    = dateComponentsNow.year;
    NSString *timeString = @"just now";
    if (year > 0)
    {
        timeString = [self timeStringByCheck:year timeString:@"Year"];
    }
    else if(month > 0)
    {
        timeString = [self timeStringByCheck:month timeString:@"Month"];
    }
    else if(weeks > 0)
    {
        timeString = [self timeStringByCheck:weeks timeString:@"Week"];
    }
    else if(day > 0)
    {
        timeString = [self timeStringByCheck:day timeString:@"Day"];
    }
    else if(hours > 0)
    {
        timeString = [self timeStringByCheck:hours timeString:@"Hour"];
    }
    else if(minutes > 0)
    {
        timeString = [self timeStringByCheck:minutes timeString:@"Minute"];;
    }
    else if(second > 0)
    {
        timeString = [self timeStringByCheck:second timeString:@"Second"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM, yyyy"];
    
    
    //return [NSString stringWithFormat:@"%@ | %@", timeString, [dateFormatter stringFromDate:sourceDate]];
    
    return [NSString stringWithFormat:@"%@ ago", timeString];
    
    
}
+(NSString *) timeStringByCheck:(NSInteger)time timeString:(NSString *)timeName
{
    NSString *s = nil;
    if (time > 1)
    {
        s = @"s";
    }
    else
    {
        s = @"";
    }
    NSString *timeString = [NSString stringWithFormat:@"%ld %@%@",(long)time,timeName,s];
    return timeString;
}

+ (void)myViewUp:(UIView*)sender y_value:(int) y
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = sender.frame;
	rect.origin.y = y;
	sender.frame = rect;
    [UIView commitAnimations];
}

+ (void)myViewDown:(UIView*)sender  y_value:(int) y
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    CGRect rect = sender.frame;
	rect.origin.y = y;
	sender.frame = rect;
    [UIView commitAnimations];
}

+(UIButton*) notificationButton:(NSString*)number{
    
    UIImage *alertNotifyImage = [UIImage imageNamed:@"iconAlert@2x.png"];
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [alertBtn setExclusiveTouch:YES];
    alertBtn.frame = CGRectMake(0, 0, 20, 20);
    [alertBtn setImage:alertNotifyImage forState:UIControlStateNormal];

    UIImage *imageCircle = [UIImage imageNamed:@"iconAlertRound@2x"];
    UIImageView *circleImageV = [[UIImageView alloc] initWithFrame:CGRectMake(alertBtn.frame.origin.x - 4, alertBtn.frame.origin.y - 6, 12, 12)];
    [circleImageV setImage:imageCircle];
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(alertBtn.frame.origin.x+1, alertBtn.frame.origin.y+1, 10, 10)];
    [numberLabel setTextAlignment:NSTextAlignmentCenter];
    [numberLabel setTag:NOTIFICATION_BUTTON_LABEL_TAG];
    [numberLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:7]];
    [numberLabel setBackgroundColor:[UIColor clearColor]];
    
    [numberLabel setText:number];
    [numberLabel setTextColor:[UIColor whiteColor]];
    [circleImageV addSubview:numberLabel];
    
    [alertBtn addSubview:circleImageV];

    return alertBtn;
}

+(void)showAlert:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


+ (UIImage *) iconForAvailabilityStatus:(NSString *) status
{
    UIImage *icon;
    status = [status lowercaseString];
    if ([status isEqualToString:@"available"]) {
        icon = [UIImage imageNamed:@"icon_online.png"];
    }
    else if ([status isEqualToString:@"busy"]) {
        icon = [UIImage imageNamed:@"icon_busy.png"];
    }
    else if ([status isEqualToString:@"away"]) {
        icon = [UIImage imageNamed:@"icon_away.png"];
    }
    else if ([status isEqualToString:@"offline"]) {
        icon = [UIImage imageNamed:@"icon_offline.png"];
    }
    else  {
        icon = [UIImage imageNamed:@"icon_busy.png"];
    }
    return icon;
}

+ (UIColor *) labelColorForAvailabilityStatus:(NSString *) status
{
    UIColor *color;
    status = [status lowercaseString];
    if ([status isEqualToString:@"available"]) {
        color = [UIColor colorWithRed:3.0 / 255.0
                                green:170.0 / 255.0
                                 blue:28.0 / 255.0
                                alpha:1.0];
    }
    else if ([status isEqualToString:@"busy"]) {
        color = [UIColor redColor];
    }
    else if ([status isEqualToString:@"away"]) {
        color = [UIColor colorWithRed:226.0 / 255.0
                                green:202.0 / 255.0
                                 blue:1.0 / 255.0
                                alpha:1.0];
    }
    else if ([status isEqualToString:@"offline"]) {
        color = [UIColor darkGrayColor];
    }
    else  {
        color = [UIColor redColor];
    }
    return color;
}

+(NSString *)convertDateToString: (NSDate*)date withFormat:(NSString *)Format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:Format];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}



+(BOOL) isEmptyOrNull:(NSString *)string{
    
    if(string==nil || string==Nil){
        return YES;
    }
    
    if(string&&![string isEqual:[NSNull null]])
    {
        if([string isKindOfClass:[NSString class]])
        {
            if(string.length>0)
                //string=[(NSString *)string removeWhiteSpaces];
            
            if(![string isEqualToString:@""]&&![string isEqualToString:@"(null)"]&&![string isEqualToString:@"<null>"]&&![string isEqualToString:@"nil"])
            {
                return NO;
            }
        }
    }
    
    return YES;
}

+(BOOL) isNotificationOn{
    
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([[defaults objectForKey:@"notificationONOFF"] isEqualToString:@"true"]){
        return TRUE;
    }
    else if([[defaults objectForKey:@"notificationONOFF"] isEqualToString:@"false"]){
        return FALSE;
    }
    else{
        return TRUE;
    }
    
}



@end
