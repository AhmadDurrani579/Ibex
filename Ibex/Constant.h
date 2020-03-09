//
//  Constant.h
//  TPLTrakker
//
//  Created by Sajid Saeed on 02/09/2015.
//  Copyright (c) 2015 TRG. All rights reserved.
//

#ifndef TPLTrakker_Constant_h
#define TPLTrakker_Constant_h


#endif

//Blur Effect
#define BLUR_EFFECT 1

//Fonts
#define NAV_BAR_TITLE_FONT @"Roboto-Regular"
#define NAV_BAR_TITLE_FONTSIZE 20
#define TITLE_FONT_SIZE 14
#define TITLE_FONT_NAME @"Roboto-Medium"
#define DETAIL_FONT_SIZE 12
#define DETAIL_FONT_NAME @"Roboto-Light"

#define NotifCentre                 [NSNotificationCenter defaultCenter]

#define POPUP_TITLE_FONT @"Roboto-Light"
#define POPUP_TITLE_FONTSIZE        16
#define POPUP_MSG_FONT @"Roboto-Light"
#define POPUP_MSG_FONTSIZE 11
#define kChatMessageReceived                         @"ChatMessageReceived"
#define kChatNotificationReceived                    @"ChatNotificationReceived"
#define kChatNotificationRemoved                     @"ChatNotificationRemoved"
#define kGroupChatMessageReceived                    @"GroupChatMessageReceived"
#define kGroupChatCreate                             @"GroupCreate"

#define KUpdateUIOfMessage                    @"RecentChatMessage"
#define kGroupChatUIUpdate                   @"GroupChatMessageUIUpdate"
#define kGroupChatUserLeave                   @"GroupChatMessageLeave"
#define kGroupChatUserBock                   @"GroupChatMessageBlock"
#define kGroupChatAddUSer                   @"GroupChatAddUser"

#define kGroupChatCreateMessage                  @"GroupChatMessage"

#define kPresenceUserOnline                   @"PresenceOnline"

#define kAuthorizationKeyLocal                   @"uVr1C7cUPMSpst8S"
#define kAuthorizationKeyLiveServer                   @"C2gNzTT4g2Fpl3w1"







//NavigationBar
#define NAV_BAR_BACKGROUND @"registerHeader@2x"
#define NAV_BAR_BACKGROUND_IPAD @"iPadHeaderBar@2x"
#define NAV_BAR_BACK_BUTTON @"backBtn"

//Application Settings
#define SPLASH_SCREEN_TIME 5.0

#define CLEAR_COLOR                                 [UIColor clearColor]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() ==       UIUserInterfaceIdiomPad)
#define WhiteColor [UIColor whiteColor]
#define MainNavBackColor [UIColor colorWithRed:0.14 green:0.45 blue:0.71 alpha:1]


#define MessageTypeText                         @"TextMessage"
#define MessageTypeImage                        @"PhotoMessage"

#define TEXT_MESSAGE                            @"1"
#define IMAGE_MESSAGE                            @"2"



#define kBaseConfrence            @"@conference."


//#define KBaseUrlForNotification         @"http://202.125.144.232:8060/api/DeviceInfo/SendPushMessage"
#define KBaseUrlForNotification           @"http://cms.ypopakistan.org/api/DeviceInfo/SendPushMessage"

//Registration Form Constants
#define FIRST_NAME_RANGE 15
#define LAST_NAME_RANGE 15
#define FULL_NAME_RANGE 30
#define PHONE_NUMBER_RANGE 16
#define EMAIL_ADDRESS_RANGE 30
#define NOTIFICATION_BUTTON_LABEL_TAG 10

#define SUB_MAIN_HEADING_FONT_NAME @"AvenirNext-Regular"
#define SUB_MAIN_HEADING_FONT_SIZE 17.0

#define SUB_HEADING_FONT_NAME @"AvenirNext-Regular"
#define SUB_HEADING_FONT_SIZE 14.0

#define SUB_HEADING_BOLD_FONT_NAME @"AvenirNext-Bold"
#define SUB_HEADING_FONT_SIZE 14.0

#define TF_FONT_NAME @"AvenirNext-Regular"
#define TF_FONT_SIZE 15.0

#define BUTTON_FONT_NAME @"AvenirNext-Regular"
#define BUTTON_FONT_SIZE 17.0

#define CURRENT_DEVICE                              [UIDevice currentDevice]


// System version
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)              ([[CURRENT_DEVICE systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_IS_IOS4_OR_GREATER()                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.0")
#define SYSTEM_VERSION_IS_IOS5_OR_GREATER()                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")
#define SYSTEM_VERSION_IS_IOS6_OR_GREATER()                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define SYSTEM_VERSION_IS_IOS7_OR_GREATER()                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define SYSTEM_VERSION_IS_IOS8_OR_GREATER()                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define SYSTEM_VERSION_IS_IOS9_OR_GREATER()                     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")


#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//#define WEBSERVICE_LOGIN @"http://www.google.com"
#define WEBSERVICE_ADD_DEVICE @"/PTService/Service1.svc/"
#define WEBSERVICE_DEVICE_LIST @"/PTService/Service1.svc/GetAllPtDevices"
#define WEBSERVICE_GET_CONTACTS @"/PTService/Service1.svc/	/"
#define WEBSERVICE_ADD_SECONDARYUSER @"/PTService/Service1.svc/CreateNewSecondaryUser/"
#define WEBSERVICE_DEL_SECONDARYUSER @"/PTService/Service1.svc/DeleteSecondaryuser/"
#define WEBSERVICE_MAP_SECONDARYUSER @"/PTService/Service1.svc/SecondaryUserMapping/"
#define WEBSERVICE_DELETE_DEVICE @"/PTService/Service1.svc/DeletePt1Device/"
#define WEBSERVICE_GET_USER_TYPE_FOR_DEVICE @"/PTService/Service1.svc/GetUserTypeOnDeviceSelection/"
#define WEBSERVICE_VEHICLE_HISTORY @"/MobileServiceTRG/Service1.svc/GetReplayHistory"
#define WEBSERVICE_NOTIFICATION_LIST @"/MobileServiceTRG/Service1.svc/GetAllNotificationList/"

#define WEBSERVICE_NEW_NOTIFICATION_LIST @"/MobileServiceTRG/Service1.svc/GetAllNotificationListForTest/"

#define WEBSERVICE_HELP @"/MobileServiceTRG/Service1.svc/InsertUserHelpLogs"
#define WEBSERVICE_REGISTER_PUSHNOTIFICATION @"/MobileServiceTRG/Service1.svc/InsertDeviceForPushNotification"

#define WEBSERVICE_GET_EMERGENCY_NUMBERS @"/MobileServiceTRG/Service1.svc/GetEmergencyNumbers/"
#define WEBSERVICE_ADDEDIT_EMERGENCY_NUMBERS @"/MobileServiceTRG/Service1.svc/UpdateEmergencyNumbers/"

//Webservices Base URL
#define WEBSERVICE_BASE_URL_WEBCLIENT @"http://www.coloursofindus.com/mit_app/?page_id=165"
#define WEBSERVICE_CHAT_URL @"http://www.coloursofindus.com/mit_app/cometchat"

//ACCESS TOKEN
//http://202.125.144.232:8050
// Local Base URL  :- http://192.168.4.72:8050
//#define WEBSERVICE_DOMAIN_URL @"http://202.125.144.232:8060"

#define WEBSERVICE_DOMAIN_URL @"http://cms.ypopakistan.org"

//#define WEBSERVICE_DOMAIN_URL @"http://ibexcis.ibexglobal.com"
//#define WEBSERVICE_ROOT_URL @"http://202.125.144.232:9366"
//#define WEBSERVICE_ROOT_URL_LOCAL @"http://192.168.4.72:9366"

#define WEBSERVICE_ACCESS_TOKEN @"mvveirgje84utsnvsljdq-ad6w77d4wf6w46f"
//
//IBEX


//http://132.148.144.24:9090/
// Local
//#define WEBSERVICE_CHATROOMS @"http://202.125.144.234:80/plugins/restapi/v1/chatrooms/"

// Live
#define WEBSERVICE_CHATROOMS @"http://132.148.144.24:9090/plugins/restapi/v1/chatrooms/"




//#define WEBService_ChatRoomGroup @"http://202.125.144.234:80/plugins/restapi/v1/chatrooms?type=all&servicename=conference"
#define WEBService_ChatRoomGroup @"http://132.148.144.24:9090/plugins/restapi/v1/chatrooms?type=all&servicename=conference"

//#define WEBSERVICE_CHATROOMS @"http://132.148.144.24:9090/plugins/restapi/v1/chatrooms/"
//"http://132.148.144.24:9090/plugins/restapi/v1/chatrooms/roomName/members/userJabberId"
#define WEBSERVICE_LEAVEGROUP @"members"

#define WEBSERVICE_GET_EVENT_LIST @"api/Event/Get"
#define WEBSERVICE_CREATE_PROFILE @"api/Account/CreateProfile"
#define WEBSERVICE_REGISTER_DEVICE @"/api/DeviceInfo/Post"
//#define SetNSUserDefault(_object_, _key_) [[NSUserDefaults standardUserDefaults] setObject:_object_ forKey:_key_]
//#define GetNSUserDefault(_key_) [[NSUserDefaults standardUserDefaults] objectForKey:_key_]
//#define SyncroniseNSUserDefault [[NSUserDefaults standardUserDefaults] synchronize]
//NSString *const kDeviceToken = @"deviceToken";

#define WEBSERVICE_GET_JOBTITLE @"api/List/getJobTitles"
#define WEBSERVICE_GET_INDUSTRY @"api/List/GetJobIndustries"
#define WEBSERVICE_GET_FUNCTION @"api/List/GetJobFunctions"
#define WEBSERVICE_GET_EVENT_COUNT @"api/Event/getStatsById"
#define WEBSERVICE_FORGOT_PASSWORD @"api/Account/forgotPassword"
#define WEBSERVICE_LOGIN @"token"
#define WEBSERVICE_GET_SPONSORS @"api/SponserExhibitor/getSponsersByEvent/"
#define WEBSERVICE_GET_EVENT_SPEAKERS @"api/EventSpeaker/GetByEventId/"
#define WEBSERVICE_GET_AGENDA @"api/EventSession/getByEventId/"
#define WEBSERVICE_GET_ATTENDEES @"api/EventAttendee/getInvitedUsersByEventId/"
#define WEBSERVICE_LOGOUT @"api/Account/Logout"
#define WEBSERVICE_CHANGE_PASSWORD @"api/Account/ChangePasswordMob"
#define WEBSERVICE_USER_JOINED_STATUS @"api/EventJoinRequest/alreadyJoined"
#define WEBSERVICE_JOIN_REQUEST @"api/EventJoinRequest/Post"
#define WEBSERVICE_BlockRequest @"api/EventAttendee/BlockAttendee"

#define WEBSERVICE_GET_USER @"api/Account/Get"
#define WEBSERVICE_UPDATE_PROFILE @"api/Account/UpdateProfile"
#define WEBSERVICE_UPLOAD_PICTURE @"http://boai.leadconcept.biz/api/upload/image"


#define WEBSERVICE_GETALLUSER @"api/user/getApproved/1/10000"

#define WEBSERVICE_GETALLNotification @"api/deviceInfo/getPushByPage"
#define WEBSERVICE_DeletePush @"api/deviceInfo/DeletePushByUser"
//#define WEBSERVICE_NotificationSwitch @"api/deviceInfo/notificationSwitch"
//#define WEBSERVICE_NotificationSwitch @"http://202.125.144.232:8060/api/DeviceInfo/NotificationSwitch"
#define WEBSERVICE_NotificationSwitch @"http://cms.ypopakistan.org/api/DeviceInfo/NotificationSwitch"

//#define WEBSERVICE_DOMAIN_URL @"http://202.125.144.232:8050"
//#define WEBSERVICE_DOMAIN_URL @"http://cms.ypopakistan.org"




#define WEBSERVICE_SEARCH @"api/Dashboard/search/"
#define WEBSERVICE_GETUSERBYID @"api/user/getByIds/"



//#define WEBSERVICE_GET_FAQ_LIST @"api/FAQ/GetByEventId/"

#define UIImageWithName(imageName) imageName?[UIImage imageNamed:imageName]:[UIImage new]

