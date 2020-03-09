//
//  YPOCreateGroupVC.m
//  YPO
//
//  Created by Ahmed Durrani on 02/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOCreateGroupVC.h"
#import "YPOSearchEventList.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "EventObject.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "GroupUserCell.h"
#import "MOGoldMemberObject.h"
#import "UIViewController+Helper.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "DBChatManager.h"
#import "ChatRooms+CoreDataClass.h"
#import "YPOGroupChatViewController.h"
#import "MOGoldMember.h"
#import "YPOAllUserList.h"
#import "MOGoldMemberObject.h"
#import "SVHTTPRequest.h"

@interface YPOCreateGroupVC ()<UITableViewDelegate , UITableViewDataSource ,selectUserForGroup , selectUserDelegate>
{
    BOOL isSearching;
    
    __weak IBOutlet UISearchBar     *searchContacts;

    MOGoldMember *tempmasterObj;

}
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UITextField *txtGroupName;
@property (strong, nonatomic) IBOutlet UICollectionView *userCollectionView;
@property (strong, nonatomic)  NSMutableArray *selectedUserForGroup;
@property(nonatomic , strong) NSMutableArray *selectedButton ;
@property(nonatomic , strong) NSMutableArray *selectedButtonSearch ;

@property(nonatomic , strong) NSMutableArray *selectedUser ;
@property (nonatomic , strong) NSString *roomID ;
@property (nonatomic,strong) XMPPRoom *myroom;
@property (nonatomic, strong) NSArray       *searchResult;

@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;



@property (nonatomic,strong) ChatRooms *roomChat;
 ;

@end

@implementation YPOCreateGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedUserForGroup = [[NSMutableArray alloc] init] ;
    [_userCollectionView registerNib:[UINib nibWithNibName:@"GroupUserCell" bundle:nil] forCellWithReuseIdentifier:@"GroupUserCell"];
     _selectedButton = [[NSMutableArray alloc]init];
    _selectedUser = [[NSMutableArray alloc] init];
    _selectedButtonSearch = [[NSMutableArray alloc] init];
    searchContacts.placeholder = @"Search the Member" ;

    [self getALlSearchList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getALlSearchList
{
    [[Webclient sharedWeatherHTTPClient] getAllUserList:@"" viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (MOGoldMember*) responseObject;
         [self updateTableData:@""];
        
//        MOGoldMember
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            //[tvEvents reloadData];
            
            for (int i = 0; i<tempmasterObj.eventList.count; i++) //yourTableSize = how many rows u got
            {
                [_selectedButton addObject:@"NO"];
            }
            _tblView.delegate = self ;
            _tblView.dataSource = self ;
            [_tblView reloadData];

            
//            _userCollectionView.delegate = self ;
//            _userCollectionView.dataSource = self ;
//            [_userCollectionView reloadData];
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
                
                //                NSString *upper = [firstLetter uppercaseString];
                //                if (upper) {
                //                    [_filteredTableData setValue:arrayForLetter forKey:upper];
                //
                //                } else {
                //                    [_filteredTableData setValue:arrayForLetter forKey:upper];
                //
                //                }
                //                if (upper){
                //
                //                } else {
                //
                //                }
                NSString *upper = firstLetter;
                
                [_filteredTableData setValue:arrayForLetter forKey:upper];
            }
            
            // Finally, add the food to this group's array
            [arrayForLetter addObject:food];
        }
    }
    
    _letters = [[_filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [_tblView reloadData];
    
}


- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnCreateGroup_Pressed:(UIButton *)sender {
    
    if (self.txtGroupName.text.length > 0){
        
        if (self.selectedUserForGroup.count >= 2) {
            if (self.selectedUserForGroup.count <= 50) {
                [MBProgressHUD showHUDAddedTo:self.view animated:true];
                
                [self createChatRoom];
            }
            
        } else {
            [self showAlertViewWithTitle:@"ALERT" message:@"Group Member must be greater than 2 "];

        }
        

    } else {
        [self showAlertViewWithTitle:@"ALERT" message:@"Please enter group name"];
    }
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
    
//   _searchResult = [tempmasterObj.eventList filteredArrayUsingPredicate:resultPredicate];
    
    
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Create Group"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}


#pragma mark - Create Group -

-(void)createChatRoom{
    
    XMPPRoomMemoryStorage *roomStorage = [[XMPPRoomMemoryStorage alloc] init];
    
    /**
     * Remember to add 'conference' in your JID like this:
     * e.g. uniqueRoomJID@conference.yourserverdomain
     */
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSString *roomName  = [NSString stringWithFormat:@"%@", [_txtGroupName.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
//    NSString *start = [currentTime stringByReplacingOccurrencesOfString:@"am"
//                                                               withString:@""];
    currentTime = [currentTime stringByReplacingOccurrencesOfString:@" "
                                                           withString:@""] ;
    NSString *finalTime = [currentTime stringByReplacingOccurrencesOfString:@":"
                                                           withString:@""] ;

    
    
    NSString *name         = [NSString stringWithFormat:@"%@%@%@%@ibexglobal.com", obj.loginUserID ,roomName,finalTime,kBaseConfrence]; //
    XMPPJID *roomJID = [XMPPJID jidWithString:name];
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage
                                                           jid:roomJID
                                                 dispatchQueue:dispatch_get_main_queue() withDescription:@"Any Thing"];
    [xmppRoom activate:[SharedDBChatManager xmppStream]];
    [xmppRoom addDelegate:self
            delegateQueue:dispatch_get_main_queue()];
    NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
    [history addAttributeWithName:@"maxstanzas" stringValue:@"10000"];

    [xmppRoom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user history:history];


//    [xmppRoom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user
//                            history:nil
//                           password:nil];
    
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
    
    NSLog(@"room created successfully");
    XMPPJID *roomJidStr = [sender roomJID];
//    if(!_roomChat)        {
//    }
    _roomChat = (ChatRooms *) [ChatRooms create];

//     NSString *
    _roomChat.room_Name = _txtGroupName.text ;
    _roomChat.roomJbID = [NSString stringWithFormat:@"%@",roomJidStr] ;
    _roomChat.userJbID = [NSString stringWithFormat:@"%@",[SharedDBChatManager xmppStream].myJID.user] ;
    _roomChat.lastMessage = @" ";
    _roomChat.dateOfRecentMessage = [NSDate date];
    _roomID = [NSString stringWithFormat:@"%@",roomJidStr];
    
    
    [ChatRooms save];
//    [self getAllGroupFromDB];
    
    
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    
    [sender fetchConfigurationForm];
}


-(void)sendPushNotificatin:(NSString*)message{
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    message = [NSString stringWithFormat:@"%@ %@", obj.loginDisplayName,@"invited you for this group"] ;
    NSString *receiverIDs = [_selectedUser componentsJoinedByString:@","];
 
    NSDictionary *params = nil;
    params =        @{@"SenderId"                :     obj.loginUserID,
                      @"SenderName"              :     _txtGroupName.text,
                      @"RecieverId"              :     receiverIDs ,
                      @"Message"                 :     message ,
                      @"SentDate"                :     @"" ,
                      @"IsChat"                  :     @"true" ,
                      @"GroupName"               :     self.txtGroupName.text ,
                      @"groupId"                 :     _roomID
                      };
    
    
    
    [SVHTTPRequest POST:KBaseUrlForNotification parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
       if (!error) {
            
            NSDictionary *dict = (NSDictionary*)response;
            NSLog(@"what's here %@",dict);
         
        }
        else{
            
            NSLog(@"what's here %@",error.description);
            
            
        }
        
    }];
   
}



- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult{
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
}


- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    NSDictionary *params = nil;
    params =        @{@"sendName"                :     obj.loginDisplayName,
                      @"groupName"               :     _txtGroupName.text,
                      };
    NSXMLElement *newConfig = [configForm copy];
    NSArray *fields = [newConfig elementsForName:@"field"];
    for (NSXMLElement *field in fields)
    {
        NSString *var = [field attributeStringValueForName:@"var"];
        // Make Room Persistent
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
        
        if ([var isEqualToString:@"muc#roomconfig_getmemberlist"]) {
            
            NSLog(@"what's here %@",field);
        }
    }
        [sender configureRoomUsingOptions:newConfig];
        [sender changeRoomSubject:_txtGroupName.text];
    //    XMPPUserCoreDataStorageObject *usr = [cellSelected objectAtIndex:i];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        for (int i = 0; i<[_selectedUserForGroup count]; i++)
        {
            
            MOGoldMemberObject *obj = (MOGoldMemberObject *)[self.selectedUserForGroup objectAtIndex:i];
            
            NSString *myJID ;
            
            myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", obj.ids];
            XMPPJID *inviteUserJbID = [XMPPJID  jidWithString:myJID];
            
            //        XMPPJID *inviteUserJbID = [NSString stringWithFormat:@"%@@ibexglobal.com", obj.ids];
            
            
            [_selectedUser addObject:obj.ids];
            
            [sender editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"member" jid:inviteUserJbID]]];
            //End
            
            
            
            [sender inviteUser:inviteUserJbID withMessage:_txtGroupName.text];

            
        }
        [MBProgressHUD hideHUDForView:self.view animated:true];
        
        

            

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self sendPushNotificatin:@"You are invited for this group"];
        });
        
        

        [self.navigationController popViewControllerAnimated:true];
        [NotifCentre postNotificationName:kGroupChatCreateMessage object:_roomChat];

    });

    
 
    
//    YPOGroupChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGroupChatViewController"] ;
//    [self.navigationController pushViewController:vc animated:true];
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
//
   }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOAllUserList *cell = (YPOAllUserList *)[tableView dequeueReusableCellWithIdentifier:@"YPOAllUserList"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userObj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    MOGoldMemberObject *obj = (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPath.row] ;
//    MOGoldMemberObject *obj ;
    if (tempmasterObj.eventList.count > 0){
        if (isSearching) {
            obj = [_searchResult objectAtIndex:indexPath.row];
        }
        else {
            obj = [tempmasterObj.eventList objectAtIndex:indexPath.row];

        }
    
        if ([obj.ids isEqualToString:userObj.loginUserID]) {
            [cell.btnOfImageSelected setHidden:true];
            
        } else {
            [cell.btnOfImageSelected setHidden:false];

        }
        [cell.nameOfUser setText:[NSString stringWithFormat:@"%@ %@", obj.firstName , obj.lastName]];
        cell.emialOfUser.text = obj.email ;
        
        //        [cell.lblTimeOfEvent setText:[NSString stringWithFormat:@"%@ - %@", obj.eventStartTime,obj.eventEndTime]];
        
        NSURL *imageURL ;
        id  thumbnailImage = obj.dpPathThumb ;
        
        if (thumbnailImage != [NSNull null]) {
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.dpPathThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            imageURL = [NSURL URLWithString:imageURLString];
            
        }else {
            
        }
        //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,event.eventThumbImg]];
        
        
        
        
        [cell.imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:cell.imageOfUser radius:cell.imageOfUser.frame.size.width/2];
        [cell.btnOfImageSelected setTag:indexPath.row];
        
//        if([[_selectedButton objectAtIndex:indexPath.row]isEqualToString:@"NO"])
//        {
            if ([_selectedButtonSearch containsObject:obj.ids]) {
                [cell.btnOfImageSelected setSelected:YES];

            } else {
                [cell.btnOfImageSelected setSelected:NO];

            }
//        }
//        else
//        {
//            if ([_selectedButtonSearch containsObject:obj.ids]) {
//                [cell.btnOfImageSelected setSelected:YES];
//
//            } else {
//                [cell.btnOfImageSelected setSelected:NO];
//
//            }
////            [cell.btnOfImageSelected setSelected:YES];
//        }
    
    }
    
    cell.delegate = self ;
    cell.index = indexPath ;
    return  cell ;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70.0 ;
}

-(void)addUser:(YPOAllUserList *)cell indexPathRow:(NSIndexPath *)indexPathRow {
    
    MOGoldMemberObject *obj ;
    if (isSearching) {
        obj = (MOGoldMemberObject *)[_searchResult objectAtIndex:indexPathRow.row];
    }else {
        obj = (MOGoldMemberObject *)[tempmasterObj.eventList objectAtIndex:indexPathRow.row];

    }
    if([cell.btnOfImageSelected isSelected]) //if the button is selected, deselect it, and then replace the "YES" in the array with "NO"
    {
        [_selectedButtonSearch addObject:obj.ids] ;
        [_selectedButton replaceObjectAtIndex:indexPathRow.row withObject:@"YES"];
        if ([_selectedButtonSearch containsObject:obj.ids]) {
            [cell.btnOfImageSelected setSelected:YES];
            
        } else {
            [cell.btnOfImageSelected setSelected:NO];
            
        }
//        [cell.btnOfImageSelected setSelected:YES];
        [self.selectedUserForGroup addObject:obj];

    }
    else if (![cell.btnOfImageSelected isSelected]) //if the button is unselected, select it, and then replace the "NO" in the array with "YES"
    {
        [_selectedButton replaceObjectAtIndex:indexPathRow.row withObject:@"NO"];
        if ([_selectedButtonSearch containsObject:obj.ids]) {
            [cell.btnOfImageSelected setSelected:YES];
            
        } else {
            [cell.btnOfImageSelected setSelected:NO];
            
        }
//        [cell.btnOfImageSelected setSelected:NO];
        [_selectedButtonSearch removeObject:obj.ids] ;
        [self.selectedUserForGroup removeObject:obj];

    }

    
    
}


@end
