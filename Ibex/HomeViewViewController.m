//
//  HomeViewViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 22/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "HomeViewViewController.h"
#import "UIViewController+LGSideMenuController.h"
#import "SideMenuViewController.h"
#import "AgendaViewController.h"
#import "EventSpeakersViewController.h"
#import "AttendeesViewController.h"
#import "SponsorsViewController.h"
#import "FAQsViewController.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "DBChatManager.h"
@interface HomeViewViewController ()

@end

@implementation HomeViewViewController
@synthesize listButton,contraint_bottom_spacer, notifButton,lblLocation,headingText,ivHomeBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addListButton];
    [self restoreAddressDate];
   // [self addNotificationButton];
}

-(void) restoreAddressDate{
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    EventObject *obj = (EventObject*) appDelegate.eventObj;
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    [ivHomeBackground setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
    [ivHomeBackground setContentMode:UIViewContentModeScaleAspectFill];
    
    [lblLocation setText:[NSString stringWithFormat:@"%@,\n%@ %@ - %@ %@",obj.eventVenueAddress,obj.eventStartTime, [self dateFromStringFormatter:obj.eventStartDate], obj.eventEndTime,[self dateFromStringFormatter:obj.eventEndDate]]];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    EventObject *obj = (EventObject*) appDelegate.eventObj;
    
    [self.navigationItem setTitle:obj.eventName];
    [self setupButtonView];

    
}

-(void) setupButtonView{
    if([Utility iPhone6PlusDevice]){
        [contraint_bottom_spacer setConstant:28.0];
    }
    else{
        [contraint_bottom_spacer setConstant:0.0];
    }
}

-(void) addListButton{
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 25, 27);
    
    [listButton addTarget:self action:@selector(openLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backbutton"];
    [listButton setImage:backButtonImage forState:UIControlStateNormal];
    UIImage *backButtonHigh = [UIImage imageNamed:@"backbutton"];
    [listButton setImage:backButtonHigh forState:UIControlStateHighlighted];
    
    listButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}


-(void) addNotificationButton{
    notifButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notifButton.frame = CGRectMake(0, 0, 25, 27);
    
//    [listButton addTarget:self action:@selector(openLeftList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"icon_notification"];
    [notifButton setImage:backButtonImage forState:UIControlStateNormal];
    UIImage *backButtonHigh = [UIImage imageNamed:@"icon_notification"];
    [notifButton setImage:backButtonHigh forState:UIControlStateHighlighted];
    
    notifButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:notifButton];
    self.navigationItem.rightBarButtonItem = backBarButtonItem;
}



- (IBAction)messagesButtonPressed:(id)sender {
    //[Utility initComitChatMainScreen:[Utility topViewController]];
    NSString *stringURL = @"https://ibexleadership.slack.com";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)eventSpeakersButtonPressed:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EventSpeakersViewController *esVC = [storyboard instantiateViewControllerWithIdentifier:@"esVC"];
    //attendiesVC.baseNavigationController = self.navigationController;
    [self.navigationController pushViewController:esVC animated:YES];
}

- (IBAction)agendaButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AgendaViewController *agendaVC = [storyboard instantiateViewControllerWithIdentifier:@"agendaVC"];
    //attendiesVC.baseNavigationController = self.navigationController;
    [self.navigationController pushViewController:agendaVC animated:YES];
}

- (IBAction)faqButtonPressed:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FAQsViewController *faqVC = [storyboard instantiateViewControllerWithIdentifier:@"faqVC"];
    //attendiesVC.baseNavigationController = self.navigationController;
    [self.navigationController pushViewController:faqVC animated:YES];
}

- (IBAction)sponsorsButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SponsorsViewController *sponsorVC = [storyboard instantiateViewControllerWithIdentifier:@"sponsorVC"];
    //attendiesVC.baseNavigationController = self.navigationController;
    [self.navigationController pushViewController:sponsorVC animated:YES];
}

- (IBAction)attendeesButtonPressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AttendeesViewController *attendiesVC = [storyboard instantiateViewControllerWithIdentifier:@"attendeesVC"];
    //attendiesVC.baseNavigationController = self.navigationController;
    [self.navigationController pushViewController:attendiesVC animated:YES];
}

-(void)openLeftList{
    
    [self.navigationController popViewControllerAnimated:true];

//    [[self sideMenuController] showLeftViewAnimated:true completionHandler:nil];
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
