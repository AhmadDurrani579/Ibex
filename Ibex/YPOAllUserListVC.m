//
//  YPOAllUserListVC.m
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOAllUserListVC.h"
#import "MOGoldMember.h"
#import "YPOAllUserList.h"
#import "MOGoldMemberObject.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "GroupUserCell.h"
#import "MOGoldMemberObject.h"
#import "UIViewController+Helper.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "YPOSelectUserForChat.h"
#import "YPOChatViewController.h"
@interface YPOAllUserListVC ()<UITableViewDelegate , UITableViewDataSource>
{
    BOOL isSearching;

    MOGoldMember *tempmasterObj;
    __weak IBOutlet UISearchBar     *searchContacts;

}
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSArray       *searchResult;

@end

@implementation YPOAllUserListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getALlSearchList];

}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)getALlSearchList
{
    [[Webclient sharedWeatherHTTPClient] getAllUserList:@"" viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (MOGoldMember*) responseObject;
        //        [self updateTableData:@""];
        
        //        MOGoldMember
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            //[tvEvents reloadData];
            
           
            _tblView.delegate = self ;
            _tblView.dataSource = self ;
            [_tblView reloadData];
        }
        
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"All User Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

#pragma mark - Search Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        isSearching = NO;
    }
    [_tblView reloadData];
}

#pragma mark -SearchInTableView-
- (void)searchTableList {
    NSString *searchString = searchContacts.text;
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(firstName contains[cd] %@) OR (lastName contains[cd] %@)", searchString, searchString];
    
    
    _searchResult = [tempmasterObj.eventList filteredArrayUsingPredicate:resultPredicate];
    [_tblView reloadData];
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    searchContacts.text=@"";
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if (tempmasterObj.eventList.count >0)
    {
        numOfSections                = 1;
        _tblView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tblView.bounds.size.width, _tblView.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        _tblView.backgroundView = noDataLabel;
        _tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (isSearching) {
        return _searchResult.count ;
    }
    else {
        return tempmasterObj.eventList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOSelectUserForChat *cell = (YPOSelectUserForChat *)[tableView dequeueReusableCellWithIdentifier:@"YPOSelectUserForChat"];
    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    loginResponse *userObj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    
    if (tempmasterObj.eventList.count > 0){
        MOGoldMemberObject *obj ;
        if (isSearching) {
            obj = [_searchResult objectAtIndex:indexPath.row];
        }
        else {
            obj = [tempmasterObj.eventList objectAtIndex:indexPath.row];
            
        }
        
        [cell.nameOfUser setText:[NSString stringWithFormat:@"%@ %@", obj.firstName , obj.lastName]];
        cell.emialOfUser.text = obj.email ;
        
        
        NSURL *imageURL ;
        id  thumbnailImage = obj.dpPathThumb ;
        
        if (thumbnailImage != [NSNull null]) {
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.dpPathThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            imageURL = [NSURL URLWithString:imageURLString];
            
        }else {
            
        }
        [cell.imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:cell.imageOfUser radius:cell.imageOfUser.frame.size.width/2];
    }
    
    return  cell ;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70.0 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    
    MOGoldMemberObject *goldMember ;
    if (isSearching) {
        goldMember = [_searchResult objectAtIndex:indexPath.row];
    }
    else {
        goldMember = [tempmasterObj.eventList objectAtIndex:indexPath.row];
    }
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    if ([goldMember.ids isEqualToString:userInfo.loginUserID]) {
        
    } else {
        vc.selectGoldMember = goldMember ;
        vc.pushTypeGoldOrYpoMember = 3 ;
        [self.navigationController pushViewController:vc animated:true];
        
    }

    
    
//    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
   

    
}




@end
