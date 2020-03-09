//
//  SpeakerListViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SpeakerListViewController.h"
#import "EventSpeakerTableViewCell.h"
#import "EventSpeakerModel.h"
#import "Utility.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "EventSpeakerSessionViewController.h"

#define kGradientStartColor	[UIColor colorWithRed:142.0 / 255.0 green:214.0 / 255.0 blue:39.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:13.0 / 255.0 green:222.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]

@interface SpeakerListViewController ()
{
    IBOutlet UIButton *btnChat;

}
@end

@implementation SpeakerListViewController
@synthesize tvSpeakerList,sessionObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tvSpeakerList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tvSpeakerList reloadData];
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];

}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if (sessionObj.agendaEventSpeakerList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvSpeakerList.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvSpeakerList.bounds.size.width, tvSpeakerList.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvSpeakerList.backgroundView = noDataLabel;
        tvSpeakerList.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

-(NSMutableArray *)sortArrayBasedOndate:(NSMutableArray *)arraytoSort
{
    
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [fmtTime setDateFormat:@"hh:mma"];
    
    NSComparator compareTimes = ^(id string1, id string2)
    {
        string1 = [string1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        string2 = [string2 stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        NSArray *itemsOne = nil;
        
        if ([string1 containsString:@"to"]){
            itemsOne = [string1 componentsSeparatedByString:@"to"];
        }
        else {
            itemsOne = [string1 componentsSeparatedByString:@"-"];
        }
        
        NSArray *itemsTwo = nil;
        
        if ([string2 containsString:@"to"]) {
            itemsTwo = [string1 componentsSeparatedByString:@"to"];
        }
        else{
            itemsTwo = [string1 componentsSeparatedByString:@"-"];
        }
        
        if([[itemsOne objectAtIndex:0] isEqualToString:@"MIDNIGHTONWARDS"]){
            
        }
        
        NSLog(@"Compare: 1: %@, 2: %@", [itemsOne objectAtIndex:0], [itemsTwo objectAtIndex:0]);
        
        NSDate *time1 = [fmtTime dateFromString:[itemsOne objectAtIndex:0]];
        NSDate *time2 = [fmtTime dateFromString:[itemsTwo objectAtIndex:0]];
        
        return [time1 compare:time2];
    };
    
    //NSSortDescriptor * sortDesc1 = [[NSSortDescriptor alloc] initWithKey:@"start_date" ascending:YES comparator:compareDates];
    NSSortDescriptor * sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"pageTagline" ascending:YES comparator:compareTimes];
    [arraytoSort sortUsingDescriptors:@[sortDesc2]];
    
    return arraytoSort;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sessionObj.agendaEventSpeakerList.count;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventSpeakerModel *obj = [sessionObj.agendaEventSpeakerList objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventSpeakerSessionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"sessionVC"];
    
    vc.selectedSpeaker = obj;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"eventspeakerCell";
    
    EventSpeakerTableViewCell *cell = (EventSpeakerTableViewCell *)[tvSpeakerList dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EventSpeakerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    EventSpeakerModel *obj = [sessionObj.agendaEventSpeakerList objectAtIndex:indexPath.row];
    
//    [cell.lblTitle setText:[NSString stringWithFormat:@"%@ %@", obj.speakerFirstName, obj.speakerLastName]];
//    cell.lblTitle.gradientStartColor = kGradientStartColor;
//    cell.lblTitle.gradientEndColor = kGradientEndColor;
//    cell.lblTitle.gradientStartPoint = CGPointMake(0, 0);
//    cell.lblTitle.gradientEndPoint = CGPointMake(300, 0);
//    
//    [cell.subHeading1 setText:[NSString stringWithFormat:@"%@", obj.speakerJobTitle]];
//    [cell.subHeading2 setText:[NSString stringWithFormat:@"%@", obj.speakerFunction]];
//    [cell.subHeading3 setText:[NSString stringWithFormat:@"%@", obj.speakerIndustry]];
    
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", obj.speakerFirstName, obj.speakerLastName];
    [cell.lblTitle setText:[tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""]];
    
//    cell.lblTitle.gradientStartColor = kGradientStartColor;
//    cell.lblTitle.gradientEndColor = kGradientEndColor;
//    cell.lblTitle.gradientStartPoint = CGPointMake(0, 0);
//    cell.lblTitle.gradientEndPoint = CGPointMake(300, 0);
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", obj.speakerJobTitle]]){
        [cell.subHeading1 setText:[NSString stringWithFormat:@"%@", obj.speakerJobTitle]];
    }
    else{
        [cell.subHeading1 setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", obj.speakerCompany]]){
        [cell.subHeading2 setText:[NSString stringWithFormat:@"%@", obj.speakerCompany]];
    }
    else{
        [cell.subHeading2 setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", obj.speakerCountry]]){
        [cell.subHeading3 setText:[NSString stringWithFormat:@"%@", obj.speakerCountry]];
    }
    else{
        [cell.subHeading3 setText:@""];
    }

    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", obj.speakerThumbImg]]){
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [cell.ivUserPic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [cell.ivUserPic setContentMode:UIViewContentModeScaleAspectFill];
        cell.ivUserPic.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
        cell.ivUserPic.layer.masksToBounds = YES;
    }
    else{
        [cell.ivUserPic setImage:[UIImage imageNamed:@"ph_user_medium"]];
        [cell.ivUserPic setContentMode:UIViewContentModeScaleAspectFill];
        cell.ivUserPic.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
        cell.ivUserPic.layer.masksToBounds = YES;
    }
    
    
    return cell;
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
