//
//  YPOGoldAndYPOMemberVc.m
//  YPO
//
//  Created by Ahmed Durrani on 01/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOGoldAndYPOMemberVc.h"
#import "MOGoldMember.h"
#import "AppDelegate.h"
#import "GoldMemberCell.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "AttendeeSpeakerSessionViewController.h"
#import "YPOChatViewController.h"
#import "loginResponse.h"
#import "GetGoldMember+CoreDataClass.h"
@interface YPOGoldAndYPOMemberVc ()<UITableViewDelegate , UITableViewDataSource , MessageBtn_PressedDelegate>
{
    __weak IBOutlet UIView *viewOfGoldMember;
    __weak IBOutlet UIView *viewOfYPOMember;
    __weak IBOutlet UIButton *btnGoldMember;
    __weak IBOutlet UIButton *btnOfYpoMember;
//    __weak IBOutlet UIView *viewOfMember;
//    __weak IBOutlet UIView *viewOfNavigation;
    BOOL isSearching;
    BOOL isYPOOrGold;
    IBOutlet UIButton *btnChat;


    IBOutlet UILabel *titleOfMember;
    MOGoldMember *tempmasterObj;
     
    
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UISearchBar     *searchContacts;
    AppDelegate  *appdelegate ;

}
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;
@property (strong, nonatomic) NSMutableArray* getAllGoldMembersss;


@end

@implementation YPOGoldAndYPOMemberVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnGoldMember setSelected:true];
    isYPOOrGold == true ;
    searchContacts.placeholder = @"Search the Member" ;
    _getAllGoldMembersss =  [[NSMutableArray alloc] init];
    
    titleOfMember.text = _titleOfSelected ;
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];
    
    if([Utility connectedToNetwork]){
        [self getAllGoldMember];

    } else {
        _getAllGoldMembersss = [GetGoldMember fetchAll].mutableCopy ;
        tblView.delegate = self ;
        tblView.dataSource = self ;

        [tblView reloadData];
        [self updateTableDataOffline:@""];

    }
    
    
    

    // Do any additional setup after loading the view.
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appdelegate.isViewVisible = true ;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllGoldMember
{

    NSString *serviceType = [[NSString alloc] init];

    if (_valueForMember == 2)
    {
        serviceType = @"api/user/getByTypeByPage/2/true/1/100000";

    }
    else
    {
        serviceType = @"api/user/getByTypeByPage/2/false/1/100000";

    }
    [[Webclient sharedWeatherHTTPClient] getGoldAndYPOMemberLost:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (MOGoldMember*) responseObject;
        [self updateTableData:@""];

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

-(void)getAllYPOMember
{
    NSString *serviceType = [[NSString alloc] init];
    
    if (_valueForMember == 2)
    {
        serviceType = @"api/user/getByTypeByPage/1/true/1/100000";
        
    }
    else
    {
        serviceType = @"api/user/getByTypeByPage/1/false/1/100000";
        
    }
    [[Webclient sharedWeatherHTTPClient] getGoldAndYPOMemberLost:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (MOGoldMember*) responseObject;
        [self updateTableData:@""];
        
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


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)updateTableDataOffline:(NSString*)searchString
{
    _filteredTableData = [[NSMutableDictionary alloc] init];
    
    
    for (MOGoldMemberObject* food in self.getAllGoldMembersss)
    {
        
        if (isYPOOrGold == true ) {
            
        }
        if ([food.userType isEqualToString:@"Gold"]) {
            bool isMatch = false;
            if(searchContacts.text.length == 0)
            {
                // If our search string is empty, everything is a match
                isMatch = true;
            }
            else
            {
                
                // If we have a search string, check to see if it matches the food's name or description
                NSRange nameRange = [food.firstName rangeOfString:searchString options:NSCaseInsensitiveSearch];
                NSRange lastNameRange = [food.lastName rangeOfString:searchString options:NSCaseInsensitiveSearch];
                NSRange designation = [food.jobtitle rangeOfString:searchString options:NSCaseInsensitiveSearch];
                
                if(nameRange.location != NSNotFound || lastNameRange.location != NSNotFound || designation.location != NSNotFound )
                    isMatch = true;
            }
            
            // If we have a match...
            if(isMatch)
            {
                // Find the first letter of the food's name. This will be its gropu
                NSString* firstLetter = [food.firstName substringToIndex:1];
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForLetter = (NSMutableArray*)[_filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    
                    NSString *upper = [firstLetter uppercaseString];
                    
                    [_filteredTableData setValue:arrayForLetter forKey:upper];
                }
                
                // Finally, add the food to this group's array
                [arrayForLetter addObject:food];
            }
        }
        
        _letters = [[_filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [tblView reloadData];
        }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Board / Members Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

-(void)updateTableData:(NSString*)searchString
{
    _filteredTableData = [[NSMutableDictionary alloc] init];
    
    
    for (MOGoldMemberObject* food in tempmasterObj.eventList)
    {
        
        
        bool isMatch = false;
        if(searchContacts.text.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            
            // If we have a search string, check to see if it matches the food's name or description
            NSRange nameRange = [food.firstName rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange lastNameRange = [food.lastName rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange designation = [food.jobtitle rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || lastNameRange.location != NSNotFound || designation.location != NSNotFound )
                isMatch = true;
        }
        
        // If we have a match...
        if(isMatch)
        {
            // Find the first letter of the food's name. This will be its gropu
            NSString* firstLetter = [food.firstName substringToIndex:1];
            
            // Check to see if we already have an array for this group
            NSMutableArray* arrayForLetter = (NSMutableArray*)[_filteredTableData objectForKey:firstLetter];
            if(arrayForLetter == nil)
            {
                // If we don't, create one, and add it to our dictionary
                arrayForLetter = [[NSMutableArray alloc] init];
                
                NSString *upper = [firstLetter uppercaseString];
                
                [_filteredTableData setValue:arrayForLetter forKey:upper];
            }
            
            // Finally, add the food to this group's array
            [arrayForLetter addObject:food];
        }
    }
    
    _letters = [[_filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [tblView reloadData];
    
}

#pragma mark -SearchInTableView-
- (void)searchTableList :(NSString*)searchString {
    
    [self searchTableList:searchString];
    
    //    NSString *searchString = searchContacts.text;
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"firstName contains[c] %@", searchString];
    //    _searchResult = [tempmasterObj.eventList filteredArrayUsingPredicate:resultPredicate];
    
    //    NSLog(@"print it %@", _searchResult);
    
    
}

#pragma mark - Search Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    if (isYPOOrGold == true) {
        if([searchText length] != 0) {
            isSearching = YES;
            [self updateTableData:searchText];
        }
        else {
            [self updateTableData:@""];
            
            //        isSearching = NO;
        }

    } else  {
        if([searchText length] != 0) {
            isSearching = YES;
            [self updateTableData:searchText];
        }
        else {
            [self updateTableData:@""];
            
            //        isSearching = NO;
        }

    }
    [tblView reloadData];
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

- (IBAction)btnGoldMember_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    [btnGoldMember setSelected:true];
    [btnOfYpoMember setSelected:false];
    [viewOfYPOMember setHidden:true];
    [viewOfGoldMember setHidden:false];
    isYPOOrGold = false ;
    searchContacts.placeholder = @"Search the GOLD Member" ;
    searchContacts.text = @"";
//    [tblView reloadData] ;
    [searchContacts resignFirstResponder];
    if([Utility connectedToNetwork]){
        [self getAllGoldMember];

    } else {
        _getAllGoldMembersss = [GetGoldMember fetchAll].mutableCopy ;
        [self updateTableDataOffline:@""];

        [tblView reloadData];
    }
    
    
}

- (IBAction)btnYPOMember:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [btnOfYpoMember setSelected:true];
    [btnGoldMember setSelected:false];
    
    [viewOfGoldMember setHidden:true];
    [viewOfYPOMember setHidden:false];
    isYPOOrGold = true ;
    searchContacts.text = @"";

    searchContacts.placeholder = @"Search the YPO Member" ;
    [searchContacts resignFirstResponder];
    if([Utility connectedToNetwork]){
        [self getAllYPOMember];

    } else {
        _getAllGoldMembersss = [GetGoldMember fetchAll].mutableCopy ;
        [self updateTableDataOffline:@""];

        [tblView reloadData];
    }
//    [tblView reloadData] ;
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isYPOOrGold == true){
        return _letters;

    } else {
        return _letters;

    }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (isYPOOrGold == true){
        return [_letters indexOfObject:title];

    } else {
        return [_letters indexOfObject:title];

    }
}
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return[NSArray arrayWithObjects:@"a", @"e", @"i", @"m", @"p", nil];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString
//                                                                             *)title atIndex:(NSInteger)index {
//    return  5 ;
//}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.sections;
//}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Each letter is a section title
    if (isYPOOrGold == true){
        NSString* key = [_letters objectAtIndex:section];
        return key;
    } else {
        NSString* key = [_letters objectAtIndex:section];
        return key;
    }
    
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//
//    // Return the number of letters in our letter array. Each letter represents a section.
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([Utility connectedToNetwork]){
        if (isYPOOrGold == true){
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
            
            return _letters.count;
            
        } else {
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
            
            return _letters.count;
        }
    } else {
        if (isYPOOrGold == true){
            NSInteger numOfSections = 0;
            if (self.getAllGoldMembersss.count >0)
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
            
            return _letters.count;
            
        } else {
            NSInteger numOfSections = 0;
            if (_getAllGoldMembersss.count >0)
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
            
            return _letters.count;
        }
    }
    
  
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (isYPOOrGold == true){
        NSString* letter = [_letters objectAtIndex:section];
        NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
        return arrayForLetter.count;
        
    } else {
        NSString* letter = [_letters objectAtIndex:section];
        NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
        return arrayForLetter.count;
        
        
    }
  

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    GoldMemberCell *cell = (GoldMemberCell *)[tableView dequeueReusableCellWithIdentifier:@"GoldMemberCell"];
    if([Utility connectedToNetwork]){
        MOGoldMemberObject *obj ;
        NSString* letter = [_letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
        cell.delegate = self ;
        cell.index = indexPath ;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
        obj = [arrayForLetter objectAtIndex:indexPath.row];
        
        if ([obj.ids isEqualToString:userInfo.loginUserID]) {
            [cell.btnOfImageSelected setHidden:true];
            
            
        } else {
            [cell.btnOfImageSelected setHidden:false];
            
        }
        
        [cell setGoldMemberObj:obj] ;
    } else {
        GetGoldMember *obj ;
        NSString* letter = [_letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
        cell.delegate = self ;
        cell.index = indexPath ;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
        obj = [arrayForLetter objectAtIndex:indexPath.row];
        
        if ([obj.idOfGoldMember isEqualToString:userInfo.loginUserID]) {
            [cell.btnOfImageSelected setHidden:true];
            
            
        } else {
            [cell.btnOfImageSelected setHidden:false];
            
        }
        
        [cell setGoldOfflineMember:obj] ;

    }
    
    
    //    MOGoldMemberObject *obj  =  (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
   
    
    return cell ;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
    NSString* letter = [_letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[arrayForLetter objectAtIndex:indexPath.row];
    vc.selectGoldMember = goldMember ;
    
    vc.pushTypeGoldOrYpoMember = 1 ;
    [self.navigationController pushViewController:vc animated:true];
    
    //    [self presentViewController:vc animated:true completion:^{
    //
    //    }];
    
    
}

-(void)btnMessagePressedInGoldMember:(GoldMemberCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
{
    YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    NSString* letter = [_letters objectAtIndex:indexPathRow.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[arrayForLetter objectAtIndex:indexPathRow.row];
    vc.selectGoldMember = goldMember ;
    vc.pushTypeGoldOrYpoMember = 1 ;
    
    [self.navigationController pushViewController:vc animated:true];
}

@end
