//
//  WebclientPT1.h
//  TPLTrakker
//
//  Created by Sajid Saeed on 02/09/2015.
//  Copyright (c) 2015 TRG. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"


@interface Webclient : AFHTTPSessionManager{
    MBProgressHUD *HUD;
}


+ (Webclient *)sharedWeatherHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

-(void) hideProgressAlert;
-(void) showProgressAlertTitle:(NSString *)title message:(NSString *)message view:(UIView*)view;
-(void) showProgressAlertOnView:(NSString *)title message:(NSString *)message view:(UIView*)view;
-(void) hideProgressAlertOnView:(UIView*)view;

-(void) getAttendess:(NSString *)eventID
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getAgenda:(NSString *)eventID
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(NSObject *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getEventSpeakers:(NSString *)eventID
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getEventList:(NSString*)webserviceName
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) signUP:(NSString *)firstName
      lastName:(NSString *)lastName
         email:(NSString *)email
       company:(NSString *)company
   phoneNumber:(NSString *)phoneNumber
    jobTitleID:(NSString *)jobTitleID
      password:(NSString *)password
viewController:(UIViewController*)viewController
CompletionBlock:(void(^)(NSObject *responseObject))block
  FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getJobTitles:(NSString *)serviceType
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) updateProfile:(NSMutableDictionary *)data
             newImage:(UIImage *)newImage
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) forgotPassword:(NSString *)emailAddress
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) login:(NSString *)userID
     password:(NSString *)password
   grant_type:(NSString *)grant_type
viewController:(UIViewController*)viewController
CompletionBlock:(void(^)(NSObject *responseObject))block
 FailureBlock:(void(^)(NSObject *responseObject))errorBlock;

-(void) getUserProfile:(NSString *)userID
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getSponsors:(NSString *)eventID
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) logout:(UIViewController*)viewController
CompletionBlock:(void(^)(NSObject *responseObject))block
  FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) changePassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
       confirmPassword:(NSString *)confirmPassword
                userID:(NSString *)userID
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) isUserAlreadyJoined:(NSString *)userID
                    eventID:(NSString *)eventID
             viewController:(UIViewController*)viewController
            CompletionBlock:(void(^)(NSObject *responseObject))block
               FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) joinRequest:(NSString *)userID
            eventID:(NSString *)eventID
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock;


-(void) getFAQQuestionList:(NSString*)eventID
            viewController:(UIViewController*)viewController
           CompletionBlock:(void(^)(NSObject *responseObject))block
              FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getSideMenuUserProfile:(NSString *)userID
                viewController:(UIViewController*)viewController
               CompletionBlock:(void(^)(NSObject *responseObject))block
                  FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getEventCounts:(NSString*)eventID
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;
    
-(void) registerDeviceToken:(NSString *)deviceToken
                 createDate:(NSString *)createDate
               modifiedDate:(NSString *)modifiedDate
                 deviceType:(NSString *)deviceType
                     userID:(NSString *)userID
             viewController:(UIViewController*)viewController
            CompletionBlock:(void(^)(NSObject *responseObject))block
               FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getGoldAndYPOMemberLost:(NSString*)webserviceName
           viewController:(UIViewController*)viewController
          CompletionBlock:(void(^)(NSObject *responseObject))block
             FailureBlock:(void(^)(NSError *error))errorBlock ;

-(void) getSearchEventAndList:(NSString*)webserviceName
                 viewController:(UIViewController*)viewController
                CompletionBlock:(void(^)(NSObject *responseObject))block
                   FailureBlock:(void(^)(NSError *error))errorBlock ;

-(void) getAllSchedule:(NSString*)webserviceName
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock ;

-(void) getAllSupportingFile:(NSString*)webserviceName
              viewController:(UIViewController*)viewController
             CompletionBlock:(void(^)(NSObject *responseObject))block
                FailureBlock:(void(^)(NSError *error))errorBlock ;
-(void) getPolicyData:(NSString*)webserviceName
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock ;

-(void) uploadImage:(NSMutableDictionary *)data
           newImage:(UIImage *)newImage
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock ;

-(void) getNewsLetter:(NSString*)webserviceName
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock ;
-(void) getAllUserList:(NSString*)webserviceName
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock  ;
-(void) blockRequest:(NSString *)userID
             eventID:(NSString *)eventID
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock ;
-(void) getAllNotification:(NSString*)webserviceName
            viewController:(UIViewController*)viewController
           CompletionBlock:(void(^)(NSObject *responseObject))block
              FailureBlock:(void(^)(NSError *error))errorBlock ;

-(void) deleteAllNotification:(NSString *)userID
               viewController:(UIViewController*)viewController
              CompletionBlock:(void(^)(NSObject *responseObject))block
                 FailureBlock:(void(^)(NSError *error))errorBlock ;
-(void) getPrivacyPolicy:(NSString*)webserviceName
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock ;


/*
 -(void) userLogin:(NSString *)cellNumber
       deviceType:(NSString *)deviceType
      deviceToken:(NSString *)deviceToken
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(NSObject *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) verifyPincode:(NSString *)cellNumber
              pinCode:(NSString *)pinCode
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(NSObject *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) registerUser:(NSString *)cellNumber
               email:(NSString *)email
            username:(NSString*)username
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(NSObject *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getProducts:(UIViewController*)viewController
    CompletionBlock:(void(^)(NSObject *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getProductDetail:(NSString*)policyID
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) saveImage:(NSString*)mobileNo
            title:(NSString*)title
        imageFile:(UIImage*)imageFile
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(NSObject *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getDocumentList:(NSString*)mobileNo
         viewController:(UIViewController*)viewController
        CompletionBlock:(void(^)(NSObject *responseObject))block
           FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) deleteDocument:(NSString*)docID
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getCustomerInquiry:(NSString*)cnic
            viewController:(UIViewController*)viewController
           CompletionBlock:(void(^)(NSObject *responseObject))block
              FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) callHelp:(NSString*)mobileNumber
       longitude:(NSString*)longitude
        latitude:(NSString*)latitude
  viewController:(UIViewController*)viewController
 CompletionBlock:(void(^)(NSObject *responseObject))block
    FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getCalorieRecords:(UIViewController*)viewController
          CompletionBlock:(void(^)(NSObject *responseObject))block
             FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getNotifications:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSObject *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) vertifyDetails:(NSString*)CNIC
          mobileNumber:(NSString*)mobileNumber
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSObject *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getPolicynInformation:(NSString*)CNIC
                 mobileNumber:(NSString*)mobileNumber
               viewController:(UIViewController*)viewController
              CompletionBlock:(void(^)(NSObject *responseObject))block
                 FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getPartners:(NSString *)userEmail
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(PartnersResponse *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) userLogin:(NSString *)userEmail
         password:(NSString *)password
       deviceType:(NSString *)deviceType
      deviceToken:(NSString *)deviceToken
   viewController:(UIViewController*)viewController
  CompletionBlock:(void(^)(LoginResponse *responseObject))block
     FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getUserDetails:(NSString *)userEmail
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(UserDetailsResponse *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getResources:(NSString *)userEmail
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getSocials:(NSString *)userEmail
    viewController:(UIViewController*)viewController
   CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
      FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getSchedules:(NSString *)userEmail
      viewController:(UIViewController*)viewController
     CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
        FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getOffsites:(NSString *)userEmail
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getMyCalender:(NSString *)userEmail
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock;

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
         FailureBlock:(void(^)(NSError *error))errorBlock;




-(void) getAttendiesContactList:(NSString *)userEmail
                   isSpouseList:(NSString *)isSpouseList
                 viewController:(UIViewController*)viewController
                CompletionBlock:(void(^)(AttendiesResponse *attendiesObj))block
                   FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) forgetPassword:(NSString *)userEmail
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(ForgetPassResponse *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getNotifications:(NSString *)userEmail
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(NotificationResponse *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) changePassword:(NSString *)userEmail
                userID:(NSString *)userID
           newPassword:(NSString *)newPassword
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(ResourcesResponse *responseObject))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getMessage:(NSString *)userEmail
            userID:(NSString*)userID
        receiverID:(NSString*)receiverID
        pageNumber:(NSString*)pageNumber
    viewController:(UIViewController*)viewController
   CompletionBlock:(void(^)(GetMessageResponse *responseObject))block
      FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) sendMessage:(NSString *)userEmail
             userID:(NSString*)userID
         receiverID:(NSString*)receiverID
            message:(NSString*)message
     viewController:(UIViewController*)viewController
    CompletionBlock:(void(^)(SendMessageResponse *responseObject))block
       FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getAttendiesList:(NSString *)userEmail
               offisteID:(NSString *)offsiteID
                  dateID:(NSString *)dateID
                  timeID:(NSString *)timeID
          viewController:(UIViewController*)viewController
         CompletionBlock:(void(^)(AttendiesListResponse *responseObject))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) registerEvent:(NSString *)userEmail
               userID:(NSString *)userID
              eventID:(NSString *)eventID
               dateID:(NSString *)dateID
               timeID:(NSString *)timeID
          serviceType:(NSString *)serviceType
       viewController:(UIViewController*)viewController
      CompletionBlock:(void(^)(RegisterEventResponse *responseObject))block
         FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) unRegisterAllEvent:(NSString *)userEmail
                 userID:(NSString *)userID
               isDelete:(NSString *)isDelete
                 dateID:(NSString *)dateID
                 timeID:(NSString *)timeID
            serviceType:(NSString *)serviceType
         viewController:(UIViewController*)viewController
        CompletionBlock:(void(^)(RegisterEventResponse *responseObject))block
           FailureBlock:(void(^)(NSError *error))errorBlock;
/*
-(void) getVehicleList:(NSString *)phoneNumber
        viewController:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getComplaintCategory:(UIViewController*)viewController
             CompletionBlock:(void(^)(NSArray *response))block
                FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getComplaintSubCategory:(UIViewController*)viewController
                CompletionBlock:(void(^)(NSArray *response))block
                   FailureBlock:(void(^)(NSError *error))errorBlock;

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
              FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getSecondaryContactsForNumber:(NSString*)number
                                 view:(UIViewController*)viewController
                      CompletionBlock:(void(^)(NSArray *response))block
                         FailureBlock:(void(^)(NSError *error))errorBlock;


-(void) getVehicleMapUserList:(NSString*)vehicleID
                         view:(UIViewController*)viewController
              CompletionBlock:(void(^)(NSArray *response))block
                 FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) addSecondaryUser:(NSString*)primaryNo
               firstName:(NSString*)firstName
                lastName:(NSString*)lastName
                 contact:(NSString*)contact
                     nic:(NSString*)nic
                   regNo:(NSString*)regNo
                    view:(UIViewController*)viewController
         CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) editSecondaryUser:(NSString*)primaryNo
                firstName:(NSString*)firstName
                 lastName:(NSString*)lastName
                  contact:(NSString*)contact
                      nic:(NSString*)nic
                    regNo:(NSString*)regNo
                     view:(UIViewController*)viewController
          CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
             FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) fetchSecondaryUser:(NSString*)primaryNo
                      view:(UIViewController*)viewController
           CompletionBlock:(void(^)(GetContactDetailsResponse *response))block
              FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) deleteUser:(NSString*)primaryNo
    registrationNo:(NSString*)registrationNo
         contactID:(NSString*)contactID
              view:(UIViewController*)viewController
   CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
      FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) mapUser:(NSString*)primaryNo
 registrationNo:(NSString*)registrationNo
      contactID:(NSString*)contactID
           view:(UIViewController*)viewController
CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
   FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) fetchMapUserList:(NSString*)vehicleID
                    view:(UIViewController*)viewController
         CompletionBlock:(void(^)(GetContactDetailsResponse *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) unMapUser:(NSString*)primaryNo
   registrationNo:(NSString*)registrationNo
        contactID:(NSString*)contactID
             view:(UIViewController*)viewController
  CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
     FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) changePassword:(UIViewController*)viewController
             vehicleID:(NSString*)vehicleID
             primaryNo:(NSString*)primaryNo
           oldPassword:(NSString*)oldPassword
           newPassword:(NSString*)newPassword
    confirmNewPassword:(NSString*)confirmNewPassword
       CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) fetchUserProfileDetails:(NSString*)vehicleID
                           view:(UIViewController*)viewController
                CompletionBlock:(void(^)(ECSFetchUserProfile *response))block
                   FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) updateUserProfile:(NSString*)primaryNo
             emailAddress:(NSString*)emailAddress
       residentialAddress:(NSString*)residentialAddress
           billingAddress:(NSString*)billingAddress
                accountNo:(NSString*)accountNo
               customerID:(NSString*)customerID
          registerationID:(NSString*)registrationID
                     view:(UIViewController*)viewController
          CompletionBlock:(void(^)(ECSAddSecondaryUserResponse *response))block
             FailureBlock:(void(^)(NSError *error))errorBlock;


-(void) fetchPackageList:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSArray *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) fetchFeatureList:(UIViewController*)viewController
         CompletionBlock:(void(^)(NSArray *response))block
            FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) fetchMakerList:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) fetchModelList:(NSString*)makerID
                  view:(UIViewController*)viewController
       CompletionBlock:(void(^)(NSArray *response))block
          FailureBlock:(void(^)(NSError *error))errorBlock;

-(void) getNewInstallationAmount:(NSString*)packageID
                            type:(NSString*)type
                            view:(UIViewController*)viewController
                 CompletionBlock:(void(^)(NSArray *response))block
                    FailureBlock:(void(^)(NSError *error))errorBlock;


-(void) getNewInstallationAmount:(NSString*)packageID
                            type:(NSString*)type
                            view:(UIViewController*)viewController
                 CompletionBlock:(void(^)(NSArray *response))block
                    FailureBlock:(void(^)(NSError *error))errorBlock;
*/
@end
/*
@protocol WeatherHTTPClientDelegate <NSObject>
@optional
-(void)weatherHTTPClient:(WeatherHTTPClient *)client didUpdateWithWeather:(id)weather;
-(void)weatherHTTPClient:(WeatherHTTPClient *)client didFailWithError:(NSError *)error;
@end
*/
