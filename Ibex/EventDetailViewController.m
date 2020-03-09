//
//  EventDetailViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 03/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "Constant.h"
#import "MainViewController.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "loginResponse.h"
#import "JoinRequestResponse.h"
#import "SignUpViewController.h"
#import "IsJoinedResponsed.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "AttendessResponse.h"
#import "EventSpeakerModel.h"
#import "EventSpeakerResponse.h"
#import "EventSpeakerModel.h"
#import "AttendeesViewController.h"
#import "EventSpeakersViewController.h"
#import "YPOMapViewController.h"
#import "AgendaViewController.h"
#import "YPOAttendessListCell.h"
#import "YPOResourceCell.h"
#import "YPORecentChatVc.h"
#import "YPONotificationVC.h"
#import "YPOSearchEventListVc.h"
#import "OrganizationCell.h"
#import "YPOAdminVc.h"

#define kGradientStartColor	[UIColor colorWithRed:142.0 / 255.0 green:214.0 / 255.0 blue:39.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:13.0 / 255.0 green:222.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]


@interface EventDetailViewController ()<UICollectionViewDelegate , UICollectionViewDataSource>
{
    AttendessResponse *masterObj;
    EventSpeakerResponse *masterObjOfEventSpeaker;

    __weak IBOutlet UILabel *lblEventDetail;
    
    // Attendess Images
    
    IBOutlet UIImageView *imageOfAdmin;
    
    IBOutlet UIImageView *imageOfOrganizer;
    
    IBOutlet UIView *viewOfMember;
    __weak IBOutlet UILabel *lblTopic;
    __weak IBOutlet UICollectionView *collectionViewOfAttendess;
    __weak IBOutlet UICollectionView *collectionViewOfResource;
    __weak IBOutlet UICollectionView *collectionViewOfOrganizer;

    IBOutlet UIButton *btnChat;

    IBOutlet UILabel *eventType;
    
}
@property(nonatomic , strong) NSArray *listOfOrganizationList ;
@end

@implementation EventDetailViewController
@synthesize eventObj,lblDate,lblTime,lblTitle,lblLocationName,tvDesc,ivLogi,isJoinButton,btnJoin,viewApproved,isPrevious,lblEventTopic,lblRegistrationType , scheduleObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _listOfOrganizationList =  [[NSArray alloc] init];
    [self restoreData];
    [self.tvDesc scrollRangeToVisible:NSMakeRange(0, 1)];
    self.tvDesc.scrollEnabled = YES;
    
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];

    NSURL *imageURL ;
    NSURL *imageUrlForAdmin ;
    

    
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(clickOnAdmin:)];
//
//    [imageOfAdmin setUserInteractionEnabled:true];
//    [imageOfAdmin addGestureRecognizer:singleFingerTap];
//
//    UITapGestureRecognizer *tapOnOrganization =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(clickOnOrganizationImage:)];
//    [imageOfOrganizer setUserInteractionEnabled:true];
//
//    [imageOfOrganizer addGestureRecognizer:tapOnOrganization];
//    id  thumbnailImage        = [self.eventObj.organizer valueForKey:@"dpPathThumb"] ;
//    id  thumbnailImageOfAdmin = [self.eventObj.admin valueForKey:@"dpPathThumb"] ;
//    id  listOfOrganizer = self.eventObj.organizerList  ;
//    NSString *value = @"" ;
//    if (listOfOrganizer != [NSNull null]) {
//        if ([listOfOrganizer isEqualToString:value]) {
//
//        } else {
//            _listOfOrganizationList = [listOfOrganizer componentsSeparatedByString:@","];
//            NSLog(@"print it %lu", (unsigned long)_listOfOrganizationList.count);
//
//        }
//    }
//
//    if (thumbnailImageOfAdmin != [NSNull null]) {
//        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[[self.eventObj.admin valueForKey:@"dpPathThumb"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
//        imageUrlForAdmin  = [NSURL URLWithString:imageURLString];
//
//    }else {
//
//    }
//    [imageOfAdmin setImageWithURL:imageUrlForAdmin placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
//    [Utility setViewCornerRadius:imageOfAdmin radius:imageOfAdmin.frame.size.width/2];
//
//    if (thumbnailImage != [NSNull null]) {
//        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[[self.eventObj.organizer valueForKey:@"dpPathThumb"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
//        imageURL  = [NSURL URLWithString:imageURLString];
//
//    }else {
//
//    }
    //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,event.eventThumbImg]];
    
    [imageOfOrganizer setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
    [Utility setViewCornerRadius:imageOfOrganizer radius:imageOfOrganizer.frame.size.width/2];
    
    if ([self.eventObj.isEventGoldOrYPO isEqualToString:@"YPO"]){
//        eventType.text = self.eventObj.isEventGoldOrYPO ;
        eventType.text = [NSString stringWithFormat:@"%@ MEMBERS ONLY", self.eventObj.isEventGoldOrYPO];
        [viewOfMember setHidden:false];

        eventType.textColor = [UIColor colorWithRed:17/255.0 green:64/255.0 blue:100/255.0 alpha:1.0];
    } else if ([self.eventObj.isEventGoldOrYPO isEqualToString:@"Gold"]){
        eventType.text = [NSString stringWithFormat:@"%@ MEMBERS ONLY", self.eventObj.isEventGoldOrYPO];
        eventType.textColor = [UIColor colorWithRed:243/255.0 green:185/255.0 blue:51/255.0 alpha:1.0];
        [viewOfMember setHidden:false];

    } else {
        
        eventType.text =  @"";
        [viewOfMember setHidden:true];
        
    }
    
    
    
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"loginsuccess"
                                               object:nil];
    
    if (_pushType == 1) {
        
        lblEventDetail.text = self.scheduleObj.name ;
        lblTopic.text = self.scheduleObj.eventTopic ;

    } else {
        lblEventDetail.text = self.eventObj.eventName ;
        lblTopic.text = self.eventObj.eventTopic ;
        
    }
    
    [self fetchAttendees];
    [self fetchEventSpeaker];

    
}

//- (void)clickOnAdmin:(UITapGestureRecognizer *)recognizer
//{
//    YPOAdminVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOAdminVc"];
//    vc.eventObj = self.eventObj ;
//    vc.listOfOrganizationList = _listOfOrganizationList ;
//    //    [vc.navigationController setHidesBarsOnTap:false];
//    [self.navigationController pushViewController:vc animated:true];
//}
//
//- (void)clickOnOrganizationImage:(UITapGestureRecognizer *)recognizer
//{
//    YPOAdminVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOAdminVc"];
//    vc.eventObj = self.eventObj ;
//    vc.listOfOrganizationList = _listOfOrganizationList ;
//    //    [vc.navigationController setHidesBarsOnTap:false];
//    [self.navigationController pushViewController:vc animated:true];
//}


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

- (IBAction)btnChat_Pressed:(UIButton *)sender {
    YPORecentChatVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPORecentChatVc"];
    
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btnNotification_Pressed:(UIButton *)sender {
    YPONotificationVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPONotificationVC"];
    
    [self.navigationController pushViewController:vc animated:true];
}


- (IBAction)btnSearch_Pressed:(UIButton *)sender {
    
    YPOSearchEventListVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSearchEventListVc"];
    
    [self.navigationController pushViewController:vc animated:true];
    
}


- (IBAction)btnMapShow_Pressed:(UIButton *)sender {
    YPOMapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMapViewController"];
   
    if (_pushType == 1) {
        
        vc.scheduleObj = scheduleObj ;
        vc.selectedVc = 2 ;
        
        
    }else {
        vc.eventObj = eventObj ;
        vc.selectedVc = 1 ;


    }
    
    [self.navigationController pushViewController:vc animated:true];
    
    
}



//The event handling method
//- (void)goToAttendess:(UITapGestureRecognizer *)recognizer
//{
//    
//
//    
//    
//    
//    
////    YPOMediaDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMediaDetailVc"];
////    
////    vc.valueChange = 0 ;
////    
////    NSMutableArray *arrayOfFile  = [[NSMutableArray alloc] init];
////    
////    
////    for (MOGetAllSupportingObject *obj in tempmasterObj.eventList)
////    {
////        if ([obj.fileType isEqualToString:@".jpg"] || [obj.fileType isEqualToString:@".png"])
////        {
////            [arrayOfFile addObject:obj];
////        }
////    }
////    vc.images = [arrayOfFile mutableCopy] ;
////    
////    
////    //    arrayOfFile
////    [self.navigationController pushViewController:vc animated:true];
//    
//    
//}
//

- (IBAction)btnAgenda_Pressed:(UIButton *)sender {
//    agendaVC

    AgendaViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"agendaVC"];
    
    
    if (_pushType == 1) {
        vc.schedule = scheduleObj ;
        
    } else {
        vc.eventObj = eventObj ;

    }
    
    [self.navigationController pushViewController:vc animated:true];
    
    
}


- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] init];
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
    
    [[Webclient sharedWeatherHTTPClient] isUserAlreadyJoined:[NSString stringWithFormat:@"%@", obj.loginUserID] eventID:[NSString stringWithFormat:@"%@",eventObj.eventEventID] viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        IsJoinedResponsed *joinResponse = (IsJoinedResponsed*) responseObject;
        
        if([[NSString stringWithFormat:@"%@", joinResponse.status] isEqualToString:@"1"]){
            if([joinResponse.data isEqual:@"no"]){
                [btnJoin setHidden:NO];
                [viewApproved setHidden:YES];
                [btnJoin setTitle:@"JOIN" forState:UIControlStateNormal];
                [btnJoin setTitle:@"JOIN" forState:UIControlStateHighlighted];
            }
            else if([joinResponse.data isEqualToString:@"1"]){
                [btnJoin setHidden:NO];
                [viewApproved setHidden:YES];
                [btnJoin setTitle:@"ENTER" forState:UIControlStateNormal];
                [btnJoin setTitle:@"ENTER" forState:UIControlStateHighlighted];
            }
            else if([joinResponse.data isEqualToString:@"0"]){
                [btnJoin setHidden:YES];
                [viewApproved setHidden:NO];
            }
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];

}

-(void) fetchAttendees{
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *eventID ;
    
    
    if (_pushType == 1) {
      eventID  = [NSString stringWithFormat:@"%@", scheduleObj.idOfEvent];
    } else {
        eventID  = [NSString stringWithFormat:@"%@", eventObj.eventEventID];
    }
    [[Webclient sharedWeatherHTTPClient] getAttendess:eventID viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        masterObj = (AttendessResponse*) responseObject;

        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
            [masterObj.attendeesList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
//                EventSpeakerModel *object = (EventSpeakerModel*)obj;
                collectionViewOfAttendess.delegate = self ;
                collectionViewOfAttendess.dataSource = self ;
                [collectionViewOfAttendess reloadData];
                
                
                

            }] ;
            
            
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", masterObj.message] actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    
}

-(void) fetchEventSpeaker {
    
    NSString *eventID  ;
    
    if (_pushType == 1) {
        eventID  = [NSString stringWithFormat:@"%@", scheduleObj.idOfEvent];
    } else {
        eventID  = [NSString stringWithFormat:@"%@", eventObj.eventEventID];
    }

    
    [[Webclient sharedWeatherHTTPClient] getEventSpeakers:eventID viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        masterObjOfEventSpeaker = (EventSpeakerResponse*) responseObject;
        
        if([[NSString stringWithFormat:@"%@", masterObjOfEventSpeaker.status] isEqualToString:@"1"]){
            


            [masterObjOfEventSpeaker.speakerList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
//                EventSpeakerModel *object = (EventSpeakerModel *)obj;
                
                collectionViewOfResource.delegate = self ;
                collectionViewOfResource.dataSource = self ;
                [collectionViewOfResource reloadData];


                

            }] ;
            

        
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", masterObj.message] actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationItem setHidesBackButton:YES];
}




-(void) restoreData{
    
    if (self.pushType == 1)
    {
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[scheduleObj.logoPathThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,eventObj.eventThumbImg]];
        [ivLogi setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
//        [ivLogi setContentMode:UIViewContentModeScaleAspectFit];
        [ivLogi setClipsToBounds:YES];
        
        [lblTitle setText:[NSString stringWithFormat:@"%@", scheduleObj.name]];
        //    lblTitle.gradientStartColor = kGradientStartColor;
        //    lblTitle.gradientEndColor = kGradientEndColor;
        //    lblTitle.gradientStartPoint = CGPointMake(0, 0);
        //    lblTitle.gradientEndPoint = CGPointMake(300, 0);
        
       
        [self.btnDate setTitle:[NSString stringWithFormat:@"%@", [self dateFromStringFormatter:scheduleObj.startDate]] forState:UIControlStateNormal] ;
//        [self.btnDate setTitle:[NSString stringWithFormat:@"%@ - %@" , [self dateFromStringFormatter:eventObj.eventStartDate] ,[self dateFromStringFormatter:eventObj.eventEndDate]] forState:UIControlStateNormal];

        
        [self.btnTime setTitle:[NSString stringWithFormat:@"%@ - %@", scheduleObj.startTime,scheduleObj.endTime] forState:UIControlStateNormal] ;

//        [self.btnTime setTitle:[NSString stringWithFormat:@"%@", scheduleObj.startTime] forState:UIControlStateNormal] ;
        
//        [self.btnLocationName setTitle:[NSString stringWithFormat:@"%@", scheduleObj.venueAddress] forState:UIControlStateNormal] ;
        
        [tvDesc setText:[NSString stringWithFormat:@"%@", scheduleObj.descriptionOfEvent]];
        [tvDesc scrollRangeToVisible:NSMakeRange(0, 1)];
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", scheduleObj.eventRegistrationType]]){
            [lblRegistrationType setText:[NSString stringWithFormat:@"%@", scheduleObj.eventRegistrationType]];
        }
        else{
            [lblRegistrationType setText:@""];
        }
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        if([defaults objectForKey:@"UserData"]){
            [btnJoin setTitle:@"Register" forState:UIControlStateNormal];
            [btnJoin setTitle:@"JOIN" forState:UIControlStateHighlighted];
        }
        else{
            [btnJoin setTitle:@"JOIN (Register Attendee's Only)" forState:UIControlStateNormal];
            [btnJoin setTitle:@"JOIN (Register Attendee's Only)" forState:UIControlStateHighlighted];
        }
        
        
        if (isJoinButton) {
            [btnJoin setHidden:NO];
            [viewApproved setHidden:YES];
        }
        else
        {
            [btnJoin setHidden:YES];
            [viewApproved setHidden:NO];
        }
        
        if(isPrevious){
            [btnJoin setHidden:YES];
            [viewApproved setHidden:YES];
        }


    }
    else
    {
        NSURL *imageURL ;
        id  thumbnailImage = eventObj.eventThumbImg ;
        
        if (thumbnailImage != [NSNull null]) {
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[eventObj.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
           imageURL   = [NSURL URLWithString:imageURLString];
            
        }else {
            
        }

        
        //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,eventObj.eventThumbImg]];
        [ivLogi setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
//        [ivLogi setContentMode:UIViewContentModeScaleAspectFit];
        [ivLogi setClipsToBounds:YES];
        
        [lblTitle setText:[NSString stringWithFormat:@"%@", eventObj.eventName]];
        [self.btnDate setTitle:[NSString stringWithFormat:@"%@", [self dateFromStringFormatter:eventObj.eventStartDate]] forState:UIControlStateNormal] ;
//        [self.btnTime setTitle:[NSString stringWithFormat:@"%@", eventObj.eventStartTime] forState:UIControlStateNormal] ;

        [self.btnTime setTitle:[NSString stringWithFormat:@"%@ - %@", eventObj.eventStartTime,eventObj.eventEndTime] forState:UIControlStateNormal] ;
        [tvDesc setText:[NSString stringWithFormat:@"%@", eventObj.eventDescription]];
        [tvDesc scrollRangeToVisible:NSMakeRange(0, 1)];
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", eventObj.eventRegistrationType]]){
            [lblRegistrationType setText:[NSString stringWithFormat:@"%@", eventObj.eventRegistrationType]];
        }
        else{
            [lblRegistrationType setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", eventObj.eventTopic]]){
            [lblEventTopic setText:[NSString stringWithFormat:@"%@", eventObj.eventTopic]];
        }
        else{
            [lblEventTopic setText:@""];
        }
        NSLog(@"print it %@", self.joinResponse);
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        
//        if([[NSString stringWithFormat:@"%@", _joinResponse.status] isEqualToString:@"1"]){
//        }
        
        
          if([_joinResponse.data isEqual:@"no"]){
              [btnJoin setHidden:NO];
              [viewApproved setHidden:YES];
                    [btnJoin setTitle:@" Register " forState:UIControlStateNormal];
                     [btnJoin setTitle:@"JOIN" forState:UIControlStateHighlighted];
                    }
                    else if([_joinResponse.data isEqualToString:@"1"]){
                        [btnJoin setHidden:NO];
                        [viewApproved setHidden:YES];
//                        [btnJoin setHidden:YES];
                        _isUserAlreadyRegister = true ;
                        
//                        [btnJoin setTitle:@"Pending the request" forState:UIControlStateNormal];
                        [btnJoin setTitle:@" Unregister " forState:UIControlStateNormal];
                    }
                    else if([_joinResponse.data isEqualToString:@"0"]){
                        [btnJoin setTitle:@" Pending request " forState:UIControlStateNormal];

//                        [btnJoin setHidden:YES];
                        [viewApproved setHidden:NO];
                    }

//        if([defaults objectForKey:@"UserData"]){
//            [btnJoin setTitle:@" Register" forState:UIControlStateNormal];
//            [btnJoin setTitle:@"JOIN" forState:UIControlStateHighlighted];
//        }
//        else{
//            [btnJoin setTitle:@"JOIN (Register Attendee's Only)" forState:UIControlStateNormal];
//            [btnJoin setTitle:@"JOIN (Register Attendee's Only)" forState:UIControlStateHighlighted];
//        }
//        
//        
////        if (isJoinButton) {
////            [btnJoin setHidden:NO];
////            [viewApproved setHidden:YES];
////        }
////        else
////        {
//////            [btnJoin setHidden:YES];
////            [btnJoin setTitle:@"Pending For Approve" forState:UIControlStateNormal];
////            [viewApproved setHidden:NO];
////        }
        
        if(isPrevious){
            [btnJoin setHidden:YES];
            [viewApproved setHidden:YES];
        }
  
    }
    
    }

-(NSString*) timeFromStringFormatter:(NSString*)timeString{
    if([Utility isEmptyOrNull:timeString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *yourDate = [dateFormatter dateFromString:timeString];
    dateFormatter.dateFormat = @"hh:mm aa";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}

-(NSString*) dateFromStringFormatter:(NSString*)dateString{
    if([Utility isEmptyOrNull:dateString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"EEEE MMM dd";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}

-(void) joinRequest{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
    
    if (_pushType == 1)
    {
        [[Webclient sharedWeatherHTTPClient] joinRequest:obj.loginUserID eventID:scheduleObj.idOfEvent viewController:self CompletionBlock:^(NSObject *responseObject) {
            
            JoinRequestResponse *obj = (JoinRequestResponse *) responseObject;
            
            if([[NSString stringWithFormat:@"%@", obj.status] isEqualToString:@"1"]){
                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                        style:DAAlertActionStyleCancel
                                                                      handler:^{
                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                      }];
                
                [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"Request has been sent, It will take a while for approval." actions:@[dismissAction]];
                
            }
            else{
                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                        style:DAAlertActionStyleCancel
                                                                      handler:^{
                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                      }];
                
                [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
            }
            
        } FailureBlock:^(NSError *error) {
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
        }];
    }
    else
    {
    
    [[Webclient sharedWeatherHTTPClient] joinRequest:obj.loginUserID eventID:eventObj.eventEventID viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        JoinRequestResponse *obj = (JoinRequestResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", obj.status] isEqualToString:@"1"]){
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"Request has been sent, It will take a while for approval." actions:@[dismissAction]];
            
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
        }
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    }
        
}

- (IBAction)joinButtonPressed:(id)sender {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
    if ([eventObj.isEventGoldOrYPO isEqualToString:@"Joint"]){
     
        if (_isUserAlreadyRegister == true) {
            
            
            [[Webclient sharedWeatherHTTPClient] joinRequest:obj.loginUserID eventID:eventObj.eventEventID viewController:self CompletionBlock:^(NSObject *responseObject) {
                NSLog(@"print it %@", responseObject);
                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                        style:DAAlertActionStyleCancel
                                                                      handler:^{
                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                      }];
                
                [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"Un Register Successfully ." actions:@[dismissAction]];
                
                
            } FailureBlock:^(NSError *error) {
                
            }] ;
            
            //        [[Webclient sharedWeatherHTTPClient] blockRequest:obj.loginUserID eventID:eventObj.eventEventID viewController:self CompletionBlock:^(NSObject *responseObject) {
            
            
            //            if([[NSString stringWithFormat:@"%@", obj.status] isEqualToString:@"1"]){
            //
            //
            //            }
            //            else{
            //                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
            //                                                                        style:DAAlertActionStyleCancel
            //                                                                      handler:^{
            //                                                                          [self.navigationController popViewControllerAnimated:YES];
            //                                                                      }];
            //
            //                [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
            //            }
            
            //        } FailureBlock:^(NSError *error) {
            //            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
            //                                                                    style:DAAlertActionStyleCancel
            //                                                                  handler:^{
            //                                                                  }];
            //
            //            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
            //        }];
            ////        api/EventAttendee/BlockAttendee/9/2
            //        NSLog(@"print it ") ;
            
        } else {
            
            
            if([[btnJoin.titleLabel.text lowercaseString] isEqualToString:@"enter"]){
                AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                appDelegate.selectedEventID = [NSString stringWithFormat:@"%@", eventObj.eventEventID];
                //EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
                appDelegate.eventObj = eventObj;
//                [self gotoDashboard];
                return;
            }
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            if([defaults objectForKey:@"UserData"]){
                
                DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                                       style:DAAlertActionStyleCancel handler:nil];
                DAAlertAction *signOutAction = [DAAlertAction actionWithTitle:@"YES"
                                                                        style:DAAlertActionStyleDestructive handler:^{
                                                                            [self joinRequest];
                                                                        }];
                
                [DAAlertController showAlertViewInViewController:self
                                                       withTitle:@"Join Event"
                                                         message:@"Are you interested in attending the event? On pressing 'YES', your request will be send to the administrator of the event for authorization.  \n\nPlease be aware that it may take up 5 days to gain authorization."
                                                         actions:@[cancelAction, signOutAction]];
                
                
            }
            else{
                DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                                       style:DAAlertActionStyleCancel handler:nil];
                DAAlertAction *signOutAction = [DAAlertAction actionWithTitle:@"Login"
                                                                        style:DAAlertActionStyleDestructive handler:^{
                                                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                            //SignUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"signupVC"];
                                                                            //vc.isJoinRequest = true;
                                                                            ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
                                                                            vc.isJoin = true;
                                                                            [self presentViewController:vc animated:YES completion:^{
                                                                                
                                                                            }];
                                                                        }];
                [DAAlertController showAlertViewInViewController:self
                                                       withTitle:@"Login Request"
                                                         message:@"Only registered users can join events. If you are interested in joining the event please register first or login."
                                                         actions:@[cancelAction, signOutAction]];
            }
        }
    }
    
    else if ([btnJoin.titleLabel.text isEqualToString:@" Unregister "]){

    
//    else if ([self.eventObj.isEventGoldOrYPO isEqualToString:obj.userType]){
        
            if (_isUserAlreadyRegister == true) {
                
                
                [[Webclient sharedWeatherHTTPClient] blockRequest:obj.loginUserID eventID:eventObj.eventEventID viewController:self CompletionBlock:^(NSObject *responseObject) {
                    NSLog(@"print it %@", responseObject);
                    DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                            style:DAAlertActionStyleCancel
                                                                          handler:^{
                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                          }];
                    
                    [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"Un Register Successfully ." actions:@[dismissAction]];
                    
                    
                } FailureBlock:^(NSError *error) {
                    
                }] ;
                
                //        [[Webclient sharedWeatherHTTPClient] blockRequest:obj.loginUserID eventID:eventObj.eventEventID viewController:self CompletionBlock:^(NSObject *responseObject) {
                
                
                //            if([[NSString stringWithFormat:@"%@", obj.status] isEqualToString:@"1"]){
                //
                //
                //            }
                //            else{
                //                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                //                                                                        style:DAAlertActionStyleCancel
                //                                                                      handler:^{
                //                                                                          [self.navigationController popViewControllerAnimated:YES];
                //                                                                      }];
                //
                //                [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
                //            }
                
                //        } FailureBlock:^(NSError *error) {
                //            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                //                                                                    style:DAAlertActionStyleCancel
                //                                                                  handler:^{
                //                                                                  }];
                //
                //            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
                //        }];
                ////        api/EventAttendee/BlockAttendee/9/2
                //        NSLog(@"print it ") ;
                
            } else {
                
                
                if([[btnJoin.titleLabel.text lowercaseString] isEqualToString:@"enter"]){
                    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                    appDelegate.selectedEventID = [NSString stringWithFormat:@"%@", eventObj.eventEventID];
                    //EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
                    appDelegate.eventObj = eventObj;
                    [self gotoDashboard];
                    return;
                }
                
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                if([defaults objectForKey:@"UserData"]){
                    
                    DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                                           style:DAAlertActionStyleCancel handler:nil];
                    DAAlertAction *signOutAction = [DAAlertAction actionWithTitle:@"YES"
                                                                            style:DAAlertActionStyleDestructive handler:^{
                                                                                [self joinRequest];
                                                                            }];
                    
                    [DAAlertController showAlertViewInViewController:self
                                                           withTitle:@"Join Event"
                                                             message:@"Are you interested in attending the event? On pressing 'YES', your request will be send to the administrator of the event for authorization.  \n\nPlease be aware that it may take up 5 days to gain authorization."
                                                             actions:@[cancelAction, signOutAction]];
                    
                    
                }
                else{
                    DAAlertAction *cancelAction = [DAAlertAction actionWithTitle:@"Cancel"
                                                                           style:DAAlertActionStyleCancel handler:nil];
                    DAAlertAction *signOutAction = [DAAlertAction actionWithTitle:@"Login"
                                                                            style:DAAlertActionStyleDestructive handler:^{
                                                                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                                //SignUpViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"signupVC"];
                                                                                //vc.isJoinRequest = true;
                                                                                ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
                                                                                vc.isJoin = true;
                                                                                [self presentViewController:vc animated:YES completion:^{
                                                                                    
                                                                                }];
                                                                            }];
                    [DAAlertController showAlertViewInViewController:self
                                                           withTitle:@"Login Request"
                                                             message:@"Only registered users can join events. If you are interested in joining the event please register first or login."
                                                             actions:@[cancelAction, signOutAction]];
                }
            }
        
    }
    else if ([self.eventObj.isEventGoldOrYPO isEqualToString:obj.userType]){
    
        [[Webclient sharedWeatherHTTPClient] joinRequest:obj.loginUserID eventID:eventObj.eventEventID viewController:self CompletionBlock:^(NSObject *responseObject) {
            NSLog(@"print it %@", responseObject);
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"Request In Pending ." actions:@[dismissAction]];
            
            
        } FailureBlock:^(NSError *error) {
            
        }] ;
    
    }
    
    
    else {
            [self showAlertViewWithTitle:@"YPO" message:@"You are not allowed for this event to regiser"];
        }

//    if([self.eventObj.isEventGoldOrYPO isEqualToString:obj.userType]){
//      else {
//        [self showAlertViewWithTitle:@"YPO" message:@"You are not allowed for this event to regiser"];
//    }
//    }
}


-(void) gotoDashboard{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavHomeScreen"];
    
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Event details Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self.tvDesc setContentOffset:CGPointZero animated:NO];
}


#pragma mark -UITableView Method-



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == collectionViewOfOrganizer) {
        return  self.eventObj.organizerArray.count ;

    }
     else if (collectionView ==  collectionViewOfAttendess) {
        return  masterObj.attendeesList.count ;
        
    }
    else
    {
        return  masterObjOfEventSpeaker.speakerList.count ;

    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"YPOAttendessListCell";
    static NSString *identifierOfResource = @"YPOResourceCell";
    static NSString *identifierOfOrganization = @"OrganizationCell" ;
    
    if (collectionView == collectionViewOfOrganizer) {
        OrganizationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierOfOrganization forIndexPath:indexPath];
        EventSpeakerModel *obj = (EventSpeakerModel *)[self.eventObj.organizerArray objectAtIndex:indexPath.row];
        NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.speakerBigImage];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [cell.imageOrOrganizer setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:cell.imageOrOrganizer radius:cell.imageOrOrganizer.frame.size.width/2];

       
        return cell ;

    }
   else  if (collectionView == collectionViewOfAttendess) {
        YPOAttendessListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        EventSpeakerModel *obj = (EventSpeakerModel *)[masterObj.attendeesList objectAtIndex:indexPath.row];
        NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.speakerBigImage];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [cell.imageOfAttendessList setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:cell.imageOfAttendessList radius:cell.imageOfAttendessList.frame.size.width/2];

        
        return cell ;
        }
    else
    {
        YPOResourceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierOfResource forIndexPath:indexPath];
        EventSpeakerModel *obj = (EventSpeakerModel *)[masterObjOfEventSpeaker.speakerList objectAtIndex:indexPath.row];
        NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.speakerBigImage];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [cell.imageOfResourceList setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:cell.imageOfResourceList radius:cell.imageOfResourceList.frame.size.width/2];

        return  cell ;
        
    
    }
    

//
//    
//    ImagesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.filePath];
//    NSURL *imageURL = [NSURL URLWithString:imageURLString];
//    [cell.imageOfCollection setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@""]];
//    cell.eventName.text = obj.eventName ;
//    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collectionViewOfOrganizer) {
        YPOAdminVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOAdminVc"];
//        EventObject *obj = (EventObject *)[self.eventObj objectAtIndex:indexPath.row];
        vc.organizerArrayList = self.eventObj.organizerArray ;
//        vc.eventObj = self.eventObj ;
//        vc.listOfOrganizationList = _listOfOrganizationList ;
        //    [vc.navigationController setHidesBarsOnTap:false];
        [self.navigationController pushViewController:vc animated:true];

    }
   else  if (collectionView ==  collectionViewOfAttendess) {

        AttendeesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"attendeesVC"];
        vc.masterObj = masterObj ;
        [self.navigationController pushViewController:vc animated:true];
    }
    else if (collectionView == collectionViewOfResource) {
     
        EventSpeakersViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"esVC"];
        vc.masterObj = masterObjOfEventSpeaker ;
        [self.navigationController pushViewController:vc animated:true];

    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidth = collectionView.frame.size.width / 8 - 1    ;
    //    float cellHeight  = collectionView.frame.size.height / 4  ;
    
    if (collectionView == collectionViewOfOrganizer) {
        CGSize wdth = CGSizeMake(34, 34);
        return wdth ;

    }
    
   else  if (collectionView ==  collectionViewOfAttendess) {
        CGSize wdth = CGSizeMake(cellWidth, 34);
        return wdth ;
    }
    else
    {
        CGSize wdth = CGSizeMake(cellWidth, 34);
        return wdth ;
        
    }

    
    
}

@end
