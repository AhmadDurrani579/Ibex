
//  WebclientPT1.m
//  TPLTrakker
//
//  Created by Sajid Saeed on 02/09/2015.
//  Copyright (c) 2015 TRG. All rights reserved.
//

#import "Webclient.h"
#import "DAAlertController.h"
#import "Constant.h"
//#import "AFHTTPRequestOperationManager.h"
//#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "AFHTTPSessionManager.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "EventListResponse.h"
#import "Constant.h"
#import "SignupResponse.h"
#import "GetJobTitleResponse.h"
#import "ForgotPasswordResponse.h"
#import "SponsorsResponse.h"
#import "EventSpeakerResponse.h"
#import "AgendaResponse.h"
#import "AttendessResponse.h"
#import "loginResponse.h"
#import "ChangePasswordResponse.h"
#import "IsJoinedResponsed.h"
#import "JoinRequestResponse.h"
#import "UserProfileResponse.h"
#import "QuestionObject.h"
#import "FAQResponse.h"
#import "UpdateResponse.h"
#import "EventCountResponse.h"
#import "MOGoldMember.h"
#import "YPOSchedule.h"
#import "MOGetAllSupporting.h"
#import "MOPolicy.h"
#import "YPOSearchEventList.h"
#import "NewsLetterModel.h"
#import "MONotificationResponse.h"
#import "PrivacyPolicyModel.h"

static NSString * const rootURL = WEBSERVICE_DOMAIN_URL;

@implementation Webclient

+ (Webclient *)sharedWeatherHTTPClient
{
    static Webclient *_sharedWeatherHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWeatherHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:rootURL]];
    });
    
    return _sharedWeatherHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.requestSerializer setTimeoutInterval:30];
        
        
//        Reachability *reach = [Reachability reachabilityWithHostName:@"http://www.google.com"];
//        
//        reach.reachableBlock = ^(Reachability*reach)
//        {
//            // keep in mind this is called on a background thread
//            // and if you are updating the UI it needs to happen
//            // on the main thread, like this:
//            self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//        };
//        
//        reach.unreachableBlock = ^(Reachability*reach)
//        {
//            self.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//        };
//        
//        [reach startNotifier];
    }
    
    return self;
}

-(void) hideProgressAlert {
    [HUD hide:YES afterDelay:0];
}

-(void) showProgressAlertOnView:(NSString *)title message:(NSString *)message view:(UIView*)view{
    
    //UIWindow *window=[[[UIApplication sharedApplication]delegate]window];
    
    
    if(!HUD) {
        HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 45, view.bounds.size.width, view.bounds.size.height)];
        [HUD setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.70f]];
        //[window setAutoresizingMask:UIViewAutoresizingNone];
    }
    
    //[[[window subviews] objectAtIndex:0] addSubview:HUD];
    [view addSubview:HUD];
    HUD.labelText = title;
    
    if(message)
    {
        HUD.detailsLabelText=message;
    }
    
    [HUD show:YES];
    
    
}

-(void) hideProgressAlertOnView:(UIView*)view {
    [HUD hide:YES afterDelay:0];
    
    HUD = [[view subviews] lastObject];
    [HUD removeFromSuperview];
    //[view removeFromSuperview];
    
}

-(void) showProgressAlertTitle:(NSString *)title message:(NSString *)message view:(UIView*)view{
    
    UIWindow *window=[[[UIApplication sharedApplication]delegate]window];

    
    if(!HUD) {
        HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 45, window.bounds.size.width, window.bounds.size.height)];
        [HUD setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.70f]];
        [window setAutoresizingMask:UIViewAutoresizingNone];
    }
    
    //[[[window subviews] objectAtIndex:0] addSubview:HUD];
    [window addSubview:HUD];
    HUD.labelText = title;
    
    if(message)
    {
        HUD.detailsLabelText=message;
    }
    
    [HUD show:YES];
}

-(void) getAgenda:(NSString *)eventID
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@%@",rootURL,WEBSERVICE_GET_AGENDA,eventID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([AgendaResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getAttendess:(NSString *)eventID
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@%@",rootURL,WEBSERVICE_GET_ATTENDEES,eventID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([AttendessResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getEventSpeakers:(NSString *)eventID
    viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@%@",rootURL,WEBSERVICE_GET_EVENT_SPEAKERS,eventID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([EventSpeakerResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) getSponsors:(NSString *)eventID
     viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
 
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@%@",rootURL,WEBSERVICE_GET_SPONSORS,eventID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([SponsorsResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getSideMenuUserProfile:(NSString *)userID
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock{
    
    //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@",rootURL,WEBSERVICE_GET_USER,userID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // [self hideProgressAlert];
        block([UserProfileResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) getUserProfile:(NSString *)userID
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@",rootURL,WEBSERVICE_GET_USER,userID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([UserProfileResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) getFAQQuestionList:(NSString*)eventID
            viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL, eventID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([FAQResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}
-(void) getSearchEventAndList:(NSString*)webserviceName
               viewController:(UIViewController*)viewController
              CompletionBlock:(void(^)(NSObject *responseObject))block
                 FailureBlock:(void(^)(NSError *error))errorBlock  {
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *trimmedString = [webserviceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@%@",rootURL,WEBSERVICE_SEARCH , trimmedString];
    NSString *fullCompleteUrl = [NSString stringWithFormat:@"%@", [completeUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];

    [self GET:fullCompleteUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([YPOSearchEventList initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

    
    
}

-(void) getAllUserList:(NSString*)webserviceName
               viewController:(UIViewController*)viewController
              CompletionBlock:(void(^)(NSObject *responseObject))block
                 FailureBlock:(void(^)(NSError *error))errorBlock  {
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_GETALLUSER];
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([MOGoldMember initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
    
}


-(void) getGoldAndYPOMemberLost:(NSString*)webserviceName
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
    //                                     cellNumber, @"Cell",
    //                                     deviceType, @"DeviceType",
    //                                     deviceToken, @"DeviceToken",
    //                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([MOGoldMember initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) getPolicyData:(NSString*)webserviceName
                 viewController:(UIViewController*)viewController
                CompletionBlock:(void(^)(NSObject *responseObject))block
                   FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
    //                                     cellNumber, @"Cell",
    //                                     deviceType, @"DeviceType",
    //                                     deviceToken, @"DeviceToken",
    //                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([MOPolicy initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getNewsLetter:(NSString*)webserviceName
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
    //                                     cellNumber, @"Cell",
    //                                     deviceType, @"DeviceType",
    //                                     deviceToken, @"DeviceToken",
    //                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([NewsLetterModel initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getPrivacyPolicy:(NSString*)webserviceName
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
    //                                     cellNumber, @"Cell",
    //                                     deviceType, @"DeviceType",
    //                                     deviceToken, @"DeviceToken",
    //                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([PrivacyPolicyModel initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}





-(void) getAllSchedule:(NSString*)webserviceName
                 viewController:(UIViewController*)viewController
                CompletionBlock:(void(^)(NSObject *responseObject))block
                   FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
    //                                     cellNumber, @"Cell",
    //                                     deviceType, @"DeviceType",
    //                                     deviceToken, @"DeviceToken",
    //                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([YPOSchedule initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getAllSupportingFile:(NSString*)webserviceName
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
    //                                     cellNumber, @"Cell",
    //                                     deviceType, @"DeviceType",
    //                                     deviceToken, @"DeviceToken",
    //                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([EventListResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getAllNotification:(NSString*)webserviceName
              viewController:(UIViewController*)viewController
             CompletionBlock:(void(^)(NSObject *responseObject))block
                FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
    //                                     cellNumber, @"Cell",
    //                                     deviceType, @"DeviceType",
    //                                     deviceToken, @"DeviceToken",
    //                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([MONotificationResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) getEventList:(NSString*)webserviceName
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
//    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
//                                     cellNumber, @"Cell",
//                                     deviceType, @"DeviceType",
//                                     deviceToken, @"DeviceToken",
//                                     nil];
    
    //NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,webserviceName];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([EventListResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];


}

-(void) getEventCounts:(NSString*)eventID
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];

    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@",rootURL,WEBSERVICE_GET_EVENT_COUNT,eventID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([EventCountResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}



-(void) login:(NSString *)userID
     password:(NSString *)password
   grant_type:(NSString *)grant_type
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSObject *responseObject))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];

    
    NSString *stringParams = [NSString stringWithFormat:@"userName=%@&password=%@&grant_type=%@&client_id=mobile", userID, password, grant_type];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_LOGIN];

    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[stringParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:completeUrl]];
    
    
    [request setHTTPBody:[stringParams dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self hideProgressAlert];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            [MOUser saveUserInfo:responseObject];

            block([loginResponse initWithData:responseObject]);

        } else {
            errorBlock([loginResponse initWithData:responseObject]);
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}

-(void) logout:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_LOGOUT];
    
    [self POST:completeUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([ForgotPasswordResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) forgotPassword:(NSString *)emailAddress
        viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                         emailAddress, @"email",
                                         nil];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?email=%@",rootURL,WEBSERVICE_FORGOT_PASSWORD, emailAddress];

    [self POST:completeUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([ForgotPasswordResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) joinRequest:(NSString *)userID
                    eventID:(NSString *)eventID
             viewController:(UIViewController*)viewController
            CompletionBlock:(void(^)(NSObject *responseObject))block
               FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userID, @"userId",
                                     eventID,@"eventId",
                                     nil];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_JOIN_REQUEST];
    
    [self POST:completeUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([JoinRequestResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) blockRequest:(NSString *)userID
            eventID:(NSString *)eventID
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userID, @"userId",
                                     eventID,@"eventId",
                                     nil];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@/%@",rootURL,WEBSERVICE_BlockRequest,userID ,eventID];
    
    [self POST:completeUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block(responseObject);
        
//        block([JoinRequestResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) deleteAllNotification:(NSString *)userID
               viewController:(UIViewController*)viewController
              CompletionBlock:(void(^)(NSObject *responseObject))block
                 FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
//    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
//                                     userID, @"userId",
//                                     eventID,@"eventId",
//                                     nil];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@",rootURL,WEBSERVICE_DeletePush,userID];
    
    [self POST:completeUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block(responseObject);
        
        //        block([JoinRequestResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) updateProfile:(NSMutableDictionary *)data
             newImage:(UIImage *)newImage
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_UPDATE_PROFILE];
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.80) ;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSString* base64String = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imageData base64Encoding]];
    
    [data setObject:base64String forKey:@"DPData"];
    
    [manager POST:completeUrl parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([UpdateResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) uploadImage:(NSMutableDictionary *)data
             newImage:(UIImage *)newImage
          CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
//    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = WEBSERVICE_UPLOAD_PICTURE;
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.80) ;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString* base64String = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",[imageData base64Encoding]];
    
    [data setObject:base64String forKey:@"DPData"];
    
    [manager POST:completeUrl parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([UpdateResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}



-(void) isUserAlreadyJoined:(NSString *)userID
                    eventID:(NSString *)eventID
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@/%@",rootURL,WEBSERVICE_USER_JOINED_STATUS,userID,eventID];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([IsJoinedResponsed initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) getJobTitles:(NSString *)serviceType
viewController:(UIViewController*)viewController
CompletionBlock:(void(^)(NSObject *responseObject))block
  FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,serviceType];

    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([GetJobTitleResponse initWithData:responseObject]);
        //block([EventListResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) registerDeviceToken:(NSString *)deviceToken
      createDate:(NSString *)createDate
         modifiedDate:(NSString *)modifiedDate
       deviceType:(NSString *)deviceType
   userID:(NSString *)userID
viewController:(UIViewController*)viewController
CompletionBlock:(void(^)(NSObject *responseObject))block
  FailureBlock:(void(^)(NSError *error))errorBlock
{
   // [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     deviceToken, @"DeviceToken",
                                     createDate, @"createdDate",
                                     modifiedDate, @"modifiedDate",
                                     deviceType,@"deviceType",
                                     userID, @"userId",
                                     nil];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_REGISTER_DEVICE];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:completeUrl]];
    [request setHTTPBody:[[self dictToJson:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //[self hideProgressAlert];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            block(responseObject);
            //block([SignupResponse initWithData:responseObject]);
        } else {
            errorBlock(error);
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];

}



-(void) signUP:(NSString *)firstName
      lastName:(NSString *)lastName
         email:(NSString *)email
       company:(NSString *)company
   phoneNumber:(NSString *)phoneNumber
    jobTitleID:(NSString *)jobTitleID
      password:(NSString *)password
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(NSObject *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     firstName, @"firstName",
                                     lastName, @"lastName",
                                     email, @"email",
                                     company,@"company",
                                     phoneNumber, @"phoneNumber",
                                     jobTitleID,@"jobTitleId",
                                     password,@"password",
                                     @"true",@"isMobile",
                                     nil];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_CREATE_PROFILE];
    
   // NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_SAVE_IMAGE];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:completeUrl]];
    [request setHTTPBody:[[self dictToJson:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    //   request setHTTPBody:[NSString stringWithFormat:@"postedJson=%@", jsonString]
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self hideProgressAlert];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            block([SignupResponse initWithData:responseObject]);
        } else {
            errorBlock(error);
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    /*
    [self POST:completeUrl parameters:[self dictToJson:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        //block([SubmitPhoneResponse initWithData:[responseObject objectForKey:@"SubmitPhoneNumberResult"]]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
     */
}

-(void) changePassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
       confirmPassword:(NSString *)confirmPassword
                userID:(NSString *)userID
viewController:(UIViewController*)viewController
CompletionBlock:(void(^)(NSObject *responseObject))block
  FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userID,@"UserId",
                                     oldPassword, @"OldPassword",
                                     newPassword, @"NewPassword",
                                     confirmPassword, @"ConfirmPassword",
                                     nil];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_CHANGE_PASSWORD];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:completeUrl]];
    [request setHTTPBody:[[self dictToJson:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    //   request setHTTPBody:[NSString stringWithFormat:@"postedJson=%@", jsonString]
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self hideProgressAlert];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            block([ChangePasswordResponse initWithData:responseObject]);
        } else {
            errorBlock(error);
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
    
    /*
     [self POST:completeUrl parameters:[self dictToJson:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
     
     } progress:^(NSProgress * _Nonnull uploadProgress) {
     
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
     [self hideProgressAlert];
     //block([SubmitPhoneResponse initWithData:[responseObject objectForKey:@"SubmitPhoneNumberResult"]]);
     
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     [self hideProgressAlert];
     errorBlock(error);
     }];
     */
}



-(NSString *)dictToJson:(NSDictionary *)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return  [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}

/*
-(void) userLogin:(NSString *)cellNumber
       deviceType:(NSString *)deviceType
      deviceToken:(NSString *)deviceToken
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(NSObject *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     cellNumber, @"Cell",
                                     deviceType, @"DeviceType",
                                     deviceToken, @"DeviceToken",
                                     nil];
    
    NSString *params = [NSString stringWithFormat:@"Cell=%@&DeviceType=%@&DeviceToken=%@", cellNumber, deviceType, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_LOGIN_MOBILE,params];
    
    [self POST:completeUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([SubmitPhoneResponse initWithData:[responseObject objectForKey:@"SubmitPhoneNumberResult"]]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) verifyPincode:(NSString *)cellNumber
       pinCode:(NSString *)pinCode
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(NSObject *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];

    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     cellNumber, @"Cell",
                                     pinCode, @"PinCode",
                                     nil];
    
    NSString *params = [NSString stringWithFormat:@"Cell=%@&PinCode=%@", cellNumber, pinCode];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_VERIFY_PINCODE, params];
    
    [self POST:completeUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([PincodeResponse initWithData:[responseObject objectForKey:@"VerifyPinResult"]]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}

-(void) registerUser:(NSString *)cellNumber
               email:(NSString *)email
         username:(NSString*)username
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)username,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));

    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     cellNumber, @"MobileNumber",
                                     email, @"Email",
                                     encodedString,@"Name",
                                     nil];
    
    NSString *params = [NSString stringWithFormat:@"MobileNumber=%@&Email=%@&Name=%@", cellNumber, email, encodedString];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_REGISTER_USER, params];
    
    [self POST:completeUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([RegisterUserResponse initWithData:[responseObject objectForKey:@"RegisterUserResult"]]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) getProducts:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    NSString *latestURL = [NSString stringWithFormat:@"https://www.tpllife.com/wc-api/v2/products?consumer_key=ck_93b1928719e3ff44faba7b49c3c7acd7d411e55c&consumer_secret=cs_939b30e0311a6277f2a11b884a8468b1ee71e358"];
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_GET_PRODUCTS];

    
    [self GET:latestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([GetProductResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

}

-(void) getProductDetail:(NSString*)policyID
          viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *params = [NSString stringWithFormat:@"PolicyID=%d", [policyID intValue]];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_GET_PRODUCT_DETAILS,params];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([GetProductDetailsResponse initWithData:[responseObject objectForKey:@"GetProductDetailsResult"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getDocumentList:(NSString*)mobileNo
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *params = [NSString stringWithFormat:@"Mobile=%@", mobileNo];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_GET_DOCLIST,params];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([DocumentListResponse initWithData:[responseObject objectForKey:@"DocListResult"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getCustomerInquiry:(NSString*)cnic
         viewController:(UIViewController*)viewController
        CompletionBlock:(void(^)(NSObject *responseObject))block
           FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *params = [NSString stringWithFormat:@"CNIC=%@", cnic];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_GET_CUSTOMERINQUIRY,params];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([CustomerInquiryResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getCalorieRecords:(UIViewController*)viewController
           CompletionBlock:(void(^)(NSObject *responseObject))block
              FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //NSString *params = [NSString stringWithFormat:@"CNIC=%@", cnic];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_GET_CALORIE_RESPONSE];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([CalorieResponse initWithData:[responseObject objectForKey:@"GetCaloriesResult"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getNotifications:(UIViewController*)viewController
          CompletionBlock:(void(^)(NSObject *responseObject))block
             FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //NSString *params = [NSString stringWithFormat:@"CNIC=%@", cnic];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_GET_NOTIFICATIONS];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([NotifResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) vertifyDetails:(NSString*)CNIC
          mobileNumber:(NSString*)mobileNumber
        viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    if([mobileNumber containsString:@"-"]){
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSString *params = [NSString stringWithFormat:@"CNIC=%@&MobileNumber=%@", CNIC, mobileNumber];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_GET_VERIFIED,params];
    
    [self POST:completeUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([responseObject objectForKey:@"VerifyUserFromCNICResult"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

    
}

-(void) getPolicynInformation:(NSString*)CNIC
          mobileNumber:(NSString*)mobileNumber
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    if([mobileNumber containsString:@"-"]){
        mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSString *params = [NSString stringWithFormat:@"CNIC=%@&CELLNO=%@", CNIC, mobileNumber];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_GET_POLICY,params];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([PolicyInfoModel initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) deleteDocument:(NSString*)docID
         viewController:(UIViewController*)viewController
        CompletionBlock:(void(^)(NSObject *responseObject))block
           FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *params = [NSString stringWithFormat:@"DocId=%@", docID];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_DELETE_DOCUMENT,params];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block([DocumentDeleteResponse initWithData:[responseObject objectForKey:@"deleteDocumentResult"]]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}


-(void) callHelp:(NSString*)mobileNumber
       longitude:(NSString*)longitude
        latitude:(NSString*)latitude
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *params = [NSString stringWithFormat:@"MobileNumber=%@&latitude=%@&longitude=%@", mobileNumber,latitude,longitude];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@?%@",rootURL,WEBSERVICE_SUBMIT_LOC,params];
    
    [self GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideProgressAlert];
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}


-(void) saveImage:(NSString*)mobileNo
            title:(NSString*)title
          imageFile:(UIImage*)imageFile
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSData *imageData = UIImageJPEGRepresentation(imageFile, 0.80);
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"ImageTitle\":\"%@\",\"Mobile\":\"%@\",\"Image\":\"%@\"}",title, mobileNo, [self base64forData:imageData]];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",rootURL,WEBSERVICE_SAVE_IMAGE];
   
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:completeUrl]];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
 //   request setHTTPBody:[NSString stringWithFormat:@"postedJson=%@", jsonString]
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self hideProgressAlert];
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            block(responseObject);
        } else {
            errorBlock(error);
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];

}

- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


-(void) userLogin:(NSString *)userEmail
         password:(NSString *)password
       deviceType:(NSString *)deviceType
      deviceToken:(NSString *)deviceToken
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(LoginResponse *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     password, @"password",
                                     deviceType, @"device_type",
                                     deviceToken,@"device_token",
                                     WEBSERVICE_USER_LOGIN, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([LoginResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) forgetPassword:(NSString *)userEmail
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(ForgetPassResponse *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_FORGET_PASS, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
  
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([ForgetPassResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getUserDetails:(NSString *)userEmail
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(UserDetailsResponse *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock
{
    //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_USER_DETAILS, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"userdetails_data"]){
        block([UserDetailsResponse initWithData:[defaults rm_customObjectForKey:@"userdetails_data"]]);
    }
    else{
        //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    }
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //[self hideProgressAlert];
        [defaults rm_setCustomObject:responseObject forKey:@"userdetails_data"];
        [defaults synchronize];
        
        if([defaults objectForKey:@"userdetails_data"]){
            block([UserDetailsResponse initWithData:[defaults rm_customObjectForKey:@"userdetails_data"]]);
        }

        
      // block([UserDetailsResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[self hideProgressAlert];
        if([defaults objectForKey:@"userdetails_data"]){
            //block([defaults objectForKey:@"partners_data"]);
           // block([UserDetailsResponse initWithData:[defaults rm_customObjectForKey:@"userdetails_data"]]);
        }
        else{
            errorBlock(error);
        }

    }];


    
}

-(void) getNotifications:(NSString *)userEmail
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NotificationResponse *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_USER_NOTIFICATIONS_LIST, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];

    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([NotificationResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
   
}


-(void) getResources:(NSString *)userEmail
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PAGE_DATA, @"step",
                                     WEBSERVICE_PAGE_RESOURCES,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"resources_data"]){
        //block([ResourcesResponse initWithData:[defaults rm_customObjectForKey:@"resources_data"]]);
    }
    else{
       // [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    }
    //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //[self hideProgressAlert];
        
        [defaults rm_setCustomObject:responseObject forKey:@"resources_data"];
        [defaults synchronize];
        
        if([defaults objectForKey:@"resources_data"]){
            //block([defaults objectForKey:@"partners_data"]);
            block([ResourcesResponse initWithData:[defaults rm_customObjectForKey:@"resources_data"]]);
        }
        //block([PartnersResponse initWithRawData:responseObject]);
        

        
        
        block([ResourcesResponse initWithData:responseObject]);;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[self hideProgressAlert];
        if([defaults objectForKey:@"resources_data"]){
          //  block([ResourcesResponse initWithData:[defaults rm_customObjectForKey:@"resources_data"]]);
        }
        else{
            errorBlock(error);
        }

    }];

    
}

-(void) getSocials:(NSString *)userEmail
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PAGE_DATA, @"step",
                                     WEBSERVICE_PAGE_SOCIALS,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([ResourcesResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getOffsiteDetails:(NSString *)userEmail
    viewController:(UIViewController*)viewController
   CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
      FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PAGE_DATA, @"step",
                                     WEBSERVICE_PAGE_SOCIALS,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([ResourcesResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

    
}


-(void) changePassword:(NSString *)userEmail
                userID:(NSString *)userID
           newPassword:(NSString *)newPassword
    viewController:(UIViewController*)viewController
   CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
      FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     userID, @"proUpd[ID]",
                                     newPassword, @"proUpd[newPwd]",
                                     WEBSERVICE_UPDATE_PROFILE, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
       block([ResourcesResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    

}

-(void) getPartners:(NSString *)userEmail
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(PartnersResponse *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock
{
    //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PARTNERS_DATA, @"step",
                                     WEBSERVICE_PAGE_OFFSITES,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    if([defaults objectForKey:@"partners_data"]){
       // block([PartnersResponse initWithRawData:[defaults rm_customObjectForKey:@"partners_data"]]);
    }
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [defaults rm_setCustomObject:responseObject forKey:@"partners_data"];
        [defaults synchronize];
        
        if([defaults objectForKey:@"partners_data"]){
            //block([defaults objectForKey:@"partners_data"]);
            block([PartnersResponse initWithRawData:[defaults rm_customObjectForKey:@"partners_data"]]);
        }
        //block([PartnersResponse initWithRawData:responseObject]);
        //[self hideProgressAlert];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[self hideProgressAlert];
        if([defaults objectForKey:@"partners_data"]){
            //block([defaults objectForKey:@"partners_data"]);
            //block([PartnersResponse initWithRawData:[defaults rm_customObjectForKey:@"partners_data"]]);
        }
        else{
            errorBlock(error);
        }
        //errorBlock(error);
    }];
    
}

-(void) writeStringToFile:(NSString *)aString suggestedfileName:(NSString*) suggestedfileName{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = suggestedfileName;
    NSString *fileAtPath = [filePath stringByAppendingString:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

-(NSString *)readStringFromFile:(NSString*) suggestedfileName{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = suggestedfileName;
    NSString *fileAtPath = [filePath stringByAppendingString:fileName];
    return [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
}

-(void) getOffsites:(NSString *)userEmail
    viewController:(UIViewController*)viewController
   CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
      FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PAGE_DATA, @"step",
                                     WEBSERVICE_PAGE_OFFSITES,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([ResourcesResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

}

-(void) getAttendiesContactList:(NSString *)userEmail
                   isSpouseList:(NSString *)isSpouseList
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(AttendiesResponse *attendiesObj))block
       FailureBlock:(void(^)(NSError *error))errorBlock
{
    //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PAGE_ATTENDIES_LIST, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    if([isSpouseList isEqualToString:@"1"]){
        [parameters setValue:[NSString stringWithFormat:@"1"] forKey:@"spouse"];
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"attendies_data"]){
        //block([AttendiesResponse initWithReponse:[defaults rm_customObjectForKey:@"attendies_data"]]);
    }
    else{
        //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    }
    
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //[self hideProgressAlert];
        if([isSpouseList isEqualToString:@"1"]){
            [defaults rm_setCustomObject:responseObject forKey:@"speaker_data"];
        }
        else{
            [defaults rm_setCustomObject:responseObject forKey:@"attendies_data"];
        }
        
        [defaults synchronize];
        
        if([isSpouseList isEqualToString:@"1"] && [defaults objectForKey:@"speaker_data"]){
            //block([defaults objectForKey:@"partners_data"]);
            block([AttendiesResponse initWithReponse:[defaults rm_customObjectForKey:@"speaker_data"]]);
        }
        else{
            block([AttendiesResponse initWithReponse:[defaults rm_customObjectForKey:@"attendies_data"]]);        }

        //block([AttendiesResponse initWithReponse:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[self hideProgressAlert];
        
        if([defaults objectForKey:@"attendies_data"]){
            //block([AttendiesResponse initWithReponse:[defaults rm_customObjectForKey:@"attendies_data"]]);
        }
        else{
            errorBlock(error);
        }
//        errorBlock(error);
    }];
    
}


-(void) getSchedules:(NSString *)userEmail
    viewController:(UIViewController*)viewController
   CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
      FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PAGE_DATA, @"step",
                                     WEBSERVICE_PAGE_SCHEDULE,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"schedule_data"]){
       // block([ResourcesResponse initWithData:[defaults rm_customObjectForKey:@"schedule_data"]]);
    }
    else{
       // [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    }
    //[self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //[self hideProgressAlert];
        
        [defaults rm_setCustomObject:responseObject forKey:@"schedule_data"];
        [defaults synchronize];
        
        if([defaults objectForKey:@"schedule_data"]){
            block([ResourcesResponse initWithData:[defaults rm_customObjectForKey:@"schedule_data"]]);
        }
        
        //block([ResourcesResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[self hideProgressAlert];
        
        if([defaults objectForKey:@"schedule_data"]){
            //block([defaults objectForKey:@"partners_data"]);
            //block([ResourcesResponse initWithData:[defaults rm_customObjectForKey:@"schedule_data"]]);
        }
        else{
            errorBlock(error);
        }
    }];
    
}

-(void) getMyCalender:(NSString *)userEmail
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_PAGE_DATA, @"step",
                                     WEBSERVICE_PAGE_OFFSITES,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([ResourcesResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getMessage:(NSString *)userEmail
            userID:(NSString*)userID
        receiverID:(NSString*)receiverID
        pageNumber:(NSString*)pageNumber
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(GetMessageResponse *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     userID,@"userId",
                                     receiverID,@"receiverId",
                                     WEBSERVICE_GET_MESSAGE, @"step",
                                     pageNumber,@"page",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([GetMessageResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

    
}

-(void) sendMessage:(NSString *)userEmail
            userID:(NSString*)userID
        receiverID:(NSString*)receiverID
            message:(NSString*)message
    viewController:(UIViewController*)viewController
   CompletionBlock:(void(^)(SendMessageResponse *responseObject))block
      FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     userID,@"userId",
                                     receiverID,@"receiverId",
                                     message,@"message",
                                     WEBSERVICE_SEND_MESSAGE, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([SendMessageResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) registerEvent:(NSString *)userEmail
               userID:(NSString *)userID
              eventID:(NSString *)eventID
               dateID:(NSString *)dateID
               timeID:(NSString *)timeID
          serviceType:(NSString *)serviceType
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(RegisterEventResponse *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     userID, @"evnt[userId]",
                                     eventID, @"evnt[eventId]",
                                     dateID, @"evnt[dateId]",
                                     timeID,@"evnt[timeId]",
                                     serviceType, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([RegisterEventResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) unRegisterAllEvent:(NSString *)userEmail
               userID:(NSString *)userID
             isDelete:(NSString *)isDelete
               dateID:(NSString *)dateID
               timeID:(NSString *)timeID
          serviceType:(NSString *)serviceType
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(RegisterEventResponse *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     userID, @"evnt[userId]",
                                     isDelete, @"evnt[delAll]",
                                     dateID, @"evnt[dateId]",
                                     timeID,@"evnt[timeId]",
                                     serviceType, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     nil];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([RegisterEventResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    

}

-(void) updateProfile:(NSString *)userEmail
               userID:(NSString *)userID
             newEmail:(NSString *)newEmail
          displayName:(NSString *)displayName
              userURL:(NSString *)userURL
              phoneNo:(NSString *)phoneNo
       profileCompany:(NSString *)profileCompany
   profileDesignation:(NSString *)profileDesignation
              tagLine:(NSString *)tagLine
                fbURL:(NSString *)fbURL
             newImage:(UIImage *)newImage
          linkedinURL:(NSString *)linkedinURL
           twitterURL:(NSString *)twitterURL
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(UpdateProfileResponse *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_UPDATE_PROFILE, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     userID, @"proUpd[ID]",
                                     newEmail, @"proUpd[user_email]",
                                     displayName, @"proUpd[display_name]",
                                     userURL, @"proUpd[user_url]",
                                     phoneNo, @"proUpd[phone_no]",
                                     profileCompany, @"proUpd[profile_company]",
                                     profileDesignation, @"proUpd[profile_desg]",
                                     tagLine, @"proUpd[tag_line]",
                                     fbURL, @"proUpd[fbook_url]",
                                     linkedinURL, @"proUpd[linkedin_url]",
                                     twitterURL, @"proUpd[twitter_url]",
                                     nil];

    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.80);

    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:rootURL]
                                               //            cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:20];
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"formData" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([UpdateProfileResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

  

}

-(void) getAttendiesList:(NSString *)userEmail
               offisteID:(NSString *)offsiteID
                  dateID:(NSString *)dateID
                  timeID:(NSString *)timeID
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(AttendiesListResponse *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     userEmail, @"email",
                                     WEBSERVICE_ATTENDIES_LIST, @"step",
                                     WEBSERVICE_ACCESS_TOKEN, @"access_token",
                                     offsiteID,@"offAttendees[offsiteId]",
                                     dateID,@"offAttendees[dateId]",
                                     timeID,@"offAttendees[timeId]",
                                     nil];
    
    
    [self POST:rootURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
       
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideProgressAlert];
        block([AttendiesListResponse initWithData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];

}



- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

*/

//i'm here closed
/*
-(void) getVehicleList:(NSString *)phoneNumber
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    NSString *params = [NSString stringWithFormat:@"/%@",@"03008254158"];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",WEBSERVICE_GET_VEHICLE_LIST, params];
    
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //[self hideProgressAlert];
        
        block([GetVehicleResponse initWithVehicleList:[responseObject objectForKey:@"VehicleListResult"]]);
       // AllDevicesModel *devicesObj = [AllDevicesModel allDeviceModelObj:responseObject];
        //block(devicesObj);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       // [self hideProgressAlert];
        errorBlock(error);
    }];

    
}

-(void) getComplaintCategory:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@",WEBSERVICE_GET_COMPLAINT_CATEGORIES];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@", responseObject);
        block([ComplainCategoryResponse initWithList:[responseObject objectForKey:@"GetComplaintCategoriesDetailsResult"]]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

//WEBSERVICE_GET_SECONDARY_CONTACTS
-(void) getSecondaryContactsForNumber:(NSString*)number
                                 view:(UIViewController*)viewController
                CompletionBlock:(void(^)(NSArray *response))block
                   FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",WEBSERVICE_GET_SECONDARY_CONTACTS, number];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       // block([ComplainSubCategoryResponse initWithList:[responseObject objectForKey:@"GetComplaintSubCategoriesDetailsResult"]]);
        
        block([GetSecondaryContactNumberResponse initWithList:[responseObject objectForKey:@"GetContactListResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) getComplaintSubCategory:(UIViewController*)viewController
             CompletionBlock:(void(^)(NSArray *response))block
                FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@",WEBSERVICE_GET_COMPLAINT_SUBCATEGORIES];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        block([ComplainSubCategoryResponse initWithList:[responseObject objectForKey:@"GetComplaintSubCategoriesDetailsResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) getVehicleMapUserList:(NSString*)vehicleID
                         view:(UIViewController*)viewController
                CompletionBlock:(void(^)(NSArray *response))block
                   FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",WEBSERVICE_GET_MAP_USERDATA, vehicleID];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        block([GetSecondaryContactNumberResponse initWithList:[responseObject objectForKey:@"GetContactListFromVehicleIDResult"]]);
        //block([ComplainSubCategoryResponse initWithList:[responseObject objectForKey:@"GetComplaintSubCategoriesDetailsResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) unMapUser:(NSString*)primaryNo
 registrationNo:(NSString*)registrationNo
      contactID:(NSString*)contactID
           view:(UIViewController*)viewController
CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
   FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@/%@",WEBSERVICE_UNMAP_SECONDARY_USER, primaryNo, registrationNo, contactID];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        NSLog(@"%@",responseObject);
        block([ECSAddSecondaryUserResponse initWithData:responseObject]);
        //block([ComplainSubCategoryResponse initWithList:[responseObject objectForKey:@"GetComplaintSubCategoriesDetailsResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) addSecondaryUser:(NSString*)primaryNo
               firstName:(NSString*)firstName
                lastName:(NSString*)lastName
                 contact:(NSString*)contact
                     nic:(NSString*)nic
                   regNo:(NSString*)regNo
                         view:(UIViewController*)viewController
              CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
                 FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@",WEBSERVICE_ADD_SECONDARY_USER, primaryNo,firstName,lastName,contact,nic,regNo];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([ECSAddSecondaryUserResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) editSecondaryUser:(NSString*)primaryNo
               firstName:(NSString*)firstName
                lastName:(NSString*)lastName
                 contact:(NSString*)contact
                     nic:(NSString*)nic
                   regNo:(NSString*)regNo
                    view:(UIViewController*)viewController
         CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@",WEBSERVICE_EDIT_SECONDARY_USER,firstName,lastName,nic,contact,primaryNo,regNo];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([ECSAddSecondaryUserResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}


-(void) fetchSecondaryUser:(NSString*)primaryNo
                    view:(UIViewController*)viewController
         CompletionBlock:(void(^)(GetContactDetailsResponse *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",WEBSERVICE_FETCH_SECONDARY_USER_DETAILS, primaryNo];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetContactDetailsResponse initWithData:[responseObject objectForKey:@"GetContactDetailsResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) fetchMapUserList:(NSString*)vehicleID
                      view:(UIViewController*)viewController
           CompletionBlock:(void(^)(GetContactDetailsResponse *response))block
              FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",WEBSERVICE_GET_MAP_USER_LIST, vehicleID];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetContactDetailsResponse initWithData:[responseObject objectForKey:@"GetContactDetailsResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) fetchPackageList:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSArray *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@",WEBSERVICE_GET_PACKAGE_LIST];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetPackageListResponse initWithList:[responseObject objectForKey:@"PackageListResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) fetchFeatureList:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSArray *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@",WEBSERVICE_GET_FEATURE_LIST];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetFeatureListResponse initWithList:[responseObject objectForKey:@"FeatureDetailsResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}

-(void) fetchUserProfileDetails:(NSString*)vehicleID
                    view:(UIViewController*)viewController
         CompletionBlock:(void(^)(ECSFetchUserProfile *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",WEBSERVICE_GET_USER_PROFILE_DETAILS, vehicleID];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([ECSFetchUserProfile initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}


-(void) fetchMakerList:(UIViewController*)viewController
                CompletionBlock:(void(^)(NSArray *response))block
                   FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@",WEBSERVICE_GET_MAKER_LIST];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetFeatureListResponse initWithList:[responseObject objectForKey:@"MakerListResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) fetchModelList:(NSString*)makerID
                  view:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",WEBSERVICE_GET_MODEL_LIST, makerID];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetFeatureListResponse initWithList:[responseObject objectForKey:@"ModleListResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

//http://103.9.23.45/Ecs/Services.svc/GetAmanetVehiclesForDeviceTranfer/03332332125

-(void) fetcVehicleForTransfer:(NSString*)userNumber
                  view:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@",WEBSERVICE_GET_VEHICLELIST_TRANSFER, userNumber];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetVehicleListForTransferResponse initWithList:[responseObject objectForKey:@"GetAmanetVehiclesForDeviceTranferResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getTransferDueDetails:(UIViewController*)viewController
                 CompletionBlock:(void(^)(NSArray *response))block
                    FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@",WEBSERVICE_GET_TRANSFER_DUEAMOUNT_DETAILS];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([ECSGetDeviceTransferAmountResponse initWithList:[responseObject objectForKey:@"GetDeviceTransferAmountPayableForMobileAppResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getNewInstallationAmount:(NSString*)packageID
                            type:(NSString*)type
                  view:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@/%@",WEBSERVICE_GET_NEW_INSTALLATION_AMOUNT, packageID,type];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([GetNewInstallationAmountResponse initWithList:[responseObject objectForKey:@"GetNewInstallationAmountPayableResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) updateUserProfile:(NSString*)primaryNo
             emailAddress:(NSString*)emailAddress
       residentialAddress:(NSString*)residentialAddress
           billingAddress:(NSString*)billingAddress
                accountNo:(NSString*)accountNo
               customerID:(NSString*)customerID
          registerationID:(NSString*)registrationID
                     view:(UIViewController*)viewController
          CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
             FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     primaryNo, @"CellNo",
                                     emailAddress, @"EmailAddress",
                                     residentialAddress, @"ResidentialAddress",
                                     billingAddress, @"BillingAddress",
                                     accountNo, @"AccountNo",
                                     customerID, @"CustomerID",
                                     registrationID, @"RegNo",
                                     nil];

    [self GET:WEBSERVICE_UPDATE_PROFILE_DETAILS  parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([ECSAddSecondaryUserResponse initWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    
}
//WEBSERVICE_UPDATE_PROFILE_DETAILS



-(void) saveTransferVehicle:(UIViewController*)viewController
                     userID:(NSObject*)userID
           requestSubTypeId:(NSObject*)requestSubTypeId
                  packageID:(NSObject*)packageID
              fromVehicleID:(NSObject*)fromVehicleID
                fromVehicle:(NSDictionary*)fromVehicle
             ifToNewVehicle:(NSObject*)ifToNewVehicle
                toVehicleID:(NSObject*)toVehicleID
                  toVehicle:(NSDictionary*)toVehicle
           ifNewPrimaryUser:(NSObject*)ifNewPrimaryUser
            ifSecondaryUser:(NSObject*)ifSecondaryUser
       ifSponsoredByCompany:(NSObject*)ifSponsoredByCompany
           corporateCompany:(NSObject*)corporateCompany
                  leasingID:(NSObject*)leasingID
copyOfFirstPageOfVehicleRegistration:(NSObject*)copyOfFirstPageOfVehicleRegistration
           isLeasingCompany:(NSObject*)isLeasingCompany
           leasingCompanyID:(NSObject*)leasingCompanyID
          amountPayableList:(NSArray*)amountPayableList
              serviceDetail:(NSObject*)serviceDetail
          isRegisterVehicle:(NSObject*)isRegisterVehicle
         pointOfContactName:(NSObject*)pointOfContactName
                 deviceName:(NSObject*)deviceName
       pointOfContactNumber:(NSObject*)pointOfContactNumber
CopyOfFirstPageOfVehicleRegistration:(NSObject*)CopyOfFirstPageOfVehicleRegistration
            CompletionBlock:(void(^)(GenericResponse *response))block
               FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    
    NSDictionary *primaryUser = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNull null],@"UserId",
                                   [NSNull null],@"SalutationId",
                                   [NSNull null],@"FirstName",
                                   [NSNull null],@"LastName",
                                   [NSNull null],@"GenderId",
                                   [NSNull null],@"Gender",
                                   [NSNull null],@"NIC",
                                   [NSNull null],@"AddressTypeId",
                                   [NSNull null],@"Address",
                                   [NSNull null],@"AreaId",
                                   [NSNull null],@"CityId",
                                   [NSNull null],@"ContactTypeId",
                                   [NSNull null],@"ContactNumber",
                                   [NSNull null],@"Email",
                                   nil];
    
    NSArray *secondaryUser = [[NSArray alloc] init];
    
    NSDictionary *dictObj = [NSDictionary dictionaryWithObjectsAndKeys:
                             userID,@"UserId",
                             requestSubTypeId,@"SubTypeId",
                             ifNewPrimaryUser,@"IfNewPrimaryUser",
                             primaryUser,@"PrimaUser",
                             fromVehicleID,@"FromVehicleId",
                             fromVehicle,@"FromVehicle",
                             ifToNewVehicle,@"IfToNewVehicle",
                             toVehicleID,@"ToVehicleId",
                             toVehicle,@"ToVehicle",
                             deviceName,@"DeviceName",
                             ifSecondaryUser,@"IfSecondaryUser",
                             isLeasingCompany,@"IsLeasingCompany",
                             leasingID,@"LeasingId",
                             amountPayableList,@"Amount",
                             serviceDetail,@"serviceDetail",
                             CopyOfFirstPageOfVehicleRegistration,@"CopyOfFirstPageOfVehicleRegistration",
                             secondaryUser,@"SecondaryUsers",
                             nil];
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Root_TPL,WEBSERVICE_TRANSFER_OF_DEVICE]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictObj
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *strData = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSString *convertedString = [NSString stringWithFormat:@"%@", dictObj];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block([GenericResponse initWithData:responseObject]);
        NSLog(@"JSON: %@", responseObject);
        [self hideProgressAlert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
        [self hideProgressAlert];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}


-(void) saveRating:(UIViewController*)viewController
              userCellNo:(NSString*)userCellNo
              complainID:(NSString*)complainID
                comments:(NSString*)comments
                  rating:(NSString*)rating
         CompletionBlock:(void(^)(GenericResponse *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];

    NSDictionary *mainObj = [NSDictionary dictionaryWithObjectsAndKeys:
                             userCellNo,@"CellNo",
                             complainID,@"ComplaintId",
                             comments,@"Comments",
                             rating,@"Rating",
                             nil];
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Root_TPL,WEBSERVICE_SAVE_RATING]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mainObj
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSString *strData = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideProgressAlert];
        block([GenericResponse initWithData:responseObject]);
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
        [self hideProgressAlert];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}




-(void) saveRemoveDevice:(UIViewController*)viewController
                             userCellNo:(NSString*)userCellNo
                       extendedWarranty:(NSObject*)extendedWarranty
                           vehiclesIDs:(NSString*)vehiclesIDs
                            vehicleExtendedWrantty:(NSString*)vehicleExtendedWrantty
                 activityID:(NSString*)activityID
subActivityID:(NSString*)subActivityID
            activityName:(NSString*)activityName
              locationID:(NSString*)locationID
          commentReason:(NSString*)commentReason
        objServiceDetail:(NSString*)objServiceDetail
             serviceType:(NSString*)serviceType
                  cityID:(NSString*)cityID
           appointmentID:(NSString*)appointmentID
                 address:(NSString*)address
                        CompletionBlock:(void(^)(GenericResponse *response))block
                           FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableArray *dtVehicleList = [[NSMutableArray alloc] init];
    
    NSDictionary *dtVehicles = [NSDictionary dictionaryWithObjectsAndKeys:
                            vehiclesIDs,@"VehiclesIDs",
                            vehicleExtendedWrantty,@"VehicleExtendedWrantty",
                            nil];
    
    [dtVehicleList addObject:dtVehicles];

    NSDictionary *objService = [NSDictionary dictionaryWithObjectsAndKeys:
                                serviceType,@"ServiceType",
                                cityID,@"CityId",
                                appointmentID,@"AppointmentId",
                                userCellNo,@"ContactNumber",
                                address,@"Address",
                                nil];

    
    NSDictionary *mainObj = [NSDictionary dictionaryWithObjectsAndKeys:
                             userCellNo,@"UserCellNo",
                             extendedWarranty,@"ExtendedWarranty",
                             dtVehicleList,@"dtVehiclesiDAndExtended",
                             activityID,@"ActivityID",
                             subActivityID,@"SubActivityID",
                             activityName,@"ActivityName",
                             locationID,@"LocationID",
                             commentReason,@"CommentsReason",
                             dtVehicleList,@"dtVehiclesiDAndExtended",
                             objService,@"ObjSeviceDetail",
                             nil];
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Root_TPL,WEBSERVICE_SAVE_REMOVAL_DEVICE]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mainObj
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *strData = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSString *convertedString = [NSString stringWithFormat:@"%@", mainObj];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block([GenericResponse initWithData:responseObject]);
        NSLog(@"JSON: %@", responseObject);
        [self hideProgressAlert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
        [self hideProgressAlert];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}


-(void) getAmountPayableForRemoveDevice:(UIViewController*)viewController
                             activityID:(NSString*)activityID
                            serviceType:(NSString*)serviceType
                           userIDCellNO:(NSString*)userIDCellNO
                            vehiclesIDs:(NSString*)vehiclesIDs
                 vehicleExtendedWaranty:(NSString*)vehicleExtendedWaranty
            CompletionBlock:(void(^)(GetDueAmountDeviceRemovalResponse *response))block
               FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSMutableArray *subObjArr = [[NSMutableArray alloc] init];
    
    NSDictionary *subObj = [NSDictionary dictionaryWithObjectsAndKeys:
                             vehiclesIDs,@"VehiclesIDs",
                             vehicleExtendedWaranty,@"VehicleExtendedWrantty",
                             nil];

    [subObjArr addObject:subObj];
    
    NSDictionary *mainObj = [NSDictionary dictionaryWithObjectsAndKeys:
                             activityID,@"ActivityID",
                             serviceType,@"serviceType",
                             userIDCellNO,@"userIDCellNo",
                             subObjArr,@"dtVehiclesiD",
                             nil];
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Root_TPL,WEBSERVICE_GET_AMOUNT_PAYABLE]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mainObj
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *strData = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSString *convertedString = [NSString stringWithFormat:@"%@", mainObj];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block([GetDueAmountDeviceRemovalResponse initWithData:[responseObject objectAtIndex:0]]);
        NSLog(@"JSON: %@", responseObject);
        [self hideProgressAlert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
        [self hideProgressAlert];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}


-(void) saveNewInstallation:(UIViewController*)viewController
                    userID:(NSObject*)userID
          requestSubTypeId:(NSObject*)requestSubTypeId
                 packageID:(NSObject*)packageID
                  vehicleID:(NSObject*)vehicleID
                 registrationNumber:(NSObject*)registrationNumber
              registrationYearID:(NSObject*)registrationYearID
              registrationYear:(NSObject*)registrationYear
              makeID:(NSObject*)makeID
              make:(NSObject*)make
              colorID:(NSObject*)colorID
              color:(NSObject*)color
              modelID:(NSObject*)modelID
              model:(NSObject*)model
              cc:(NSObject*)cc
              chasisNumber:(NSObject*)chasisNumber
              engineNumber:(NSObject*)engineNumber
              productInstallID:(NSObject*)productInstallID
              unitAgeOfProduct:(NSObject*)unitAgeOfProduct
              isActive:(NSObject*)isActive
              vehicleUserID:(NSObject*)vehicleUserID
              productName:(NSObject*)productName
              ifSponsoredByCompany:(NSObject*)ifSponsoredByCompany
              corporateCompany:(NSObject*)corporateCompany
              leasingID:(NSObject*)leasingID
              ifNewPrimaryUser:(NSObject*)ifNewPrimaryUser
              primaryUser:(NSObject*)primaryUser
              ifSecondaryUser:(NSObject*)ifSecondaryUser
              secondaryUser:(NSObject*)secondaryUser
              copyOfFirstPageOfVehicleRegistration:(NSObject*)copyOfFirstPageOfVehicleRegistration
              isLeasingCompany:(NSObject*)isLeasingCompany
              leasingCompanyID:(NSObject*)leasingCompanyID
              amountPayableList:(NSArray*)amountPayableList
              serviceDetail:(NSObject*)serviceDetail
              isRegisterVehicle:(NSObject*)isRegisterVehicle
              pointOfContactName:(NSObject*)pointOfContactName
              pointOfContactNumber:(NSObject*)pointOfContactNumber
              CompletionBlock:(void(^)(GenericResponse *response))block
              FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSDictionary *vehicleDetail = [NSDictionary dictionaryWithObjectsAndKeys:
                             vehicleID,@"Id",
                             registrationNumber,@"RegistrationNumber",
                             registrationYearID,@"RegistrationYearID",
                             registrationYear,@"RegistrationYear",
                             makeID,@"MakeId",
                             make,@"Make",
                             colorID,@"ColorId",
                             color,@"Color",
                             modelID,@"ModelId",
                             model,@"Model",
                           cc,@"CC",
                           chasisNumber,@"ChasisNumber",
                           engineNumber,@"EngineNumber",
                           productInstallID,@"ProductInstalledId",
                           unitAgeOfProduct,@"UnitAgeOfProduct",
                           isActive,@"IsActive",
                           vehicleUserID,@"UserId",
                           productName,@"ProductName",
                             nil];
    
    
    NSDictionary *dictObj = [NSDictionary dictionaryWithObjectsAndKeys:
                             userID,@"UserId",
                             requestSubTypeId,@"requestSubTypeId",
                             packageID,@"PackageId",
                             vehicleDetail,@"VehicleDetail",
                             ifSponsoredByCompany,@"IfSponsoredByCompany",
                             corporateCompany,@"CorporateCompany",
                             leasingID,@"LeasingId",
                             ifNewPrimaryUser,@"IfNewPrimaryUser",
                             primaryUser,@"PrimaUser",
                             ifSecondaryUser,@"IfSecondaryUser",
                             secondaryUser,@"SecondaryUsers",
                             copyOfFirstPageOfVehicleRegistration,@"CopyOfFirstPageOfVehicleRegistration",
                             isLeasingCompany,@"IsLeasingCompany",
                             leasingCompanyID,@"LeasingCompanyId",
                             amountPayableList,@"AmountPayable",
                             serviceDetail,@"serviceDetail",
                             isRegisterVehicle,@"IsRegisterVehicle",
                             pointOfContactNumber,@"PointOfContact",
                             nil];
    
    
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Root_TPL,WEBSERVICE_SAVE_NEW_INSTALLATION]];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictObj
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *strData = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    
    NSString *convertedString = [NSString stringWithFormat:@"%@", dictObj];

    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block([GenericResponse initWithData:responseObject]);
        NSLog(@"JSON: %@", responseObject);
        [self hideProgressAlert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
        [self hideProgressAlert];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}


-(void) saveRegisterDevice:(UIViewController*)viewController
                    userID:(NSString*)userID
                 vehicleID:(NSString*)vehicleID
                categoryID:(NSString*)categoryID
             subCategoryID:(NSString*)subCategoryID
                 contactNo:(NSString*)contactNo
              altContactNo:(NSString*)altContactNo
                      date:(NSString*)date
                  comments:(NSString*)comments
                CompletionBlock:(void(^)(GetComplainRegisterationResponse *response))block
                   FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSDictionary *dictObj = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                    userID,@"UserID",
                                                                    vehicleID,@"VehicleId",
                                                                    categoryID,@"CategoryId",
                                                                    subCategoryID,@"SubCategoryId",
                                                                    contactNo,@"ContactNumber",
                                                                    altContactNo,@"AlternateContactNumber",
                                                                    date,@"Date",
                                                                    comments,@"Comments",
                                                                    @"",@"DocumentName",
                                                                    @"",@"DocumentImageString",
                             nil];

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Root_TPL,WEBSERVICE_SAVE_COMPLAINT]];
    
    
    NSString *temp = [NSString stringWithFormat:@"{\"UserID\":\"03018281423\",\"VehicleId\":25742,\"CategoryId\":0,\"SubCategoryId\":611,\"ContactNumber\":\"03226610166\",\"AlternateContactNumber\":\"03226610166\",\"Date\":\"2016-07-16T16:45:57\",\"Comments\":\"test\",\"DocumentName\":\"1454338416_cancel-2.png\",\"DocumentImageString\":\"iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAAitJREFUWIXt17FOFFEUBuBPQ1YpDShLR0ig19JCQ4zE1kKiRksewEJ9AWMDFQmJRguUGPUNjMZCX0ArCAlSKmCgVyBY3Bm4u+zcmdnFSv/kZmbvnvOf/849c+4Z/nWc6NJvGOMYyH5vYQXrxyGqCOOYxTfsF4xVzGDsOAM3sYi9ROD2sYcFnCsjL9uCSbzCYDS3iXf4io1sbgjncQ1n22xv42OZkE64hR2Hq1rGDfQlfPowJeRD7vc786uFybbg79Go4X8Kc20iJqo6N/HT0T2driEgx4OIY13rVhZiUevK8+TrVsR8xPe8zHg8CrgsPPbpHkWcFl7PfexiNGU8G6mNE6dXEXci3scpw7zIbDia7b2IaAjVMn+yHTEcqXxRYNOLiDcRf8dkvBwZ3EsQdSviYcR/MZ+MH/NAdL+hGM+y6xOczK7xfBHig+ogVqqqpdCtiCOIBWxF90N/QUSzIFaLQb5HLysIyFE1J95G/AMFNgcFY1O97SkT0cB29v9SimgmUjlVQ0CZiLsR76MUyVhEsiKcar2K6MdaNreDkTKShUjtXE0BnUR8ivieViE4J9SB3Ol+jyLy8V0i+dpxRWgicud54VSrin6tK/+FSzX8EU7DWMSqcKqlOqOGkHBrWoNfL3Ioa0on8FprYdrGB3xxWF6buICrOBPZ/sBNfC6Jk8Sg0Mnsqt6W7wgJV3nPq2BUaCaWE4GXhPd8pCppt59mgzp/mnWs8f+Rwh+AOefiMh7cfgAAAABJRU5ErkJggg==\"}"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictObj
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
     
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        block([GetComplainRegisterationResponse initWithData:responseObject]);
        NSLog(@"JSON: %@", responseObject);
        [self hideProgressAlert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
        [self hideProgressAlert];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    

}

-(void) changePassword:(UIViewController*)viewController
             vehicleID:(NSString*)vehicleID
                 primaryNo:(NSString*)primaryNo
               oldPassword:(NSString*)oldPassword
               newPassword:(NSString*)newPassword
        confirmNewPassword:(NSString*)confirmNewPassword
           CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
              FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSDictionary *dictObj = [NSDictionary dictionaryWithObjectsAndKeys:
                             vehicleID,@"VehicleId",
                             primaryNo,@"UserCell",
                             oldPassword,@"OldPassword",
                             newPassword,@"NewPassword",
                             confirmNewPassword,@"ConfirmNewPassword",
                             nil];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Root_TPL,WEBSERVICE_CHANGE_PASSWORD]];

    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictObj
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Basic: someValue" forHTTPHeaderField:@"Authorization"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideProgressAlert];
        block([ECSAddSecondaryUserResponse initWithData:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
    
    
}



/*

-(void) getAllDevices:(NSString *)phoneNumber
              pinCode:(NSString *)pinCode
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(AllDevicesModel *response))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
 
    DBManager *dbManager = [[DBManager alloc] initWithDatabaseFilename:@"tpltrakker.sqlite"];
 
    if(![dbManager devicesRecordExist]){
        [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    }

    
    NSString *params = [NSString stringWithFormat:@"/%@/%@",phoneNumber, pinCode];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",WEBSERVICE_DEVICE_LIST, params];
    
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideProgressAlert];
        
        AllDevicesModel *devicesObj = [AllDevicesModel allDeviceModelObj:responseObject];
        block(devicesObj);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}


-(void) getVehicleHistory:(NSString *)regNumber
              startDate:(NSString *)startDate
                  endDate:(NSString *)endDate
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSArray *response))block
         FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    NSString *params = [NSString stringWithFormat:@"?reg_no=%@&startdate=%@&enddate=%@",regNumber, startDate, endDate];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",WEBSERVICE_VEHICLE_HISTORY, params];
    

    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideProgressAlert];
        block([VehicleLocation initWithArray:[responseObject objectForKey:@"GetMovementReportResult"]]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) askForHelp:(NSString *)phoneNumber
           pincode:(NSString *)pincode
               lat:(NSString *)lat
               lng:(NSString*)lng
           viewController:(UIViewController*)viewController
          CompletionBlock:(void(^)(HelpResponse *response))block
             FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    NSString *params = [NSString stringWithFormat:@"?PhoneNumber=%@&Pin=%@&Latitude=%@&Longitude=%@",phoneNumber, pincode, lat,lng];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",WEBSERVICE_HELP, params];
    
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideProgressAlert];
        block([HelpResponse initWithData:[responseObject objectForKey:@"InsertLogsForSMSResult"]]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) registerForPushNotifications:(NSString *)phoneNumber
                         deviceToken:(NSString *)deviceToken
                      viewController:(UIViewController*)viewController
                     CompletionBlock:(void(^)(RegisterResponse *response))block
                        FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    NSString *params = [NSString stringWithFormat:@"?ContactNumber=%@&DeviceID=%@|||iOS",phoneNumber, deviceToken];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",WEBSERVICE_REGISTER_PUSHNOTIFICATION, params];
    
    completeUrl=[completeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideProgressAlert];
        block([RegisterResponse initWithData:[responseObject objectForKey:@"InsertDeviceForPushNotificationResult"]]);
               
        //block([HelpResponse initWithData:[responseObject objectForKey:@"InsertLogsForSMSResult"]]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}


-(void) getNotificationList:(NSString *)cellNumber
           viewController:(UIViewController*)viewController
          CompletionBlock:(void(^)(NSArray *response))block
             FailureBlock:(void(^)(NSError *error))errorBlock
{
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",WEBSERVICE_NOTIFICATION_LIST, cellNumber];
    
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideProgressAlert];
        block([Notification initWithData:[responseObject objectForKey:@"GetAllNotificationListResult"]]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}



-(void) addDevice:(NSString *)userName
          simCard:(NSString *)simCard
             imei:(NSString *)imei
         phoneNo1:(NSString *)phoneNo1
         phoneNo2:(NSString *)phoneNo2
         phoneNo3:(NSString *)phoneNo3
          pinCode:(NSString *)pinCode
        userPhone:(NSString *)userPhone
       deviceType:(NSString *)deviceType
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(AddDeviceResponse *response))block
     FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    //NSString *paramsDemo = [NSString stringWithFormat:@"%@",@"/03008252010/9439/mywa/356823034166707/03325091541/03313712637/0/0"];
    
    NSString *params = [NSString stringWithFormat:@"/%@/%@/%@/%@/%@/%@/%@/%@",userPhone, pinCode,userName, imei, simCard, phoneNo1, phoneNo2, phoneNo3];
    
    NSString *completeUrl = [[NSString alloc]init];
    
    if([deviceType isEqualToString:@"pt2"]){
        completeUrl = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_ADD_DEVICE, @"AddDeviceForPT2", params];
    }
    else{
        completeUrl = [NSString stringWithFormat:@"%@%@%@",WEBSERVICE_ADD_DEVICE, @"AddDevice", params];
    }
    
    
    [self GET:completeUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self hideProgressAlert];
        block([AddDeviceResponse addDeviceResponseFromDict:responseObject]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
    
}

-(void) getEmergencyNumbers:(NSString*)cellNo
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(EmergencyNumberResponse *obj))block
       FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@",WEBSERVICE_GET_EMERGENCY_NUMBERS,cellNo];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([EmergencyNumberResponse initWithData:[responseObject objectForKey:@"GetEmergencyNumbersResult"]]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) addEditEmergencyNumbers:(NSString*)cellNo
                       eNumberA:(NSString*)eNumberA
                       eNumberB:(NSString*)eNumberB
                       eNumberC:(NSString*)eNumberC
             viewController:(UIViewController*)viewController
            CompletionBlock:(void(^)(UpdateNumberResponse *obj))block
               FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@/%@/%@/%@",WEBSERVICE_ADDEDIT_EMERGENCY_NUMBERS,cellNo, eNumberA,eNumberB,eNumberC];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([UpdateNumberResponse initWithData:[responseObject objectForKey:@"UpdateEmergencyNumbersResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) getContacts:(NSString*)cellNo
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSArray *responseArray))block
       FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@",WEBSERVICE_GET_CONTACTS,cellNo];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([ContactsResponse initWithData:[responseObject objectForKey:@"GetListSecoContactFromPrimaryCellResult"]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) addSecondaryUser:(NSString*)firstName
                lastName:(NSString*)lastName
                     nic:(NSString*)nic
                 phoneNo:(NSString*)phoneNo
               primaryNo:(NSString*)primaryNo
              deviceName:(NSString*)deviceName
              deviceIMEI:(NSString*)deviceIMEI
             deviceSimNo:(NSString*)deviceSimNo
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(AddSecUserResponse *responseArray))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@/%@/%@/%@",WEBSERVICE_ADD_SECONDARYUSER,firstName,lastName,primaryNo,phoneNo,nic,deviceName,deviceIMEI,deviceSimNo];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([AddSecUserResponse initWithData:[[responseObject objectForKey:@"CreateNewSecondaryUsersResult"] objectAtIndex:0]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) deleteSecondaryUser:(NSString*)contactID
                 deviceImei:(NSString*)deviceImei
             viewController:(UIViewController*)viewController
            CompletionBlock:(void(^)(DeleteUserResponse *responseArray))block
               FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_DEL_SECONDARYUSER, contactID, deviceImei];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([DeleteUserResponse initWithData:[[responseObject objectForKey:@"DeleteSecondaryUserResult"] objectAtIndex:0]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

///SecondaryUserMapping/{ContactId}/{PrimaryMobileNo}/{CellNo}/{DeviceName}/{DeviceImei}/{DeviceSimNo}

-(void) mapSecondaryUser:(NSString*)contactID
               primaryNo:(NSString*)primaryNo
          optionalCellNo:(NSString*)optionalCellNo
              deviceName:(NSString*)deviceName
              deviceIMEI:(NSString*)deviceIMEI
             deviceSimNo:(NSString*)deviceSimNo
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(MapSecUserResponse *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@/%@",WEBSERVICE_MAP_SECONDARYUSER, contactID,primaryNo,optionalCellNo,deviceName,deviceIMEI,deviceSimNo];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([MapSecUserResponse initWithData:[[responseObject objectForKey:@"SecondaryUserMappingResult"] objectAtIndex:0]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

///DeletePt1Device/{CellNo}/{PinCode}/{TrackerId}/{DeviceName}/{DeviceImei}/{DeviceSimNo}

-(void) deleteDevice:(NSString*)cellNo
             pinCode:(NSString*)pinCode
           trackerID:(NSString*)trackerID
          deviceName:(NSString*)deviceName
          deviceIMEI:(NSString*)deviceIMEI
         deviceSimNo:(NSString*)deviceSimNo
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(DeleteDeviceResponse *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@/%@",WEBSERVICE_DELETE_DEVICE, cellNo,pinCode,trackerID,deviceName,deviceIMEI,deviceSimNo];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([DeleteDeviceResponse initWithData:[[responseObject objectForKey:@"DeletePt1DeviceResult"] objectAtIndex:0]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) getUserTypeForDevice:(NSString*)cellNo
          deviceIMEI:(NSString*)deviceIMEI
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(UserTypeResponse *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    [self showProgressAlertTitle:nil message:@"Loading..." view:viewController.view];
    
    NSString *completeURL = [NSString stringWithFormat:@"%@%@/%@",WEBSERVICE_GET_USER_TYPE_FOR_DEVICE, deviceIMEI,cellNo];
    
    [self GET:completeURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideProgressAlert];
        block([UserTypeResponse UserTypeResponseFromDict:[[responseObject objectForKey:@"UserTypeFromSelectionResult"] objectAtIndex:0]]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideProgressAlert];
        errorBlock(error);
    }];
}

-(void) userLogin:(NSString *)userEmail
         password:(NSString *)password
      deviceToken:(NSString *)deviceToken
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(NSArray *responseArray))block
     FailureBlock:(void(^)(NSError *error))errorBlock
{
    
    //NSString *progressMessage=@"Logging In...";
    
    DAAlertAction *okAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                       style:DAAlertActionStyleCancel
                                                     handler:nil];
    
    [DAAlertController showAlertViewInViewController:viewController
                                           withTitle:@"Character Limit Exceeded!"
                                             message:@"Allowed:\nPassword: 10 chars"
                                             actions:@[okAction]];
    
    //NSMutableDictionary *parameters=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                     //userEmail, @"user_blog_id",
                                     ////password, @"user_password",
                                     //deviceToken, @"user_device_token",
                                     //nil];

}

*/




@end
