//
//  AttendeesViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 29/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "AttendeesViewController.h"
#import "Webclient.h"
#import "Utility.h"
#import "DAAlertController.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "AttendessResponse.h"
#import "EventSpeakerSessionViewController.h"
#import "EventSpeakerTableViewCell.h"
#import "EventSpeakerResponse.h"
#import "AttendeeSpeakerSessionViewController.h"
#import "AppDelegate.h"
#import "YPOChatViewController.h"
#import "Chat+CoreDataClass.h"
#import "loginResponse.h"
#define kGradientStartColor	[UIColor colorWithRed:142.0 / 255.0 green:214.0 / 255.0 blue:39.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:13.0 / 255.0 green:222.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]

@interface AttendeesViewController ()<MessageBtnDelegate>{
    BOOL isSearching;
    __weak IBOutlet UISearchBar     *searchContacts;
    IBOutlet UIButton *btnChat;

}
@property (nonatomic, strong) NSArray       *searchResult;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;
@property (nonatomic , strong)NSMutableArray *arrayOfRecentUser ;


@end

@implementation AttendeesViewController
@synthesize tvAttendees, topAlignmentConstraint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchContacts.placeholder = @"Search" ;

    _arrayOfRecentUser = [[NSMutableArray alloc] init];
    
    _arrayOfRecentUser = [Roaster fetchAll].mutableCopy ;

//    profile = [Chat fetchWithPredicate:[NSPredicate predicateWithFormat:@"from_Jabber == %@",checkList.jaber_ID] sortDescriptor:nil fetchLimit:0].lastObject;

    [self updateTableData:@""];
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];

    
//    [self fetchAttendees];
    [self setupButtonView];
 
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

- (IBAction)btnBAck_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

-(void)updateTableData:(NSString*)searchString
{
    _filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (EventSpeakerModel* food in _masterObj.attendeesList)
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
            NSRange nameRange = [food.speakerFirstName rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
                isMatch = true;
        }
        
        // If we have a match...
        if(isMatch)
        {
            // Find the first letter of the food's name. This will be its group
            NSString* firstLetter = [food.speakerFirstName substringToIndex:1];
            
            // Check to see if we already have an array for this group
            NSMutableArray* arrayForLetter = (NSMutableArray*)[_filteredTableData objectForKey:firstLetter];
            if(arrayForLetter == nil)
            {
                // If we don't, create one, and add it to our dictionary
                arrayForLetter = [[NSMutableArray alloc] init];
//                NSString *upper = [firstLetter uppercaseString];
                NSString *upper = firstLetter ;
                [_filteredTableData setValue:arrayForLetter forKey:upper];
            }
            
            // Finally, add the food to this group's array
            [arrayForLetter addObject:food];
        }
    }
    
    _letters = [[_filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [tvAttendees reloadData];
    
}



//-(void) fetchAttendees{
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    NSString *eventID = [NSString stringWithFormat:@"%@", appDelegate.selectedEventID];
//    
//    [[Webclient sharedWeatherHTTPClient] getAttendess:eventID viewController:self CompletionBlock:^(NSObject *responseObject) {
//       
//        _masterObj = (AttendessResponse*) responseObject;
//        
//        if([[NSString stringWithFormat:@"%@", _masterObj.status] isEqualToString:@"1"]){
//            [tvAttendees reloadData];
//        }
//        else{
//            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                    style:DAAlertActionStyleCancel
//                                                                  handler:^{
//                                                                      [self.navigationController popViewControllerAnimated:YES];
//                                                                  }];
//            
//            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", _masterObj.message] actions:@[dismissAction]];
//        }
//        
//    } FailureBlock:^(NSError *error) {
//        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                style:DAAlertActionStyleCancel
//                                                              handler:^{
//                                                                  [self.navigationController popViewControllerAnimated:YES];
//                                                              }];
//        
//        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
//    }];
//    
//}

#pragma mark -SearchInTableView-
- (void)searchTableList :(NSString*)searchString {
    
    [self searchTableList:searchString];
}


#pragma mark - Search Implementation

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
    [tvAttendees reloadData];
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


-(void) setupButtonView{
    if([Utility iPhone6PlusDevice]){
        [topAlignmentConstraint setConstant:160.0];
    }
    else{
        [topAlignmentConstraint setConstant:138.0];
    }
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




#pragma mark -UITableView Method-


//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _letters;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_letters indexOfObject:title];
}

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
    NSString* key = [_letters objectAtIndex:section];
    return key;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if (_masterObj.attendeesList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvAttendees.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvAttendees.bounds.size.width, tvAttendees.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvAttendees.backgroundView = noDataLabel;
        tvAttendees.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _letters.count;

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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    NSString* letter = [_letters objectAtIndex:section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    return arrayForLetter.count;
    //    if (isSearching) {
    //        return _searchResult.count ;
    //    }
    //    else {
    
    
    //        return  tempmasterObj.eventList.count ;
    //    }
    
    
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (isSearching) {
//        return _searchResult.count ;
//    }
//    else {
//        return _masterObj.attendeesList.count;
//    }
//
//}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    AttendeeSpeakerSessionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
    NSString* letter = [_letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    EventSpeakerModel *obj  =  (EventSpeakerModel *)[arrayForLetter objectAtIndex:indexPath.row];
    
    vc.selectedSpeaker = obj ;
    
//    if (isSearching) {
//        EventSpeakerModel *obj = [self.searchResult objectAtIndex:indexPath.row];
//        vc.selectedSpeaker = obj ;
//    }
//    else
//    {
//        EventSpeakerModel *obj = [self.masterObj.attendeesList objectAtIndex:indexPath.row];
//        vc.selectedSpeaker = obj ;
//    }
    
    
    vc.pushTypeGoldOrYpoMember = 0 ;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"eventspeakerCell";
    
    EventSpeakerTableViewCell *cell = (EventSpeakerTableViewCell *)[tvAttendees dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EventSpeakerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  
    
    cell.index = indexPath ;
    cell.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString* letter = [_letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    EventSpeakerModel *obj  = [arrayForLetter objectAtIndex:indexPath.row];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSString *speakerID = [NSString stringWithFormat:@"%@" , obj.speakerID] ;
    
    if ([speakerID isEqualToString:[NSString stringWithFormat:@"%@", userInfo.loginUserID]]) {
        [cell.btnMessage setHidden:true];
        
        
    } else {
        [cell.btnMessage setHidden:false];
        
    }

    
//    if (isSearching) {
//        obj = [_searchResult objectAtIndex:indexPath.row];
//    }
//    else {
//        obj = [_masterObj.attendeesList objectAtIndex:indexPath.row];
//    }

    
    
//    cell.lblTitle.gradientStartColor = kGradientStartColor;
//    cell.lblTitle.gradientEndColor = kGradientEndColor;
//    cell.lblTitle.gradientStartPoint = CGPointMake(0, 0);
//    cell.lblTitle.gradientEndPoint = CGPointMake(300, 0);
    
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", obj.speakerFirstName, obj.speakerLastName];
    
    if([[tempString lowercaseString] containsString:@"(null)"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    
    if([[tempString lowercaseString] containsString:@"<null>"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    }
    [cell.lblTitle setText:tempString];
    
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
    
    if(![Utility isEmptyOrNull:obj.speakerThumbImg]){
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        [cell.ivUserPic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [cell.ivUserPic setContentMode:UIViewContentModeScaleAspectFill];
        cell.ivUserPic.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
        cell.ivUserPic.layer.masksToBounds = YES;
        //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL, selectedSpeaker.speakerThumbImg]];
//        [ivProfilePic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
//        [ivProfilePic setContentMode:UIViewContentModeScaleAspectFill];
//        ivProfilePic.layer.cornerRadius = ivProfilePic.frame.size.height/2;
//        ivProfilePic.layer.masksToBounds = YES;
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

-(void)btnMessage_Pressed:(EventSpeakerTableViewCell *)cell indexPathRow:(NSIndexPath *)indexPathRow {
    YPOChatViewController *chatVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    NSString* letter = [_letters objectAtIndex:indexPathRow.section];
    
//    Roaster *checkList = (Roaster *)[self.arrayOfRecentUser objectAtIndex:indexPath.row];
//    Chat *profile;
//    if (self.arrayOfRecentUser.count > 0) {
//        profile = [Chat fetchWithPredicate:[NSPredicate predicateWithFormat:@"from_Jabber == %@",checkList.jaber_ID] sortDescriptor:nil fetchLimit:0].lastObject;
//    }
//    NSLog(@"print it %@ ", checkList.name);

    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
//    Roaster *checkList = (Roaster *)[self.arrayOfRecentUser objectAtIndex:indexPathRow.row];
//    chatVc.selectedUser  = checkList ;
    EventSpeakerModel *obj  =  (EventSpeakerModel *)[arrayForLetter objectAtIndex:indexPathRow.row];
    chatVc.pushTypeGoldOrYpoMember = 4 ;
    
    chatVc.selectedSpeaker = obj ;
    [self.navigationController pushViewController:chatVc animated:true];
    

    
}
@end
