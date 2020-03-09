//
//  EventSpeakerSessionViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSpeakerSessionViewController.h"
#import "EventSpeakerSessionTableViewCell.h"
#import "EventSessionModel.h"
#import "DAAlertController.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "THLabel.h"
#import "YPOChatViewController.h"
#define kGradientStartColor	[UIColor colorWithRed:142.0 / 255.0 green:214.0 / 255.0 blue:39.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:13.0 / 255.0 green:222.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]

@interface EventSpeakerSessionViewController ()
{
    IBOutlet UIButton *btnChat;
    __weak IBOutlet UIImageView *imageChat;


}
@end

@implementation EventSpeakerSessionViewController
@synthesize selectedSpeaker, tvSessions,ivProfilePic,lblTitle,lblSubheading1,lblSubHeading2,tvBiography,lblBottomName,lblBottomEmail,lblBottomCompany,lblBottomIndustry,lblBottomJobtitle,lblBottomJobFunction;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [lblBottomName setEnabled:NO];
    [lblBottomEmail setEnabled:NO];
    [lblBottomCompany setEnabled:NO];
    [lblBottomIndustry setEnabled:NO];
    [lblBottomJobtitle setEnabled:NO];
    [lblBottomJobFunction setEnabled:NO];
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    //    self.ivProfilePic.isUserInteractionEnabled = true ;
    [imageChat setUserInteractionEnabled:true];
    [imageChat addGestureRecognizer:singleFingerTap];
    
    [self restoreData];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    //    [vc.navigationController setHidesBarsOnTap:false];
    vc.pushTypeGoldOrYpoMember = 4 ;
    
    vc.selectedSpeaker = self.selectedSpeaker ;
    
//    selectedSpeaker
    [self.navigationController pushViewController:vc animated:true];
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
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
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
-(void)restoreData{
    
    tvSessions.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvSessions.rowHeight = UITableViewAutomaticDimension;
    tvSessions.estimatedRowHeight = 44.0;
    
//    [lblTitle setText:[NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName]];
   // NSString *tempString = [NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName];
   // [lblTitle setText:[tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""]];
    
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName];
    
    if([[tempString lowercaseString] containsString:@"(null)"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    
    if([[tempString lowercaseString] containsString:@"<null>"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    }
    
    [lblTitle setText:tempString];
    
    [lblSubheading1 setText:[NSString stringWithFormat:@"%@, %@", selectedSpeaker.speakerJobTitle, selectedSpeaker.speakerCompany]];
    [lblSubHeading2 setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCountry]];
    
    //NSString *tempString2 = [NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName];
    //[lblBottomName setText:[tempString2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""]];
    
    [lblBottomName setText:tempString];
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerEmailAddress]]){
        [lblBottomEmail setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerEmailAddress]];
    }
    else{
        [lblBottomEmail setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerJobTitle]]){
        [lblBottomJobtitle setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerJobTitle]];
    }
    else{
        [lblBottomJobtitle setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCompany]]){
        [lblBottomCompany setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCompany]];
    }
    else{
        [lblBottomCompany setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerIndustry]]){
        [lblBottomIndustry setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerIndustry]];
    }
    else{
        [lblBottomIndustry setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFunction]]){
        [lblBottomJobFunction setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFunction]];
    }
    else{
        [lblBottomJobFunction setText:@""];
    }
    
    if(![Utility isEmptyOrNull:selectedSpeaker.speakerBio]){
        [tvBiography setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerBio]];
    }
    else{
        [tvBiography setText:[NSString stringWithFormat:@"No data available."]];
    }
    
    
    [tvSessions reloadData];
    
   // NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[selectedSpeaker.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    //NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
//    //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL, selectedSpeaker.speakerThumbImg]];
//    [ivProfilePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
//    [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
//    ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
//    ivProfilePic.layer.masksToBounds = YES;
    
    if(![Utility isEmptyOrNull:selectedSpeaker.speakerThumbImg]){
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[selectedSpeaker.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [ivProfilePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
        ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
        ivProfilePic.layer.masksToBounds = YES;

    }
    else{
        [ivProfilePic setImage:[UIImage imageNamed:@"ph_user_medium"]];
        [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
        ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
        ivProfilePic.layer.masksToBounds = YES;
    }
}

- (IBAction)btnAgenda_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

- (IBAction)angelListButtonPressed:(id)sender {
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerWebsite]]){
        if([[selectedSpeaker.speakerWebsite lowercaseString] containsString:@"http://"] || [[selectedSpeaker.speakerWebsite lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedSpeaker.speakerWebsite]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", selectedSpeaker.speakerWebsite]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
}

- (IBAction)fbButtonPressed:(id)sender {
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFBURL]]){
        if([[selectedSpeaker.speakerFBURL lowercaseString] containsString:@"http://"] || [[selectedSpeaker.speakerFBURL lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedSpeaker.speakerFBURL]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", selectedSpeaker.speakerFBURL]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
}

- (IBAction)linkedinButtonPressed:(id)sender {
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerLinkedinURL]]){
        if([[selectedSpeaker.speakerLinkedinURL lowercaseString] containsString:@"http://"] || [[selectedSpeaker.speakerLinkedinURL lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedSpeaker.speakerLinkedinURL]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", selectedSpeaker.speakerLinkedinURL]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
}

- (IBAction)twitterButtonPressed:(id)sender {
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerTwitterURL]]){
        if([[selectedSpeaker.speakerTwitterURL lowercaseString] containsString:@"http://"] || [[selectedSpeaker.speakerTwitterURL lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:selectedSpeaker.speakerTwitterURL]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", selectedSpeaker.speakerTwitterURL]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if (selectedSpeaker.speakerSessionList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvSessions.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvSessions.bounds.size.width, tvSessions.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvSessions.backgroundView = noDataLabel;
        tvSessions.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return selectedSpeaker.speakerSessionList.count;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"sessionCell";
    
    EventSpeakerSessionTableViewCell *cell = (EventSpeakerSessionTableViewCell *)[tvSessions dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EventSpeakerSessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if(indexPath.row==0){
        [cell.contraintLineTop setConstant:30.0];
    }
    else if(indexPath.row>0){
        [cell.contraintLineTop setConstant:0.0];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setAutoresizesSubviews:YES];
    
    EventSessionModel *session = [selectedSpeaker.speakerSessionList objectAtIndex:indexPath.row];
    
    [cell.lblDesc setText:[NSString stringWithFormat:@"Title: %@", session.eventTitle]];
    [cell.lblDesc2 setText:[NSString stringWithFormat:@"Track: %@", session.eventTrackName]];
    [cell.lblTitle setText:[NSString stringWithFormat:@"%@ - %@", session.eventTimeFrom, session.eventTimeTo]];
//    cell.lblTitle.gradientStartColor = kGradientStartColor;
//    cell.lblTitle.gradientEndColor = kGradientEndColor;
//    cell.lblTitle.gradientStartPoint = CGPointMake(0, 0);
//    cell.lblTitle.gradientEndPoint = CGPointMake(300, 0);
    return cell;
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
