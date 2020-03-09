//
//  EventSpeakersViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 29/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSpeakersViewController.h"
#import "Utility.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "EventSpeakerResponse.h"
#import "EventSpeakerTableViewCell.h"
#import "EventSpeakerModel.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "EventSpeakerSessionViewController.h"
#import "AppDelegate.h"
#import "YPOChatViewController.h"
#import "loginResponse.h"

#define kGradientStartColor	[UIColor colorWithRed:142.0 / 255.0 green:214.0 / 255.0 blue:39.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:13.0 / 255.0 green:222.0 / 255.0 blue:209.0 / 255.0 alpha:1.0]

/*
 Start color : R=142, G=214, B=39
 end color : R=13, G=222, B=209
 Gradient angle : 120
 */
@interface EventSpeakersViewController ()<UISearchBarDelegate>{
    BOOL isSearching;
    __weak IBOutlet UISearchBar     *searchContacts;
    IBOutlet UIButton *btnChat;


}
@property (nonatomic, strong) NSArray       *searchResult;


@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIBarButtonItem *searchItem;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;

@end

@implementation EventSpeakersViewController
@synthesize topAlignmentConstraint,tvEventSpeaker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupButtonView];
    searchContacts.placeholder = @"Search" ;

    [self updateTableData:@""];

//    [self fetchEventSpeaker];
   // [self addSearchButton];
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];

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
-(void)updateTableData:(NSString*)searchString
{
    _filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (EventSpeakerModel* food in _masterObj.speakerList)
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
            NSRange jobTitle = [food.speakerJobTitle rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange country = [food.speakerCountry rangeOfString:searchString options:NSCaseInsensitiveSearch];
            NSRange company = [food.speakerCompany rangeOfString:searchString options:NSCaseInsensitiveSearch];

//            NSRange nameRange = [food.firstName rangeOfString:searchString options:NSCaseInsensitiveSearch];
//            NSRange lastNameRange = [food.lastName rangeOfString:searchString options:NSCaseInsensitiveSearch];
//            NSRange designation = [food.jobtitle rangeOfString:searchString options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || jobTitle.location != NSNotFound || country.location != NSNotFound  || company.location != NSNotFound )
                isMatch = true;
        }

//            if(nameRange.location != NSNotFound)
//                isMatch = true;
//        }
        
        // If we have a match...
        if(isMatch)
        {
            // Find the first letter of the food's name. This will be its gropu
            NSString* firstLetter = [food.speakerFirstName substringToIndex:1];
            
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
    [tvEventSpeaker reloadData];
    
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


- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

-(void) addSearchButton{
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(searchButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = searchButton;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void)searchButtonTapped:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        _searchButton.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        // remove the search button
        self.navigationItem.rightBarButtonItem = nil;
        // add the search bar (which will start out hidden).
        self.navigationItem.titleView = _searchBar;
        _searchBar.alpha = 0.0;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _searchBar.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [_searchBar becomeFirstResponder];
                         }];
        
    }];
}

//#pragma mark UISearchBarDelegate methods
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    
//    [UIView animateWithDuration:0.5f animations:^{
//        _searchBar.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        self.navigationItem.titleView = nil;
//        self.navigationItem.rightBarButtonItem = _searchItem;
//        _searchButton.alpha = 0.0;  // set this *after* adding it back
//        [UIView animateWithDuration:0.5f animations:^ {
//            _searchButton.alpha = 1.0;
//        }];
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
    [tvEventSpeaker reloadData];
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


// called when cancel button pressed

//-(void) fetchEventSpeaker{
//    
//    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    NSString *eventID = [NSString stringWithFormat:@"%@", appDelegate.selectedEventID];
//    
//    [[Webclient sharedWeatherHTTPClient] getEventSpeakers:eventID viewController:self CompletionBlock:^(NSObject *responseObject) {
//        
//        _masterObj = (EventSpeakerResponse*) responseObject;
//        
//        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
//            [tvEventSpeaker reloadData];
//        }
//        else{
//            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                                                    style:DAAlertActionStyleCancel
//                                                                  handler:^{
//                                                                      [self.navigationController popViewControllerAnimated:YES];
//                                                                  }];
//            
//            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", masterObj.message] actions:@[dismissAction]];
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

-(void) setupButtonView{
    if([Utility iPhone6PlusDevice]){
        [topAlignmentConstraint setConstant:160.0];
    }
    else{
        [topAlignmentConstraint setConstant:138.0];
    }
}

#pragma mark - Table view data source

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
    if (_masterObj.speakerList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvEventSpeaker.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvEventSpeaker.bounds.size.width, tvEventSpeaker.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvEventSpeaker.backgroundView = noDataLabel;
        tvEventSpeaker.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _letters.count;
    ;
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
//  
//    if (isSearching) {
//        return _searchResult.count ;
//    }
//    else {
//        return _masterObj.speakerList.count;
//    }
//
//}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    EventSpeakerSessionViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"sessionVC"];
    NSString* letter = [_letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    EventSpeakerModel *obj  =  (EventSpeakerModel *)[arrayForLetter objectAtIndex:indexPath.row];
    
    vc.selectedSpeaker = obj ;

    
//    if (isSearching) {
//        obj = [self.searchResult objectAtIndex:indexPath.row];
//        vc.selectedSpeaker = obj;
//    }
//    else
//    {
//        obj = [_masterObj.speakerList objectAtIndex:indexPath.row];
//        vc.selectedSpeaker = obj ;
//    }

//     = [_masterObj.speakerList objectAtIndex:indexPath.row];
//    
//    vc.selectedSpeaker = obj;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"eventspeakerCell";
    
    EventSpeakerTableViewCell *cell = (EventSpeakerTableViewCell *)[tvEventSpeaker dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EventSpeakerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

//    EventSpeakerModel *obj ;
//    
//    if (isSearching) {
//        obj = [_searchResult objectAtIndex:indexPath.row];
//    }
//    else {
//        obj = [_masterObj.speakerList objectAtIndex:indexPath.row];
//    }
    NSString* letter = [_letters objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    EventSpeakerModel *obj  = [arrayForLetter objectAtIndex:indexPath.row];

    cell.index = indexPath ;
    cell.delegate = self;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    NSString *speakerID = [NSString stringWithFormat:@"%@" , obj.speakerID] ;

    if ([speakerID isEqualToString:[NSString stringWithFormat:@"%@", userInfo.loginUserID]]) {
        [cell.btnMessage setHidden:true];
        
        
    } else {
        [cell.btnMessage setHidden:false];
        
    }

    
   // [cell.lblTitle setText:[NSString stringWithFormat:@"%@ %@", obj.speakerFirstName, obj.speakerLastName]];
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", obj.speakerFirstName, obj.speakerLastName];
    //[cell.lblTitle setText:[tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""]];
    
    if([[tempString lowercaseString] containsString:@"(null)"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    
    if([[tempString lowercaseString] containsString:@"<null>"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    }
    [cell.lblTitle setText:tempString];
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

    
//    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", obj.speakerThumbImg]]){
//        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
//        NSURL *imageURL = [NSURL URLWithString:imageURLString];
//        [cell.ivUserPic setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
//        [cell.ivUserPic setContentMode:UIViewContentModeScaleAspectFill];
//        cell.ivUserPic.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
//        cell.ivUserPic.layer.masksToBounds = YES;
//    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
