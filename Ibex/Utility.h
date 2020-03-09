//
//  Utility.h
//  BOL
//
//  Created by Muhammad Saood Sadiq on 31/05/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

#define AppUtility                  [Utility sharedUtility]



@property (nonatomic, assign) BOOL          isOnlineForChat;


#pragma mark - Singliton + Initialization Methods
+ (Utility *)sharedUtility;

- (NSString *)MD5StringOfString:(NSString *)string ;

+(NSString *)prettyStringFromDate:(NSDate *)date;
+(NSString *) getDurationFromTime:(NSString *) source;
+(NSString *) timeStringByCheck:(NSInteger)time timeString:(NSString *)timeName;
+(void)myViewUp:(UIView*)sender y_value:(int) y;
+(void)myViewDown:(UIView*)sender  y_value:(int) y;
+ (UIImage *) iconForAvailabilityStatus:(NSString *) status;
+ (UIColor *) labelColorForAvailabilityStatus:(NSString *) status;
+(void) setNavBarTitleiOS6:(UINavigationItem*)navItem title:(NSString*)title;
+ (BOOL) systemVersionGreaterThanOrEqualTo:(NSString *)versionNumber;
+ (BOOL) isIOS5orGreater;
+ (BOOL) isIPhone5;
+ (NSInteger) getSystemVersionAsAnInteger;
+ (BOOL)hasFourInchDisplay;
+(void) adjustScrollView:(UIScrollView*)scrollview min:(int)minHeight max:(int)maxHeight;
+(void) adjustView:(UIView*)view min:(int)minHeight max:(int)maxHeight;
+(UIButton*) notificationButton:(NSString*)number;
+(void)showAlert:(NSString*)message;
+(BOOL) isEmptyOrNull:(NSString *)string;
+(BOOL) isNotificationOn;
+(UIImage *)makeRoundedImage:(UIImage *) image;
+(void) addBlurScreen:(UIViewController *)vc;
+(void) removeBlurScreen:(UIViewController *)vc;
+(void) initComitChatMainScreen:(UIViewController*)vc;
+(void) initComitChatWithSomeOne:(UIViewController*)vc someOne:(NSString*)someOne;
+(void) loginCometChat:(UIViewController*)vc;
+(void) logout;
+ (UIViewController *) topViewController;
+(void) addBadgeOnButton:(UIButton*)btn value:(NSNumber*)value;
+(void) removeBadgeOnButton:(UIButton*)btn;
+(void) unsubscribeAllChannels;
+(BOOL)iPhone6PlusDevice;
+ (void)setViewBorder:(UIView*)view withWidth:(float)width andColor:(UIColor*)color;
+ (NSString *)getProductUrlForProductImagePath:(NSString *)path ;
+(void)setViewCornerRadius:(UIView *)view radius:(float)radius ;
+(NSString *)convertDateToString: (NSDate*)date withFormat:(NSString *)Format ;
+ (BOOL)isValidEmailAddress:(NSString *)emailText ;
+ (BOOL)connectedToNetwork;




@end
