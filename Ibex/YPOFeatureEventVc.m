//
//  YPOFeatureEventVc.m
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOFeatureEventVc.h"
#import "EventListResponse.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "EventObject.h"
#import "YPOFeatureCell.h"
#import "Utility.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "DAAlertController.h"
#import "IsJoinedResponsed.h"
#import "MainViewController.h"
#import "loginResponse.h"
#import "AppDelegate.h"
#import "EventDetailViewController.h"
@interface YPOFeatureEventVc () <UITableViewDelegate , UITableViewDataSource>
{
    EventListResponse *tempmasterObj;
    __weak IBOutlet UITableView *tblView;
    IsJoinedResponsed *joinResponse;

}
@end

@implementation YPOFeatureEventVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
  

    [self fetchEventList];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

-(void) fetchEventList{
    
    NSString *serviceType = [[NSString alloc] init];
    serviceType = @"api/event/getFeaturedByPage/1/10000";
    
    [[Webclient sharedWeatherHTTPClient] getEventList:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (EventListResponse*) responseObject;

        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            
            tblView.delegate = self ;
            tblView.dataSource = self ;
            tblView.estimatedRowHeight = 50.0 ;
            tblView.rowHeight = UITableViewAutomaticDimension ;
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Featured Events Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  tempmasterObj.eventList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOFeatureCell *cell = (YPOFeatureCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOFeatureCell"];
    EventObject *obj  =  (EventObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
    
    
    [cell.lblTitle setText:obj.eventName];
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [obj.eventStartDate stringByReplacingOccurrencesOfString:@"T"
                                                                  withString:@"  "];
    
    NSDate *date = [dateFormatter dateFromString:str];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    BOOL isFeature = [obj.isFeatured boolValue];
    
    if (isFeature){
        
        NSDate * now = [NSDate date];
        NSDate * mile = date;
        NSComparisonResult result = [now compare:mile];
        
        NSLog(@"%@", now);
        NSLog(@"%@", mile);
        switch (result)
        {
            case NSOrderedAscending:
               
                if ([mile compare:newDate] == NSOrderedAscending) {
                   
                   cell.viewOfColour.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];

//                    viewOfColour
                } else {
                    cell.viewOfColour.backgroundColor = [UIColor colorWithRed:243/255.0 green: 185/255.0 blue:51/255.0 alpha:1.0];
                }

                break;
            case NSOrderedDescending:
                
                cell.viewOfColour.backgroundColor = [UIColor colorWithRed:251/255.0 green: 221/255.0 blue:161/255.0 alpha:1.0];
                
                break;
            case NSOrderedSame:
                cell.viewOfColour.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];
                break;
            default:
                NSLog(@"erorr dates %@, %@", mile, now);
                break;
        }
        cell.imageOfFeatureEvent.image = UIImageWithName(@"featuredevent") ;
    }else {
        cell.imageOfFeatureEvent.image = UIImageWithName(@"") ;
        NSDate * now = [NSDate date];
        NSDate * mile = date;
        NSComparisonResult result = [now compare:mile];
        
        NSLog(@"%@", now);
        NSLog(@"%@", mile);
        switch (result)
        {
            case NSOrderedAscending:
                
                if ([mile compare:newDate] == NSOrderedAscending) {
                    
                    cell.viewOfColour.backgroundColor = [UIColor colorWithRed:68/255.0 green: 138/255.0 blue:255/255.0 alpha:1.0];
                    
                    //                    viewOfColour
                } else {
                    cell.viewOfColour.backgroundColor = [UIColor colorWithRed:0/255.0 green: 38/255.0 blue:61/255.0 alpha:1.0];
                }
                
                break;
            case NSOrderedDescending:
                
                cell.viewOfColour.backgroundColor = [UIColor colorWithRed:183/255.0 green: 183/255.0 blue:183/255.0 alpha:1.0];
                
                break;
            case NSOrderedSame:
                cell.viewOfColour.backgroundColor = [UIColor colorWithRed:68/255.0 green: 138/255.0 blue:255/255.0 alpha:1.0];
                break;
            default:
                NSLog(@"erorr dates %@, %@", mile, now);
                break;

        }
    }
    
    
    [cell.lblDesc setText:[NSString stringWithFormat:@"%@ - %@", obj.eventStartTime,obj.eventEndTime]];
    
    [cell.lblDate setText:[NSString stringWithFormat:@"%@ - %@", [self dateFromStringFormatter:obj.eventStartDate], [self dateFromStringFormatter:obj.eventEndDate]]];
    [cell.lblLocation setText:[NSString stringWithFormat:@"%@", obj.eventVenueAddress]];
    
    NSURL *imageURL ;
    id  thumbnailImage = obj.eventThumbImg ;
    
    if (thumbnailImage != [NSNull null]) {
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
      imageURL  = [NSURL URLWithString:imageURLString];

    }else {
        
    }

    
//    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
//    //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,event.eventThumbImg]];
    
    [cell.imgThumnail setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];

//    [cell setEventList:obj];
    
//    [cell setGoldMemberObj:obj] ;
    
    return cell ;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    EventDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"eventdetailVC"];
    //    YPOScheduleObject *obj  =  [tempmasterObj.eventList objectAtIndex:indexPath.row];
    //    vc.scheduleObj = obj ;
    //    vc.pushType = 1 ;
    //    vc.isJoinButton = false;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    EventObject *event = [tempmasterObj.eventList objectAtIndex:indexPath.row];
    
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
    
    NSLog(@"EventID: %@, UserID: %@", event.eventEventID, obj.loginUserID);
    
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

- (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}





@end
