//
//  YPONotificationVC.m
//  Ibex
//
//  Created by Ahmed Durrani on 23/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPONotificationVC.h"
#import "NotifiyCell.h"
#import "Notification+CoreDataClass.h"
#import "CardViewForChat.h"
#import "NSDate+NVTimeAgo.h"
#import "NYAlertViewController.h"
#import "Webclient.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "DAAlertController.h"
#import "Constant.h"
#import "MONotificationResponse.h"
#import "MONotificationObject.h"
#import "NotifyCells.h"
#import <SVHTTPRequest/SVHTTPRequest.h>
#import <SVProgressHUD/SVProgressHUD.h>
@interface YPONotificationVC () <UITableViewDelegate , UITableViewDataSource , SWTableViewCellDelegate>
{
    __weak IBOutlet UITableView *tblView;
    UIRefreshControl *refreshControl;

    IBOutlet UIButton *btnNotificationSwitch;
    MONotificationResponse *tempmasterObj;

}
@property (strong, nonatomic) IBOutlet CardViewForChat *viewOfNotify;

@property (nonatomic , strong)NSMutableArray *arrayOfNotification ;

@end

@implementation YPONotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblView.estimatedRowHeight = 70.0 ;
    BOOL _boolValue = [[[NSUserDefaults standardUserDefaults] valueForKey:@"switch"] boolValue]; // will be FALSE if the value is `nil` for the key
    if (_boolValue == true){
//        btnNotificationSwitch.isSelected = true ;
        [btnNotificationSwitch setSelected:true];
    } else {
//        btnNotificationSwitch.isSelected = false ;
        [btnNotificationSwitch setSelected:false];

    }
    tblView.rowHeight = UITableViewAutomaticDimension;
    refreshControl = [[UIRefreshControl alloc]init];
    [tblView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
}
- (IBAction)btnNotifictionOffAndOn_Pressed:(UIButton *)sender {
    
    [_viewOfNotify setHidden:false];
    
}

-(void)switchTheNotification:(BOOL)isTurnOnOrOff {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];

    NSDictionary *params = nil;
    if (isTurnOnOrOff == YES) {
        params =        @{@"UserId"              :     obj.loginUserID,
                          @"isOn"                :     @"true"
                          };
    } else {
        params =        @{@"UserId"              :     obj.loginUserID,
                          @"isOn"                :     @"false"
                          };
    }
    
    [SVProgressHUD show];
    
    [[SVHTTPClient sharedClient] POST:WEBSERVICE_NotificationSwitch  parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];
        if (!response) {

        }
        else {
            
//            [self showAlertViewWithTitle:@"" message:apiResponse.error.message
//                   withDismissCompletion:^{
//                   }];
        }
        
    }];
//    [SVProgressHUD dismiss];

    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Notification Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self getAllNotification];

}

-(void)getAllNotification {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];

    NSString *serviceUrl =  [NSString stringWithFormat:WEBSERVICE_GETALLNotification@"/%@/mobile/1/10000", obj.loginUserID];
    
    [[Webclient sharedWeatherHTTPClient] getAllNotification:serviceUrl viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (MONotificationResponse *) responseObject;
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


- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
//    _arrayOfNotification = [Notification fetchAll].mutableCopy ;
    [self getAllNotification];
    
//    [tblView reloadData];

}

- (IBAction)btnToggle_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected == true){
        
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        
        alertViewController.title = @"YPO";
        alertViewController.message = @"Are you sure do you want to turn on the notifications sound ?";
        
        alertViewController.buttonCornerRadius = 20.0f;
        alertViewController.view.tintColor = self.view.tintColor;
        
        alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
        alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
        alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
        alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
        
        alertViewController.alertViewBackgroundColor = [UIColor colorWithRed:15/255.0  green:45/255.0 blue:65/255.0 alpha:1.0];
        alertViewController.alertViewCornerRadius = 10.0f;
        
        alertViewController.titleColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
        alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
        
        alertViewController.buttonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
        
        alertViewController.cancelButtonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"ON"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
//                                                                  [self deleteAllNotify] ;
                                                                    [self switchTheNotification:true] ;
                                                                  [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"switch"];
                                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                              }]];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
//                                                                  sender.isSelected = false
                                                                  [sender setSelected:false];
                                                              }]];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
        
      

      
        
    } else {
        
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        
        alertViewController.title = @"YPO";
        alertViewController.message = @"Are you sure do you want to turn off the notifications sound ?";
        
        alertViewController.buttonCornerRadius = 20.0f;
        alertViewController.view.tintColor = self.view.tintColor;
        
        alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
        alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
        alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
        alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
        
        alertViewController.alertViewBackgroundColor = [UIColor colorWithRed:15/255.0  green:45/255.0 blue:65/255.0 alpha:1.0];
        alertViewController.alertViewCornerRadius = 10.0f;
        
        alertViewController.titleColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
        alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
        
        alertViewController.buttonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
        
        alertViewController.cancelButtonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"OFF"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                                  //                                                                  [self deleteAllNotify] ;
                                                                  [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"switch"];
                                                                  [[NSUserDefaults standardUserDefaults] synchronize];

                                                                  [self switchTheNotification:false] ;
                                                              }]];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(NYAlertAction *action) {
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                                  [sender setSelected:true];

                                                              }]];
        
        [self presentViewController:alertViewController animated:YES completion:nil];

    }
   
    
    
}
- (IBAction)btnCross_Pressed:(UIButton *)sender {
    
    [_viewOfNotify setHidden:true];
    
}
- (IBAction)btnSettingBtn_Pressed:(UIButton *)sender {
    
    if (tempmasterObj.notificationList.count > 0){
        [self deleteAllNotification];

    }
}

#pragma mark - Custom Alert for Logout -
-(void)deleteAllNotification
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = @"YPO";
    alertViewController.message = @"Are you sure do you want to Delete the notifications?";
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithRed:15/255.0  green:45/255.0 blue:65/255.0 alpha:1.0];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              [self deleteAllNotify] ;
                                                              }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}


-(void)deleteAllNotify {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse*) [defaults rm_customObjectForKey:@"UserData"];
    
    
    [[Webclient sharedWeatherHTTPClient] deleteAllNotification:obj.loginUserID viewController:self CompletionBlock:^(NSObject *responseObject) {
//                DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                        style:DAAlertActionStyleCancel
//                                                                      handler:^{
//
//                                                                      }];
        [self showAlertViewWithTitle:@"YPO" message:@"Delete Notifications Successfully" withDismissCompletion:^{
            [self getAllNotification];
            
        }] ;
//                [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"Un Register Successfully ." actions:@[dismissAction]];

    } FailureBlock:^(NSError *error) {
        
    }];
    
//    [[Webclient sharedWeatherHTTPClient] blockRequest:obj.loginUserID eventID:eventObj.eventEventID viewController:self CompletionBlock:^(NSObject *responseObject) {
//        NSLog(@"print it %@", responseObject);
//        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                style:DAAlertActionStyleCancel
//                                                              handler:^{
//                                                                  [self.navigationController popViewControllerAnimated:YES];
//                                                              }];
//
//        [DAAlertController showAlertViewInViewController:self withTitle:@"Success!" message:@"Un Register Successfully ." actions:@[dismissAction]];
//
//
//    } FailureBlock:^(NSError *error) {
//
//    }] ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
    
}

#pragma mark -UITableView Method-


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numOfSections = 0;
    if (tempmasterObj.notificationList.count >0)
    {
        numOfSections                = 1;
        tblView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tblView.bounds.size.width, tblView.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font             = [UIFont fontWithName:@"Axiforma-Book" size:14];
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
    return  tempmasterObj.notificationList.count ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NotifyCells *cell = (NotifyCells *)[tableView dequeueReusableCellWithIdentifier:@"NotifyCells"];
    
    if (tempmasterObj.notificationList.count > 0){
        MONotificationObject *objNotify = (MONotificationObject *)[tempmasterObj.notificationList objectAtIndex:indexPath.row];
        [cell setNotify:objNotify];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//        [rightUtilityButtons sw_addUtilityButtonWithColor:
//        [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                    title:@"Delete"];
//        cell.rightUtilityButtons = rightUtilityButtons;
    }
    cell.delegate = self;

    
    return cell ;
    
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NotifyCells *cel = (NotifyCells *)cell;
    MONotificationResponse *profileObj = (MONotificationResponse *)cel.notify;

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"Alert", @"")
                                  message:NSLocalizedString(@"Are you sure you want to delete this Notification?", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"") style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
//                             NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
                                                   
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
//
                                                   
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"") style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //add code here for when you hit delete
    }
}


@end
