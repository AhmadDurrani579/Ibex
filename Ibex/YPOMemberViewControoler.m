//
//  YPOMemberViewControoler.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOMemberViewControoler.h"
#import "YPOMemberCell.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "MOGoldMember.h"
#import "MOGoldMemberObject.h"
#import "AttendeeSpeakerSessionViewController.h"
#import "YPOChatViewController.h"
#import "Roaster+CoreDataClass.h"
#import "AppDelegate.h"

@interface YPOMemberViewControoler () <UITableViewDelegate , UITableViewDataSource, MessageBtn_YPOMemberDelegate >
{
    BOOL isSearching;

    MOGoldMember *tempmasterObj;

    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UISearchBar     *searchYpoMember;
    AppDelegate *appdelegate ;
}
@property (nonatomic, strong) NSArray       *searchResult;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;
@property (nonatomic,strong) Roaster *recentList;


@end

@implementation YPOMemberViewControoler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayOfRoaster = [[NSMutableArray alloc] init];

    arrayOfRoaster = [Roaster fetchAll].mutableCopy ;

    searchYpoMember.placeholder = @"Search the YPO Member" ;
    
    [self getAllYPOMember];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appdelegate.isViewVisible = true ;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showView" object:nil userInfo:nil];

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

-(void)updateTableData:(NSString*)searchString
{
    _filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (MOGoldMemberObject* food in tempmasterObj.eventList)
    {
        bool isMatch = false;
        if(searchYpoMember.text.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            // If we have a search string, check to see if it matches the food's name or description
            NSRange nameRange = [food.firstName rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange lastName = [food.lastName rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange designation = [food.jobtitle rangeOfString:searchString options:NSCaseInsensitiveSearch];

            
            if(nameRange.location != NSNotFound || lastName.location != NSNotFound || designation.location != NSNotFound )

            if(nameRange.location != NSNotFound)
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
    
}


//#pragma mark -SearchInTableView-
//- (void)searchTableList {
//    NSString *searchString = searchYpoMember.text;
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"firstName contains[c] %@", searchString];
//    _searchResult = [tempmasterObj.eventList filteredArrayUsingPredicate:resultPredicate];
//    [tblView reloadData];
//    NSLog(@"print it %@", _searchResult);
//    
//    
//}
#pragma mark - Search Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self updateTableData:searchText];
    }
    else {
        [self updateTableData:@""];
        
        //        isSearching = NO;
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
    
    searchYpoMember.text=@"";
    
}

#pragma mark -UITableView Method-


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _letters;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_letters indexOfObject:title];
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Each letter is a section title
    NSString* key = [_letters objectAtIndex:section];
    return key;
}

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
    
    return _letters.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    NSString* letter = [_letters objectAtIndex:section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    return arrayForLetter.count;
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//{
//    
//    if (isSearching) {
//        return _searchResult.count ;
//    }
//    else {
//        return  tempmasterObj.eventList.count ;
//    }
//}
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOMemberCell *cell = (YPOMemberCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOMemberCell"];
    //    MOGoldMemberObject *obj  =  (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
    MOGoldMemberObject *obj ;
    NSString* letter = [_letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    obj = [arrayForLetter objectAtIndex:indexPath.row];
    cell.index = indexPath ;
    
    cell.delegate = self ;
    
    [cell setGoldMemberObj:obj] ;
    
    return cell ;
    
}



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    YPOMemberCell *cell = (YPOMemberCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOMemberCell"];
//    MOGoldMemberObject *obj  =  (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
//    
//    if (isSearching) {
//        obj = [_searchResult objectAtIndex:indexPath.row];
//    }
//    else {
//        obj = [tempmasterObj.eventList objectAtIndex:indexPath.row];
//        
//    }
//
//    
//    [cell setGoldMemberObj:obj] ;
//    
//    return cell ;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
    NSString* letter = [_letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[arrayForLetter objectAtIndex:indexPath.row];
    vc.selectGoldMember = goldMember ;
    
    vc.pushTypeGoldOrYpoMember = 1 ;
    
    [self presentViewController:vc animated:true completion:^{
        
    }];

    
    
    //
    
}

-(void)btnMesaage_YPOMember_Pressed:(YPOMemberCell *)cell indexPathRow:(NSIndexPath *)indexPathRow
{
    YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    NSString* letter = [_letters objectAtIndex:indexPathRow.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[arrayForLetter objectAtIndex:indexPathRow.row];
    vc.selectGoldMember = goldMember ;
    vc.pushTypeGoldOrYpoMember = 1 ;
    
    //    vc.pushTypeGoldOrYpoMember = 1 ;
    
    [self presentViewController:vc animated:true completion:^{
        
    }];
    
    //
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
//    
//    if (isSearching) {
//        MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[_searchResult objectAtIndex:indexPath.row];
//        vc.selectGoldMember = goldMember ;
//        
//    }
//    else
//    {
//        MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
//        vc.selectGoldMember = goldMember ;
//        
//    }
//    [self presentViewController:vc animated:true completion:^{
//        
//    }];
//
//    
////    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row];
////    
////    vc.pushTypeGoldOrYpoMember = 1 ;
////    
////    vc.selectGoldMember = goldMember ;
//    
//    
////
//
//}



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//{
//    return  5 ;
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    YPOMemberCell *cell = (YPOMemberCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOMemberCell"];
//    
//    return cell ;
//    
//}


@end
