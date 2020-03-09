//
//  EventTableViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 30/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventTableViewController.h"
#import "EventTableViewCell.h"
#import "Webclient.h"
#import "EventListResponse.h"
#import "EventObject.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "EventDetailViewController.h"
#import "Webclient.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "DAAlertController.h"
#import "IsJoinedResponsed.h"
#import "MainViewController.h"
#import "HomeViewViewController.h"
#define kGradientStartColor	[UIColor colorWithRed:142.0 / 255.0 green:214.0 / 255.0 blue:39.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:13.0 / 255.0 green:222.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]

@interface EventTableViewController (){
    EventListResponse *masterObj;
    EventListResponse *tempmasterObj;
    IsJoinedResponsed *joinResponse;
}
@property (assign) BOOL isAnnual;

@end

@implementation EventTableViewController
@synthesize tvEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];

    tvEvents.rowHeight = UITableViewAutomaticDimension;
    tvEvents.estimatedRowHeight = 44.0;
    [self fetchEventList];

//    if ([Utility connectedToNetwork]) {
//        [self fetchEventList];
//
//    } else {
//        [self restoreData];
//    }
    
    refreshControl = [[UIRefreshControl alloc]init];
    [tvEvents addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"dataReceived"
                                               object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque];
    _isAnnual = false ;


}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self fetchEventList];
}


//-(NSDate*)str2date:(NSString*)dateStr{
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm:ss a Z";
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    // see https://developer.apple.com/library/ios/qa/qa1480/_index.html
//
//
//    NSDate *date = [dateFormatter dateFromString:dateStr];
//
//    return date;
//}
- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    [self restoreData];
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self restoreData];
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) restoreData{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    

    if([defaults objectForKey:@"DataOne"] && [defaults objectForKey:@"DataTwo"] && [defaults objectForKey:@"DataThree"]){
        
    }
    else{
        return;
    }
    
    if([[self.title lowercaseString] isEqualToString:@"previous"]){
        masterObj = [defaults rm_customObjectForKey:@"DataOne"];
    }
    else if([[self.title lowercaseString] isEqualToString:@"upcoming"]){
        masterObj = [defaults rm_customObjectForKey:@"DataTwo"];
    }
 
    else if([[self.title lowercaseString] isEqualToString:@"annual"]){
        masterObj = [defaults rm_customObjectForKey:@"DataThree"];
        _isAnnual = true ;
        
        
    }
    
    [tvEvents reloadData];
}


-(BOOL)prefersStatusBarHidden{
    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void) fetchEventList{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    //[defaults setObject:[NSString stringWithFormat:@"%@", tfPassword.text] forKey:@"UserPass"];
    
    [defaults synchronize];

    
    NSString *serviceType = [[NSString alloc] init];
    
    serviceType = @"api/Event/getPastByPage/1/10000";
    
    [[Webclient sharedWeatherHTTPClient] getEventList:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (EventListResponse*) responseObject;
        
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            //[tvEvents reloadData];
            [defaults rm_setCustomObject:tempmasterObj forKey:@"DataOne"];
            [defaults synchronize];
            
            [[Webclient sharedWeatherHTTPClient] getEventList:@"api/Event/GetUpComingByPage/1/10000" viewController:self CompletionBlock:^(NSObject *responseObject) {
                tempmasterObj = (EventListResponse*) responseObject;
                
                if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
                    
                    
                    [defaults rm_setCustomObject:tempmasterObj forKey:@"DataTwo"];
                    [defaults synchronize];
                    
                    [[Webclient sharedWeatherHTTPClient] getEventList:@"api/Event/getAllByPage/-1/1/10000" viewController:self CompletionBlock:^(NSObject *responseObject) {
                        tempmasterObj = (EventListResponse*) responseObject;
                        
                        [defaults rm_setCustomObject:tempmasterObj forKey:@"DataThree"];
                        [defaults synchronize];
                        
                        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
                            [self restoreData];
                        }
                        
                        
                    } FailureBlock:^(NSError *error) {
                        
                        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                                style:DAAlertActionStyleCancel
                                                                              handler:^{
                                                                                  [refreshControl endRefreshing];
                                                                                  //[refreshControl removeFromSuperview];
                                                                              }];
                        
                        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
                    }];

                }

                
            } FailureBlock:^(NSError *error) {
                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                        style:DAAlertActionStyleCancel
                                                                      handler:^{
                                                                          [refreshControl endRefreshing];
                                                                          //[refreshControl removeFromSuperview];
                                                                      }];
                
                [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
            }];
        }

        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [refreshControl endRefreshing];
                                                                  //[refreshControl removeFromSuperview];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if (masterObj.eventList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvEvents.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvEvents.bounds.size.width, tvEvents.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvEvents.backgroundView = noDataLabel;
        tvEvents.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return masterObj.eventList.count;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
    
    if([[self.title lowercaseString] isEqualToString:@"previous"]){
        
        if([defaults objectForKey:@"UserData"]){
        loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
        
            [[Webclient sharedWeatherHTTPClient] isUserAlreadyJoined:[NSString stringWithFormat:@"%@", obj.loginUserID] eventID:[NSString stringWithFormat:@"%@",event.eventEventID] viewController:self CompletionBlock:^(NSObject *responseObject) {
                
                joinResponse = (IsJoinedResponsed*) responseObject;
                
                if([[NSString stringWithFormat:@"%@", joinResponse.status] isEqualToString:@"1"]){
                    if([joinResponse.data isEqual:@"no"]){
                        AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        
                        EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
                        EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
                        vc.eventObj = event;
                        vc.isPrevious = true;
                        vc.isJoinButton = false;
                        [appDelegate.baseController pushViewController:vc animated:YES];
                    }
                    else if([joinResponse.data isEqualToString:@"1"]){
                        AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];

//                        HomeViewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"];

                        appDelegate.selectedEventID = [NSString stringWithFormat:@"%@", event.eventEventID];
                        EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
                        appDelegate.eventObj = event;
                        vc.eventObj = event ;
                        
//                        HomeViewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"];
                        [appDelegate.baseController pushViewController:vc animated:YES];

//                        HomeScreen
//                        [self gotoDashboard];
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
        else{
            AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
            EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
            vc.eventObj = event;
            vc.isPrevious = true;
            vc.isJoinButton = false;
            [appDelegate.baseController pushViewController:vc animated:YES];
        }

        
        return;
    }
    
    if([defaults objectForKey:@"UserData"]){
        
        loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
        
        NSLog(@"EventID: %@, UserID: %@", event.eventEventID, obj.loginUserID);
        
        [[Webclient sharedWeatherHTTPClient] isUserAlreadyJoined:[NSString stringWithFormat:@"%@", obj.loginUserID] eventID:[NSString stringWithFormat:@"%@",event.eventEventID] viewController:self CompletionBlock:^(NSObject *responseObject) {
            
            joinResponse = (IsJoinedResponsed*) responseObject;
            
            if([[NSString stringWithFormat:@"%@", joinResponse.status] isEqualToString:@"1"]){
                if([joinResponse.data isEqual:@"no"]){
                    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
                    EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
                    vc.joinResponse = joinResponse  ;
                    vc.eventObj = event;
                    vc.isJoinButton = false;
                    vc.pushType = 0 ;
                    
                    [appDelegate.baseController pushViewController:vc animated:YES];
                }
                else if([joinResponse.data isEqualToString:@"1"]){
                    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
//                    HomeViewViewController

                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];

//                    HomeViewViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"];
                    appDelegate.selectedEventID = [NSString stringWithFormat:@"%@", event.eventEventID];
                    EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
                    vc.eventObj = event ;
                    vc.joinResponse = joinResponse ;


                    appDelegate.eventObj = event;
                    [appDelegate.baseController pushViewController:vc animated:YES];

//                    [self gotoDashboard];
                }
                else if([joinResponse.data isEqualToString:@"0"]){                    
                    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
                    EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
                    vc.eventObj = event;
                    vc.pushType = 0 ;
                    vc.joinResponse = joinResponse ;
                    vc.isJoinButton = false;
                    [appDelegate.baseController pushViewController:vc animated:YES];
                    
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
    else{
        AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EventDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
        vc.joinResponse = joinResponse ;

        EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
        vc.eventObj = event;
        vc.isJoinButton = true;
        [appDelegate.baseController pushViewController:vc animated:YES];
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EventCell";
    
    EventTableViewCell *cell = (EventTableViewCell *)[tvEvents dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EventObject *event = [masterObj.eventList objectAtIndex:indexPath.row];
    
    [cell.lblTitle setText:event.eventName];

    if (_isAnnual == true){
        [cell.viewOfColouring setHidden:false];
        [cell.isPastOrFuture setHidden:false];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
//        [dateFormatter setDateFormat:@"EEEE, yyyy , MMMM d,  'at' h:mm:ss a zzzz"];
        NSString *str ;
        id  checkStartDate = event.eventStartDate ;
        
        if (checkStartDate != [NSNull null]) {
            str = [event.eventStartDate stringByReplacingOccurrencesOfString:@"T"
                                                                            withString:@"  "];

        }else {
            
        }

        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

//        [dateFormatter setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
        dateFormatters.dateFormat = @"yyyy/MM/dd hh:mm:ss a Z";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        // see https://developer.apple.com/library/ios/qa/qa1480/_index.html
        
        
        NSDate *date = [dateFormatter dateFromString:str];

        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
        NSDate * now = [NSDate date];
        NSDate * mile = date;
        NSComparisonResult result = [now compare:mile];
        
        NSLog(@"%@", now);
        NSLog(@"%@", mile);
        switch (result)
        {
            case NSOrderedAscending:
                
                if ([mile compare:newDate] == NSOrderedAscending) {
                    
                    if ([event.isEventGoldOrYPO isEqualToString:@"YPO"]){
                        cell.viewOfColouring.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];
                        cell.imageOfPastOrUpComping.image = UIImageWithName(@"cs") ;

                        [cell.imageOfColour setHidden:true];

                    }else if ([event.isEventGoldOrYPO isEqualToString:@"Gold"]) {
                        
                        cell.viewOfColouring.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];
                        cell.imageOfPastOrUpComping.image = UIImageWithName(@"cs") ;

                        [cell.imageOfColour setHidden:true];

                        
                    } else if ([event.isEventGoldOrYPO isEqualToString:@"Joint"]) {
                        [cell.imageOfColour setHidden:false];
                        cell.imageOfPastOrUpComping.image = UIImageWithName(@"cs") ;

                        cell.viewOfColouring.backgroundColor = [UIColor clearColor];


                    }
                } else {
                    cell.viewOfColouring.backgroundColor = [UIColor colorWithRed:243/255.0 green: 185/255.0 blue:51/255.0 alpha:1.0];
                }
                
                break;
            case NSOrderedDescending:
                
                if ([event.isEventGoldOrYPO isEqualToString:@"YPO"]){
                    cell.viewOfColouring.backgroundColor = [UIColor colorWithRed:251/255.0 green: 221/255.0 blue:161/255.0 alpha:1.0];
                    cell.imageOfPastOrUpComping.image = UIImageWithName(@"Past") ;
                    [cell.imageOfColour setHidden:true];
                    

                } else if ([event.isEventGoldOrYPO isEqualToString:@"Gold"])
                {
                    cell.viewOfColouring.backgroundColor = [UIColor colorWithRed:251/255.0 green: 221/255.0 blue:161/255.0 alpha:1.0];
                    cell.imageOfPastOrUpComping.image = UIImageWithName(@"Past") ;

                    [cell.imageOfColour setHidden:true];


                }
                else if ([event.isEventGoldOrYPO isEqualToString:@"Joint"]){
                    [cell.imageOfColour setHidden:false];
//                    cell.imageOfColour.image = UIImageWithName(@"lineColour") ;
                    cell.imageOfPastOrUpComping.image = UIImageWithName(@"Past") ;

                    cell.viewOfColouring.backgroundColor = [UIColor clearColor];
                }
                
                break;
            case NSOrderedSame:
               
                if ([event.isEventGoldOrYPO isEqualToString:@"YPO"]){
                    cell.viewOfColouring.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];
                    [cell.imageOfColour setHidden:true];
                    
                }else if ([event.isEventGoldOrYPO isEqualToString:@"Gold"]) {
                    
                    cell.viewOfColouring.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];

                    [cell.imageOfColour setHidden:true];
                    
                    
                } else if ([event.isEventGoldOrYPO isEqualToString:@"Joint"]) {
                    [cell.imageOfColour setHidden:false];
                    cell.viewOfColouring.backgroundColor = [UIColor clearColor];
                    
                    
                }
                
                break;
            default:
                NSLog(@"erorr dates %@, %@", mile, now);
                break;
        }
        
        
    } else {
        [cell.viewOfColouring setHidden:true];
        [cell.isPastOrFuture setHidden:true];


    }
  
    [cell.lblDesc setText:[NSString stringWithFormat:@"%@ - %@", event.eventStartTime,event.eventEndTime]];
    
    [cell.lblDate setText:[NSString stringWithFormat:@"%@ - %@", [self dateFromStringFormatter:event.eventStartDate], [self dateFromStringFormatter:event.eventEndDate]]];
    [cell.lblLocation setText:[NSString stringWithFormat:@"%@", event.eventVenueAddress]];
    NSURL *imageURL ;
    id  thumbnailImage = event.eventThumbImg ;

    if (thumbnailImage != [NSNull null]) {
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[event.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        imageURL = [NSURL URLWithString:imageURLString];

    }else {
        
    }
//    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,event.eventThumbImg]];
    
    [cell.imgThumnail setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
//    [cell.imgThumnail setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
}

-(NSString*) timeFromStringFormatter:(NSString*)timeString{
    if([Utility isEmptyOrNull:timeString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *yourDate = [dateFormatter dateFromString:timeString];
    dateFormatter.dateFormat = @"hh:mm a";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
