//
//  AppDelegate.h
//  Ibex
//
//  Created by Sajid Saeed on 22/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObject.h"
#import <CoreLocation/CoreLocation.h>
#import "YPOSearchEventList.h"
#import "XMPPMessage+XEP_0184.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *myGeocoder;

}
@property (strong, nonatomic) EventObject *eventObj;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *location;

@property (nonatomic, strong) NSString *selectedEventID;
@property (nonatomic, assign) NSInteger slectedView;
@property (nonatomic, strong) NSString *badgeValueCount;

@property (strong, nonatomic) UINavigationController *baseController;
@property (assign) BOOL isViewVisible;
@property (assign) BOOL isLoginOrSignUp;
@property (assign) BOOL isNotifyOfGroupChat;
@property (assign) BOOL isUserLeaveOrBlock;
@property (nonatomic, strong) NSString *groupAdminName;

@property (strong, nonatomic) NSString *fromLoginOrSignUp;
@property(nonatomic , strong) YPOSearchEventList *userList ;
@property (strong, nonatomic) NSMutableArray *groupsMembers_Detail;
@property (strong, nonatomic) NSString *fromJabberId;
@property (nonatomic, assign) BOOL hasInet;
@property (nonatomic, assign) BOOL isUserAddOrDelete;
@property (nonatomic , assign) NSInteger pushType ;




-(void) gotoDashboard ;


@property float latitude;
@property float longtitude;


@end

