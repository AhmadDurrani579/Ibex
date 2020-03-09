
//  YPOMySchedule.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOMySchedule.h"
#import "EventsCell.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "YPOSchedule.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "loginResponse.h"
#import "YPOScheduleObject.h"
#import "AppDelegate.h"
#import "EventDetailViewController.h"
#import "ActionSheetDatePicker.h"
#import "Utility.h"
#import "SWTableViewCell.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "UICustomDatePicker.h"
#import "NSString+Date.h"
#import "SRMonthPicker.h"
#import "EventAdd+CoreDataClass.h"
#import "EventSupportModel.h"
#import "AppDelegate.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "IsJoinedResponsed.h"
#import "EventDetailViewController.h"
#import "YPORecentChatVc.h"
#import "YPONotificationVC.h"
#import "YPOSearchEventListVc.h"
#import "AppDelegate.h"
#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>
@protocol GAITracker ;
//#import "Schedule+CoreDataClass.h"
@interface YPOMySchedule ()<UITableViewDelegate , UITableViewDataSource , SWTableViewCellDelegate , EKEventEditViewDelegate, SRMonthPickerDelegate>
{
    YPOSchedule *tempmasterObj;
    
    __weak IBOutlet UIButton *btnSelectDate;
    __weak IBOutlet UITableView *tblView;
    NSString *year ;
    NSString *month ;
    NSString *identifier ;
    BOOL isUserOrEvent ;
    IsJoinedResponsed *joinResponse;
    IBOutlet UIButton *btnChat;
    
    AppDelegate *app ;
    
}
@property (weak, nonatomic) IBOutlet SRMonthPicker *monthPicker;
@property (weak, nonatomic) IBOutlet UIView *viewOfDatePicker;
@property (nonatomic,strong) EventAdd *eventAdd;
@property (nonatomic , strong)NSMutableArray *arrayOfEvent ;
@property (nonatomic , strong)NSMutableArray *arrayofCalIDs ;




@end

@implementation YPOMySchedule

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.monthPicker.monthPickerDelegate = self;
    
    _arrayOfEvent = [[NSMutableArray alloc] init];
    
    _arrayOfEvent = [EventAdd fetchAll].mutableCopy;
    //
    app = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    // Some options to play around with
    self.monthPicker.maximumYear = 2050;
    self.monthPicker.minimumYear = 1900;
    self.monthPicker.yearFirst = YES;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    year   = [Utility convertDateToString:[NSDate date] withFormat:@"yyyy"] ;
    month   = [Utility convertDateToString:[NSDate date] withFormat:@"MM"] ;
    [self getAllSchedule:year month:month];
    NSString *currentMonth = [dateFormatter stringFromDate:[NSDate date]] ;
    [btnSelectDate setTitle:currentMonth forState:UIControlStateNormal];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"My Schedules Screen"];
    //    [tracker sendView:@"Home Screen"];
    //    [tracker setScreen:@"Home Screen"];
    //    [tracker send:[[[GAIDictionaryBuilder createScreenView] set:@"Home Screen"
    //                                                         forKey:@"Home Screen"] build]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:@"My Schedules Screen"
//           value:@"My Schedules Screen"];
//
//
//    //    [tracker set:kGAIScreenName value:NSStringFromClass([self class])];
//
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//
////    id tracker = [[GAI sharedInstance] defaultTracker];
//////    [tracker setScreen:@"My Schedules Screen"] ;
////    [tracker set:kGAIScreenName value:@"My Schedules Screen"];
//////    [tracker set:@"My Schedules Screen"
//////           value:@"My Schedules Screen"];
////    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//
//
//}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];
    btnChat.badgeValue = app.badgeValueCount ;
    [[self navigationController] setNavigationBarHidden:true animated:YES];
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

- (void) initCustomDatePicker:(UICustomDatePicker *) picker withOption:(NSUInteger) option andOrder:(NSUInteger) order {
    picker.minDate = [[NSString stringWithFormat:@"06/July/2016"] dateValueForFormatString:@"dd/MMM/yyyy"];
    picker.maxDate = [[NSString stringWithFormat:@"06/Aug/2050"] dateValueForFormatString:@"dd/MMM/yyyy"];
    picker.currentDate = [NSDate date];
    picker.order = order;
    picker.option = option;
}

- (void)monthPickerWillChangeDate:(SRMonthPicker *)monthPicker
{
    // Show the date is changing (with a 1 second wait mimicked)
    [btnSelectDate setTitle:[NSString stringWithFormat:@"%@", [self formatDate:monthPicker.date]] forState:UIControlStateNormal] ;
    year   = [Utility convertDateToString:monthPicker.date withFormat:@"yyyy"] ;
    month   = [Utility convertDateToString:monthPicker.date withFormat:@"MM"] ;
    
    
}

- (void)monthPickerDidChangeDate:(SRMonthPicker *)monthPicker
{
    // All this GCD stuff is here so that the label change on -[self monthPickerWillChangeDate] will be visible
    dispatch_queue_t delayQueue = dispatch_queue_create("com.simonrice.SRMonthPickerExample.DelayQueue", 0);
    
    dispatch_async(delayQueue, ^{
        // Wait 1 second
        sleep(0);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM"];
            year   = [Utility convertDateToString:monthPicker.date withFormat:@"yyyy"] ;
            month   = [Utility convertDateToString:monthPicker.date withFormat:@"MM"] ;
            [btnSelectDate setTitle:[NSString stringWithFormat:@"%@", [self formatDate:self.monthPicker.date]] forState:UIControlStateNormal];
            
            
            
            //            self.label.text = [NSString stringWithFormat:@"Selected: %@", [self formatDate:self.monthPicker.date]];
        });
    });
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    
//    NSArray *array = [self.navigationController viewControllers];
//    [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
    [self.navigationController popViewControllerAnimated:true] ;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma Mark -Top bar button Action-
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


-(void)getAllSchedule:(NSString *)yearsPAss month :(NSString *)monthPass {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *)[defaults rm_customObjectForKey:@"UserData"];
    int yearValue = [yearsPAss intValue];
    int monthValue = [monthPass intValue];
    NSString *serviceType ;
    
    
    if (_pushType == 1){
        serviceType = [NSString stringWithFormat:@"%s%@/%d/%d%s","api/Event/getAllMonthwiseJoinedEventsByUserIdByPage/",@"-1" ,monthValue,yearValue,"/0/100000"] ;
        
    }else {
        serviceType = [NSString stringWithFormat:@"%s%@/%d/%d%s","api/Event/getAllMonthwiseJoinedEventsByUserIdByPage/",obj.loginUserID,monthValue,yearValue,"/0/100000"] ;
        
    }
    
//    if (_pushType == 1){
//        serviceType = [NSString stringWithFormat:@"%s%@/%d/%d%s","api/Event/getAllMonthwiseJoinedEventsByUserIdByPage/",@"-1",monthValue,yearValue,"/0/100000"] ;
//
//    }else {
//        serviceType = [NSString stringWithFormat:@"%s%@/%d/%d%s","api/Event/getAllMonthwiseJoinedEventsByUserIdByPage/",@"-1",monthValue,yearValue,"/0/100000"] ;
//
//    }
    
    [[Webclient sharedWeatherHTTPClient] getAllSchedule:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (YPOSchedule *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            
            tblView.delegate = self ;
            tblView.dataSource = self ;
            [tblView reloadData];
        }
        
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    
    
}

- (NSString*)formatDate:(NSDate *)date
{
    // A convenience method that formats the date in Month-Year format
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM";
    return [formatter stringFromDate:date];
}



//-(void)getAllSchedule
//{
// 
//
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//    NSString *serviceType  = [NSString stringWithFormat:@"%s%@%s","api/Event/getAllJoinedEventsByUserIdByPage/",obj.loginUserID ,"/0/100000"] ;
//    
//    [[Webclient sharedWeatherHTTPClient] getAllSchedule:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
//        tempmasterObj = (YPOSchedule *) responseObject;
//        
//        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
//            //[tvEvents reloadData];
//            
//            tblView.delegate = self ;
//            tblView.dataSource = self ;
//            [tblView reloadData];
//        }
//        
//        
//    } FailureBlock:^(NSError *error) {
//        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                style:DAAlertActionStyleCancel
//                                                              handler:^{
//                                                                  
//                                                              }];
//        
//        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
//    }];
//}
- (IBAction)btnCancel:(UIButton *)sender {
    [_viewOfDatePicker setHidden:true];
    
}
- (IBAction)btnDone_PRessed:(UIButton *)sender {
    
    [self getAllSchedule:year month:month];
    
    [_viewOfDatePicker setHidden:true];
}

- (IBAction)btnSelectDate:(UIButton *)sender {
    
    [_viewOfDatePicker setHidden:false];
}

-(void)selectDate {
    
}


#pragma mark -UITableView Method-


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numOfSections = 0;
    if (tempmasterObj.eventList.count >0)
    {
        numOfSections                = 1;
        tblView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tblView.bounds.size.width, tblView.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tblView.backgroundView = noDataLabel;
        tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  tempmasterObj.eventList.count ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EventsCell *cell = (EventsCell *)[tableView dequeueReusableCellWithIdentifier:@"EventsCell"];
    EventObject *obj  =  (EventObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
    EventAdd *listOfEvent ;
    //    EventSupportModel *model = (EventSupportModel *)[obj.supportingContentList objectAtIndex:indexPath.row];
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    
    if (_arrayOfEvent.count > 0) {
        //        listOfEvent = (EventAdd *)[_arrayOfEvent objectAtIndex:indexPath.row];
    }
    if (_arrayOfEvent.count > 0) {
        
        EventAdd *profile = [EventAdd fetchWithPredicate:[NSPredicate predicateWithFormat:@"scheduleId == %@",obj.eventEventID] sortDescriptor:nil fetchLimit:0].lastObject;
        NSLog(@"print it %@", profile.scheduleId);
        
        
        if ([[NSString stringWithFormat:@"%@",obj.eventEventID] isEqualToString:[NSString stringWithFormat:@"%@",profile.scheduleId]]){
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:243/255.0 green:19/255.0 blue:56/255.0 alpha:1.0f]
             //
                                                         icon:[UIImage imageNamed:@"delevent"]];
        } else {
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0]
                                                         icon:[UIImage imageNamed:@"addevent"]];
        }
        
        
    } else {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0]
                                                     icon:[UIImage imageNamed:@"addevent"]];
    }
    
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0]
    //                                                 icon:[UIImage imageNamed:@"addevent"]];
    
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    
    
    [cell setSchedule:obj];
    //    [cell setSupportModel:model];
    
    
    return cell ;
    
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    EventsCell *cel = (EventsCell *)cell;
    EventObject *obj = (EventObject *)cel.schedule ;
    EventAdd         *listOfEvent ;
    if (_arrayOfEvent.count > 0) {
        listOfEvent   = (EventAdd *)[_arrayOfEvent objectAtIndex:index];
        
    }
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError* error){
            if(!granted){
                NSString *message = @"Hey! This Project Can't access your Calendar... check your privacy settings to let it in!";
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Present alert for warning.
                });
            }else{
                
                EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
                EventAdd *profile = [EventAdd fetchWithPredicate:[NSPredicate predicateWithFormat:@"scheduleId == %@",obj.eventEventID] sortDescriptor:nil fetchLimit:0].lastObject;
                
                if ([[NSString stringWithFormat:@"%@",obj.eventEventID] isEqualToString:[NSString stringWithFormat:@"%@",profile.scheduleId]]){
                    
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
                    NSString *fullActionLabel = [NSString stringWithFormat:@"%@ (%@) %@ event(%@)" , userInfo.loginDisplayName,userInfo.loginUserID ,@"removed event" , obj.eventEventID];
                   
//                    [NSString stringWithFormat:@"%@ (%@) %@ (%@)" , userInfo.loginDisplayName,userInfo.loginUserID ,@"added event" , schedule.eventEventID];
                    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                                          action:@"Remove Event from Calendar"
                                                                           label:fullActionLabel
                                                                           value:nil] build]];
                    
                    
                    EKEvent *event = [eventStore eventWithIdentifier:profile.eventIdentifier];
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:NSLocalizedString(@"Alert", @"")
                                                  message:NSLocalizedString(@"Are you sure you want to remove this event from Calender?", @"")
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"") style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   NSError *error;
                                                                   if (![eventStore removeEvent:event span:EKSpanFutureEvents error:&error]) {
                                                                       // Display the error description.
                                                                       NSLog(@"%@", [error localizedDescription]);
                                                                   } else {
                                                                       NSLog(@"Delete Successfully") ;
                                                                   }
                                                                   
                                                                   [EventAdd deleteObject:listOfEvent];
                                                                   _arrayOfEvent  = [EventAdd fetchAll].mutableCopy ;
                                                                   NSLog(@"Event deleted successfully");
                                                                   
                                                                   [tblView reloadData];
                                                                   
                                                               }];
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"") style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action) {
                                                                       _arrayOfEvent  = [EventAdd fetchAll].mutableCopy ;
                                                                       NSLog(@"Event Not Delete successfully");
                                                                       
                                                                       [tblView reloadData];
                                                                       
                                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                                   }];
                    
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    // Delete it.
                    //                    NSLog(@"HEllo");
                    
                    //                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    //                    event.title = obj.name;
                    //                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //                    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    //                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    //
                    //                    NSString *start = [obj.startDate stringByReplacingOccurrencesOfString:@"T"
                    //                                                                                         withString:@"  "];
                    //
                    //                    NSString *end = [obj.endDate stringByReplacingOccurrencesOfString:@"T"
                    //                                                                                     withString:@"  "];
                    //
                    //                    NSDate *startDate = [dateFormatter dateFromString:start];
                    //                    NSDate *endDate = [dateFormatter dateFromString:end];
                    //
                    //                    event.startDate = startDate;
                    //                    event.endDate = endDate;
                    //
                    //                    event.location = obj.venueAddress ;
                    //                    event.allDay = YES;
                    //                    event.notes = obj.descriptionOfEvent;
                    //                    NSError *err;
                    //
                    //                    [eventStore removeEvent:event span:EKSpanThisEvent error:&err];
                    
                    
                    
                }else {
                    addController.event = [self createEvent:eventStore schedule:obj];
                    addController.eventStore = eventStore;
                    
                    [self presentViewController:addController animated:YES completion:nil];
                    addController.editViewDelegate = self;
                    
                }
                
            }
        }];
    }
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    //    PACreateProfileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PACreateProfileViewController"];
}

#pragma mark - eventEditDelegates -
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    if (action ==EKEventEditViewActionCanceled) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (action==EKEventEditViewActionSaved) {
        
        _eventAdd.eventIdentifier = controller.event.eventIdentifier ;
        [EventAdd save];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}



#pragma mark - createEvent -
-(EKEvent*)createEvent:(EKEventStore*)eventStore schedule :(EventObject *)schedule{
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    
    NSLog(@"print it %@", event.eventIdentifier);
    
    //    if (!_eventAdd) {
    //
    //
    //    }
    _eventAdd = (EventAdd *)[EventAdd create];
    _eventAdd.name =  schedule.eventName ;
    _eventAdd.scheduleDescription = schedule.eventDescription ;
    _eventAdd.startDate = schedule.eventStartDate ;
    _eventAdd.endDate = schedule.eventEndDate ;
    _eventAdd.startTime = schedule.eventStartTime ;
    _eventAdd.endTime = schedule.eventEndTime ;
    _eventAdd.scheduleAddress = schedule.eventVenueAddress ;
     NSString *strX=[NSString stringWithFormat:@"%@",schedule.eventEventID];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSString *fullActionLabel = [NSString stringWithFormat:@"%@ (%@) %@ event(%@)" , userInfo.loginDisplayName,userInfo.loginUserID ,@"added event" , schedule.eventEventID];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"Add Event To Calendar"
                                                           label:fullActionLabel
                                                           value:nil] build]];
    _eventAdd.scheduleId = strX ;
    _eventAdd.isAdded = @(true) ;
    [EventAdd save];
    
    event.title = schedule.eventName;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *start = [schedule.eventStartDate stringByReplacingOccurrencesOfString:@"T"
                                                                         withString:@"  "];
    
    NSString *end = [schedule.eventEndDate stringByReplacingOccurrencesOfString:@"T"
                                                                     withString:@"  "];
    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    event.startDate = startDate;
    event.endDate = endDate;
    event.location = schedule.eventVenueAddress ;
    event.allDay = YES;
    event.notes = schedule.eventDescription;
    
    NSString* calendarName = schedule.eventName ;
    EKCalendar* calendar;
    EKSource* localSource;
    for (EKSource *source in eventStore.sources){
        if (source.sourceType == EKSourceTypeCalDAV &&
            [source.title isEqualToString:@"iCloud"]){
            localSource = source;
            break;
        }
    }
    if (localSource == nil){
        for (EKSource *source in eventStore.sources){
            if (source.sourceType == EKSourceTypeLocal){
                localSource = source;
                break;
            }
        }
    }
    calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
    
    
    calendar.source = localSource;
    calendar.title = calendarName;
    NSError* error;
    
    [eventStore saveCalendar:calendar commit:YES error:&error];
    _arrayOfEvent = [EventAdd fetchAll].mutableCopy ;
    [tblView reloadData];
    
    return event;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EventDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
    //    YPOScheduleObject *obj  =  [tempmasterObj.eventList objectAtIndex:indexPath.row];
    //    vc.scheduleObj = obj ;
    //    vc.pushType = 1 ;
    //    vc.isJoinButton = false;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    EventObject *event = [tempmasterObj.eventList objectAtIndex:indexPath.row];
    
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
    
    //    NSLog(@"EventID: %@, UserID: %@", event.eventEventID, obj.loginUserID);
    
    [[Webclient sharedWeatherHTTPClient] isUserAlreadyJoined:[NSString stringWithFormat:@"%@", obj.loginUserID] eventID:[NSString stringWithFormat:@"%@",event.eventEventID] viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        joinResponse = (IsJoinedResponsed*) responseObject;
        
        if([[NSString stringWithFormat:@"%@", joinResponse.status] isEqualToString:@"1"]){
            if([joinResponse.data isEqual:@"no"]){
                AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
                EventObject *event = [tempmasterObj.eventList objectAtIndex:indexPath.row];
                vc.joinResponse = joinResponse  ;
                vc.eventObj = event;
                vc.isJoinButton = false;
                vc.pushType = 0 ;
                [self.navigationController pushViewController:vc animated:true];
                
                //                        [appDelegate.baseController pushViewController:vc animated:YES];
            }
            else if([joinResponse.data isEqualToString:@"1"]){
                AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                //                    HomeViewViewController
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
                
                //                    HomeViewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"];
                appDelegate.selectedEventID = [NSString stringWithFormat:@"%@", event.eventEventID];
                EventObject *event = [tempmasterObj.eventList objectAtIndex:indexPath.row];
                vc.eventObj = event ;
                vc.joinResponse = joinResponse ;
                
                
                appDelegate.eventObj = event;
                [self.navigationController pushViewController:vc animated:true];
                
                //                        [appDelegate.baseController pushViewController:vc animated:YES];
                
                //                    [self gotoDashboard];
            }
            else if([joinResponse.data isEqualToString:@"0"]){
                AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
                EventObject *event = [tempmasterObj.eventList objectAtIndex:indexPath.row];
                vc.eventObj = event;
                vc.pushType = 0 ;
                vc.joinResponse = joinResponse ;
                vc.isJoinButton = false;
                [self.navigationController pushViewController:vc animated:true];
                
                //                        [appDelegate.baseController pushViewController:vc animated:YES];
                
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



@end
