//
//  EventSpeakerSessionViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "AttendeeSpeakerSessionViewController.h"
#import "EventSpeakerSessionTableViewCell.h"
#import "EventSessionModel.h"
#import "DAAlertController.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "YPOChatViewController.h"

@interface AttendeeSpeakerSessionViewController ()
{
    IBOutlet UIButton *btnChat;
    __weak IBOutlet UIImageView *imageChat;

    IBOutlet UITextField *tfBoardTitle;
    
    IBOutlet UILabel *lblBoardDesign;
    IBOutlet UIView *viewOfDesig;
    
    IBOutlet NSLayoutConstraint *topConstraintOfCompany;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBAck;

@end

@implementation AttendeeSpeakerSessionViewController
@synthesize selectedSpeaker, ivProfilePic, tfName,tfEmail,tfCompany,tfIndustry,tfJobtitle,tfJobFunction , selectGoldMember;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self removeFromParentViewController];
    
    [self restoreData];
    [self disableFields];
    
    if (self.selectGoldMember){
        if ([self.selectGoldMember.boardDesig isEqual: [NSNull null]]) {
            [tfBoardTitle setHidden:true];
            [lblBoardDesign setHidden:true];
            [viewOfDesig setHidden:true];
            topConstraintOfCompany.constant = -40 ;
            
        }else {
            [tfBoardTitle setHidden:false];
            [lblBoardDesign setHidden:false];
            [viewOfDesig setHidden:false];
            topConstraintOfCompany.constant = 20 ;
            NSDictionary *dict = (NSDictionary *)self.selectGoldMember.boardDesig ;
            NSString *designation = [dict valueForKey:@"name"] ;
            tfBoardTitle.text = designation ;
            
        }

    } else {
        [tfBoardTitle setHidden:true];
        [lblBoardDesign setHidden:true];
        [viewOfDesig setHidden:true];
        topConstraintOfCompany.constant = -40 ;

    }
    
    
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    //    self.ivProfilePic.isUserInteractionEnabled = true ;
    [imageChat setUserInteractionEnabled:true];
    [imageChat addGestureRecognizer:singleFingerTap];


    
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    if (selectedSpeaker){
        vc.selectedSpeaker = selectedSpeaker ;
        vc.pushTypeGoldOrYpoMember = 4 ;
    } else {
        vc.selectGoldMember = self.selectGoldMember ;
        vc.pushTypeGoldOrYpoMember = 3 ;

    }
    
    
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

//    if (self.pushTypeGoldOrYpoMember == 1)
//     {
//     [self dismissViewControllerAnimated:true completion:^{
//
//     }];
//     }
//     else {
//     [self.navigationController popViewControllerAnimated:true];
//
//     }
//
//
   
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//        if (self.pushTypeGoldOrYpoMember == 1)
//        {
//            [_btnBAck setHidden:false];
//        }
//        else {
//            [_btnBAck setHidden:true];
//        }
    
}

-(void) disableFields{
    [tfName setEnabled:NO];
    [tfEmail setEnabled:NO];
    [tfCompany setEnabled:NO];
    [tfIndustry setEnabled:NO];
    [tfJobtitle setEnabled:NO];
    [tfJobFunction setEnabled:NO];
}

-(void)restoreData{
    
    if (self.pushTypeGoldOrYpoMember == 1)
    {
        NSString *tempString = [NSString stringWithFormat:@"%@ %@", selectGoldMember.firstName , selectGoldMember.lastName];
        
        if([[tempString lowercaseString] containsString:@"(null)"]){
            tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        }
        
        if([[tempString lowercaseString] containsString:@"<null>"]){
            tempString = [tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        }
        
        [tfName setText:tempString];
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.email]]){
            [tfEmail setText:[NSString stringWithFormat:@"%@", selectGoldMember.email]];
        }
        else{
            [tfEmail setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.jobtitle]]){
            [tfJobtitle setText:[NSString stringWithFormat:@"%@", selectGoldMember.jobtitle]];
        }
        else{
            [tfJobtitle setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.company]]){
            [tfCompany setText:[NSString stringWithFormat:@"%@", selectGoldMember.company]];
        }
        else{
            [tfCompany setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.industryName]]){
            [tfIndustry setText:[NSString stringWithFormat:@"%@", selectGoldMember.industryName]];
        }
        else{
            [tfIndustry setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.funcName]]){
            [tfJobFunction setText:[NSString stringWithFormat:@"%@", selectGoldMember.funcName]];
        }
        else{
            [tfJobFunction setText:@""];
        }
        //    //[tfName setText:[NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName]];
        //    [tfJobtitle setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerJobTitle]];
        //    [tfEmail setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerEmailAddress]];
        //    [tfCompany setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCompany]];
        //    [tfIndustry setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerIndustry]];
        //    [tfJobFunction setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFunction]];
        //
        [tfName setAllowsEditingTextAttributes:NO];
        
        if(![Utility isEmptyOrNull:selectGoldMember.dpPathThumb]){
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[selectGoldMember.dpPathThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            
            //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL, selectedSpeaker.speakerThumbImg]];
            [ivProfilePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
            ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
            ivProfilePic.layer.masksToBounds = YES;
//            cell.imageOfUser.layer.masksToBounds = false
//            cell.imageOfUser.layer.borderWidth = 1.0
//            cell.imageOfUser.layer.borderColor = UIColor.white.cgColor;
//            cell.imageOfUser.layer.cornerRadius = cell.imageOfUser.frame.size.width / 2;
//            cell.imageOfUser.clipsToBounds = true;

            
        }
        else{
            [ivProfilePic setImage:[UIImage imageNamed:@"ph_user_medium"]];
            
            [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
            ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
            ivProfilePic.layer.masksToBounds = YES;
        }

    } else if (_pushTypeGoldOrYpoMember == 2){
        NSString *tempString = [NSString stringWithFormat:@"%@ %@", selectGoldMember.firstName , selectGoldMember.lastName];
        
        if([[tempString lowercaseString] containsString:@"(null)"]){
            tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        }
        
        if([[tempString lowercaseString] containsString:@"<null>"]){
            tempString = [tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        }
        
        [tfName setText:tempString];
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.email]]){
            [tfEmail setText:[NSString stringWithFormat:@"%@", selectGoldMember.email]];
        }
        else{
            [tfEmail setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.jobtitle]]){
            [tfJobtitle setText:[NSString stringWithFormat:@"%@", selectGoldMember.jobtitle]];
        }
        else{
            [tfJobtitle setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.company]]){
            [tfCompany setText:[NSString stringWithFormat:@"%@", selectGoldMember.company]];
        }
        else{
            [tfCompany setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.industryName]]){
            [tfIndustry setText:[NSString stringWithFormat:@"%@", selectGoldMember.industryName]];
        }
        else{
            [tfIndustry setText:@""];
        }
        
        if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectGoldMember.funcName]]){
            [tfJobFunction setText:[NSString stringWithFormat:@"%@", selectGoldMember.funcName]];
        }
        else{
            [tfJobFunction setText:@""];
        }
        //    //[tfName setText:[NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName]];
        //    [tfJobtitle setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerJobTitle]];
        //    [tfEmail setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerEmailAddress]];
        //    [tfCompany setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCompany]];
        //    [tfIndustry setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerIndustry]];
        //    [tfJobFunction setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFunction]];
        //
        [tfName setAllowsEditingTextAttributes:NO];
        
        if(![Utility isEmptyOrNull:selectGoldMember.dpPathThumb]){
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[selectGoldMember.dpPathThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            
            //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL, selectedSpeaker.speakerThumbImg]];
            [ivProfilePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
            ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
            ivProfilePic.layer.masksToBounds = YES;
            //            cell.imageOfUser.layer.masksToBounds = false
            //            cell.imageOfUser.layer.borderWidth = 1.0
            //            cell.imageOfUser.layer.borderColor = UIColor.white.cgColor;
            //            cell.imageOfUser.layer.cornerRadius = cell.imageOfUser.frame.size.width / 2;
            //            cell.imageOfUser.clipsToBounds = true;
            
            
        }
        else{
            [ivProfilePic setImage:[UIImage imageNamed:@"ph_user_medium"]];
            
            [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
            ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
            ivProfilePic.layer.masksToBounds = YES;
        }
    }
    else
    {
    
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName];
    
    if([[tempString lowercaseString] containsString:@"(null)"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    
    if([[tempString lowercaseString] containsString:@"<null>"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    }
    
    [tfName setText:tempString];
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerEmailAddress]]){
        [tfEmail setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerEmailAddress]];
    }
    else{
        [tfEmail setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerJobTitle]]){
        [tfJobtitle setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerJobTitle]];
    }
    else{
        [tfJobtitle setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCompany]]){
        [tfCompany setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCompany]];
    }
    else{
        [tfCompany setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerIndustry]]){
        [tfIndustry setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerIndustry]];
    }
    else{
        [tfIndustry setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFunction]]){
        [tfJobFunction setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFunction]];
    }
    else{
        [tfJobFunction setText:@""];
    }
//    //[tfName setText:[NSString stringWithFormat:@"%@ %@", selectedSpeaker.speakerFirstName, selectedSpeaker.speakerLastName]];
//    [tfJobtitle setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerJobTitle]];
//    [tfEmail setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerEmailAddress]];
//    [tfCompany setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerCompany]];
//    [tfIndustry setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerIndustry]];
//    [tfJobFunction setText:[NSString stringWithFormat:@"%@", selectedSpeaker.speakerFunction]];
//    
    [tfName setAllowsEditingTextAttributes:NO];
    
    if(![Utility isEmptyOrNull:selectedSpeaker.speakerThumbImg]){
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[selectedSpeaker.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL, selectedSpeaker.speakerThumbImg]];
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
