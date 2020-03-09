//
//  YPOSearchEventListVc.m
//  YPO
//
//  Created by Ahmed Durrani on 24/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSearchEventListVc.h"
#import "YPOSearchEventCell.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "YPOSearchEventList.h"
#import "EventObject.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "YPOSearchUserCell.h"
#import "MOGoldMemberObject.h"
#import "YPOChatViewController.h"
#import "AttendeeSpeakerSessionViewController.h"
#import "AppDelegate.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "IsJoinedResponsed.h"
#import "EventDetailViewController.h"
@interface YPOSearchEventListVc ()<UITableViewDelegate , UITableViewDataSource , ChatBtn_PressedDelegate>
{
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UISearchBar     *searchContacts;
    YPOSearchEventList *tempmasterObj;
    BOOL isSearching;
    __weak IBOutlet UIView *viewOfEventMember;
    __weak IBOutlet UIView *viewOfUser ;
    __weak IBOutlet UIButton *btnOfEventMember;
    __weak IBOutlet UIButton *btnOfUser;
    BOOL isUserOrEvent ;
    IsJoinedResponsed *joinResponse;

    


}

@end

@implementation YPOSearchEventListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnOfEventMember setSelected:true];
    isUserOrEvent = false;
    
    // Do any additional setup after loading the view.
    searchContacts.placeholder = @"Search the Event" ;
    [viewOfUser setHidden:true];
    [viewOfEventMember setHidden:false];

//YPOSearchEventList
}

//WEBSERVICE_SEARCH


- (IBAction)btnEvent_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    searchContacts.placeholder = @"Search the Event" ;
    isUserOrEvent = false;

    
    [btnOfEventMember setSelected:true];
    [btnOfUser setSelected:false];
    [viewOfUser setHidden:true];
    [viewOfEventMember setHidden:false];
    [tblView reloadData] ;

}

- (IBAction)btnUserBtn_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    searchContacts.placeholder = @"Search the User" ;
    isUserOrEvent = true;

    //    vc.userList = tempmasterObj ;
    
    [btnOfUser setSelected:true];
    [btnOfEventMember setSelected:false];
    
    [viewOfEventMember setHidden:true];
    [viewOfUser setHidden:false];
    [tblView reloadData] ;
    
    
    
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
//    searchContacts.text=@"";
    [searchBar resignFirstResponder];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getALlSearchList:searchBar.text];
    
    [searchBar resignFirstResponder];

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
//    searchContacts.text=@"";
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Search Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}


-(void)getALlSearchList:(NSString *)searchText
{
    NSString *serviceType  = [NSString stringWithFormat:@"%@", searchText];
    [[Webclient sharedWeatherHTTPClient] getSearchEventAndList:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (YPOSearchEventList*) responseObject;
//        [self updateTableData:@""];
        
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            //[tvEvents reloadData];
            
           
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numOfSections = 0;
    if (isUserOrEvent == true) {
        if (tempmasterObj.searchUserList.count >0)
        {
            //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    else {
        if (tempmasterObj.eventList.count >0)
        {
            //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (isUserOrEvent == true ){
        return  tempmasterObj.searchUserList.count ;
        
    } else {
        return  tempmasterObj.eventList.count  ;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YPOSearchEventCell *cell = (YPOSearchEventCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOSearchEventCell" forIndexPath:indexPath];
//    YPOSearchUserCell *userCell = (YPOSearchUserCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOSearchUserCell" forIndexPath:indexPath];
    
    if (isUserOrEvent == true) {
        
        [cell.btnChat_Pressed setHidden:false];
        cell.delegate = self ;
        cell.index = indexPath ;
        if (tempmasterObj.searchUserList.count > 0){
            MOGoldMemberObject *obj = (MOGoldMemberObject *)[tempmasterObj.searchUserList objectAtIndex:indexPath.row];
            
            
            [cell.lblNameOfEvent setText:[NSString stringWithFormat:@"%@ %@", obj.firstName , obj.lastName]];
            cell.lblTimeOfEvent.text = obj.jobtitle ;
            
            //        [cell.lblTimeOfEvent setText:[NSString stringWithFormat:@"%@ - %@", obj.eventStartTime,obj.eventEndTime]];
            
            NSURL *imageURL ;
            id  thumbnailImage = obj.dpPathThumb ;
            
            if (thumbnailImage != [NSNull null]) {
                NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.dpPathThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                imageURL = [NSURL URLWithString:imageURLString];
                
            }else {
                
            }
            //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,event.eventThumbImg]];
            
            [cell.imageOfEvent setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            [Utility setViewCornerRadius:cell.imageOfEvent radius:cell.imageOfEvent.frame.size.width/2];
        }
        
        return  cell ;
    } else {
        
        
        if (tempmasterObj.eventList.count > 0){
            EventObject *obj = (EventObject *)[ tempmasterObj.eventList objectAtIndex:indexPath.row];
            [cell.btnChat_Pressed setHidden:true];
            
            cell.lblNameOfEvent.text = obj.eventName ;
            [cell.lblTimeOfEvent setText:[NSString stringWithFormat:@"%@ - %@", obj.eventStartTime,obj.eventEndTime]];
            
            NSURL *imageURL ;
            id  thumbnailImage = obj.eventThumbImg ;
            
            if (thumbnailImage != [NSNull null]) {
                NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                imageURL = [NSURL URLWithString:imageURLString];
                
            }else {
                
            }
            //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,event.eventThumbImg]];
            
            [cell.imageOfEvent setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
            [Utility setViewCornerRadius:cell.imageOfEvent radius:cell.imageOfEvent.frame.size.width/2];
        }
        
        return  cell ;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isUserOrEvent  == true ){
        AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
        MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[tempmasterObj.searchUserList objectAtIndex:indexPath.row];
        vc.selectGoldMember = goldMember ;
        
        vc.pushTypeGoldOrYpoMember = 2 ;
        [self.navigationController pushViewController:vc animated:true];
        

    }
    else {
        
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
    }
    



-(void)btnChat_Pressed:(YPOSearchEventCell *)cell indexPathRow:(NSIndexPath *)indexPathRow {
    YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[tempmasterObj.searchUserList objectAtIndex:indexPathRow.row];
    vc.selectGoldMember = goldMember ;
    vc.pushTypeGoldOrYpoMember = 3 ;
    [self.navigationController pushViewController:vc animated:true];
    
}


@end
