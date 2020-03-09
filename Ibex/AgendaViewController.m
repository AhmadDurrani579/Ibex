//
//  AgendaViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 29/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "AgendaViewController.h"
#import "Utility.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "AgendaResponse.h"
#import "AgendaTableViewCell.h"
#import "AgendaSessionModel.h"	
#import "EventSpeakerModel.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "UIViewController+MJPopupViewController.h"
#import "SpeakerListViewController.h"
#import "AppDelegate.h"
#import "AgendaTableViewCell.h"
#define kGradientStartColor	[UIColor colorWithRed:142.0 / 255.0 green:214.0 / 255.0 blue:39.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:13.0 / 255.0 green:222.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]

@interface AgendaViewController (){
    AgendaResponse *masterObj;
    IBOutlet UIButton *btnChat;

}

@end

@implementation AgendaViewController
@synthesize topAlignmentConstraint,tvAgenda;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tvSessions.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvAgenda.rowHeight = UITableViewAutomaticDimension;
    tvAgenda.estimatedRowHeight = 44.0;
    // Do any additional setup after loading the view.
    [self setupButtonView];
    [self fetchAgenda];
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];

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


-(void) fetchAgenda{
    
    NSString *eventID ;
    if (self.schedule) {
       eventID = [NSString stringWithFormat:@"%@", self.schedule.idOfEvent];

    }else {
        eventID = [NSString stringWithFormat:@"%@", self.eventObj.eventEventID];

    }
    

    
    [[Webclient sharedWeatherHTTPClient] getAgenda:eventID viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        
        masterObj = (AgendaResponse*) responseObject;
        
        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
            [tvAgenda reloadData];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Agenda Activity"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

#pragma mark -Mark top Right  Method-

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

- (IBAction)btnAgenda_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if (masterObj.agendaList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvAgenda.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvAgenda.bounds.size.width, tvAgenda.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvAgenda.backgroundView = noDataLabel;
        tvAgenda.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return masterObj.agendaList.count;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"agendaCell";
    
    AgendaTableViewCell *cell = (AgendaTableViewCell *)[tvAgenda dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AgendaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    NSInteger someInteger = indexPath.row + 1 ;
    NSString *someString = [NSString stringWithFormat:@"Session %ld  ", (long)someInteger];
    cell.lblSessionNumber.text = someString;
    
//    [cell.lblSessionNumber setText:@"Session%d",indexNumber];
    
    
    
    if(indexPath.row==0){
        [cell.constraintTopLine setConstant:30.0];
    }
    else if(indexPath.row>0){
        [cell.constraintTopLine setConstant:0.0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAutoresizesSubviews:YES];
    
    AgendaSessionModel *session = [masterObj.agendaList objectAtIndex:indexPath.row];
    
//    cell.lblTrackEvent.text = session.agendaEventTrack ;
    [cell.lblTrackEvent setText:[NSString stringWithFormat:@"Track:%@", session.agendaEventTrack]];
    

    [cell.lblDesc2 setText:[NSString stringWithFormat:@"Track: %@", session.agendaEventTrack]];
    [cell.lblDesc setText:[NSString stringWithFormat:@"Date: %@\nTitle: %@", [self dateFromStringFormatter:session.agendaDate],session.agendaTitle]];
    
    [cell.lblTitle setText:[NSString stringWithFormat:@"%@ - %@", session.agendaTimeFrom, session.agendaTimeTo]];
//    cell.lblTitle.gradientStartColor = kGradientStartColor;
//    cell.lblTitle.gradientEndColor = kGradientEndColor;
//    cell.lblTitle.gradientStartPoint = CGPointMake(0, 0);
//    cell.lblTitle.gradientEndPoint = CGPointMake(300, 0);
    
    if(session.agendaEventSpeakerList.count >0){
        //[cell.speakerView setFrame:CGRectMake(cell.speakerView.frame.origin.x, cell.speakerView.frame.origin.y, cell.speakerView.frame.size.width, 37.0)];
        [cell.viewSpeakersIcons setHidden:NO];
        
        //[cell.descBottomtoSpeakerConstraint setPriority:999];
        //[cell.descBottomViewConstriant setPriority:240];
        
        
        int spacing = 5;
        int x= 0;
        //session.agendaEventSpeakerList.count
        for(int i=0; i<session.agendaEventSpeakerList.count; i++){
            EventSpeakerModel *userObj = [session.agendaEventSpeakerList objectAtIndex:i];
            
            CGRect dummyFrame;
            
            UIImageView *ivUser = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, cell.svSpeakers.frame.size.height, cell.svSpeakers.frame.size.height)];

            if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", userObj.speakerThumbImg]]){
                NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[userObj.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                NSURL *imageURL = [NSURL URLWithString:imageURLString];
                [ivUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
                [ivUser setContentMode:UIViewContentModeScaleAspectFill];
                ivUser.layer.cornerRadius = ivUser.frame.size.height/2;
                ivUser.layer.masksToBounds = YES;
                
                
                
                NSLog(@"PicURL: %@", imageURLString);
            }
            else{
                [ivUser setImage:[UIImage imageNamed:@"ph_user_medium"]];
                
                [ivUser setContentMode:UIViewContentModeScaleAspectFill];
                ivUser.layer.cornerRadius = ivUser.frame.size.height/2;
                ivUser.layer.masksToBounds = YES;
            }
            [cell.svSpeakers addSubview:ivUser];
            
            x= ivUser.frame.size.width + x + spacing;
            
        }
        [cell.svSpeakers setContentSize:CGSizeMake((10*(cell.svSpeakers.frame.size.height+5))-5, cell.svSpeakers.frame.size.height)];
        
    }
    else{
     
        [cell.viewSpeakersIcons setHidden:YES];
//        [cell.descBottomViewConstriant setPriority:999];
//        [cell.descBottomtoSpeakerConstraint setPriority:240];
        
    }
    
    UIButton *btnOver = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.svSpeakers.frame.size.width, cell.svSpeakers.frame.size.height)];
    [btnOver addTarget:self action:@selector(showPopup:) forControlEvents:UIControlEventTouchUpInside];
    [cell.svSpeakers addSubview:btnOver];
    
    return cell;
}

-(NSString*) dateFromStringFormatter:(NSString*)dateString{
    if([Utility isEmptyOrNull:dateString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"EEEE MMM dd, yyyy";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}

- (void) showPopup:(id)sender
{
    AgendaTableViewCell *cell = (AgendaTableViewCell*) [[[[sender superview] superview] superview] superview];
    NSIndexPath *indexP = [tvAgenda indexPathForCell:cell];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    AgendaSessionModel *session = [masterObj.agendaList objectAtIndex:indexP.row];

    SpeakerListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"speakerlistVC"];
    vc.sessionObj = session;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(NSString*) timeFromStringFormatter:(NSString*)timeString{
    if([Utility isEmptyOrNull:timeString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *yourDate = [dateFormatter dateFromString:timeString];
    dateFormatter.dateFormat = @"hh:mm aa";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}



-(void) setupButtonView{
    if([Utility iPhone6PlusDevice]){
        [topAlignmentConstraint setConstant:160.0];
    }
    else{
        [topAlignmentConstraint setConstant:138.0];
    }
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
