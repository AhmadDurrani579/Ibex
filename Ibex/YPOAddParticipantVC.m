//
//  YPOAddParticipantVC.m
//  YPO
//
//  Created by Ahmed Durrani on 25/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOAddParticipantVC.h"
#import <CFNetwork/CFNetwork.h>
#import <CoreData/CoreData.h>
#import "DDTTYLogger.h"
#import "ChatManager.h"
#import "NSDate-Key.h"
#import "DDLog.h"
// XMPP Classes
#import "XMPP.h"
#import "XMPPPing.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "GCDAsyncSocket.h"
#import "XMPPRoomMemoryStorage.h"
#import "XMPPRoom.h"
#import "MOGoldMember.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "YPOAllUserList.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "MOGoldMemberObject.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "DBChatManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SVHTTPRequest.h"

@interface YPOAddParticipantVC () <UITableViewDelegate , UITableViewDataSource ,selectUserDelegate>
{
    MOGoldMember *tempmasterObj;
    AppDelegate *appDelegate ;
    BOOL isSearching;
    __weak IBOutlet UISearchBar     *searchContacts;


}
@property(nonatomic , strong) NSMutableArray *selectedButton ;
@property(nonatomic , strong) NSMutableArray *selectedUser ;
@property (strong, nonatomic)  NSMutableArray *selectedUserForGroup;

@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property(strong , nonatomic) NSMutableArray *addUserList ;
@property(strong , nonatomic) NSMutableArray *selectUserName ;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSArray* letters;


@end

@implementation YPOAddParticipantVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedUserForGroup = [[NSMutableArray alloc] init] ;
    appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
    searchContacts.placeholder = @"Search the Member" ;


    _addUserList = [[NSMutableArray alloc] init];
    _selectUserName = [[NSMutableArray alloc] init];
    
    _selectedButton = [[NSMutableArray alloc]init];
    _selectedUser = [[NSMutableArray alloc] init];
    [self getALlSearchList];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    if (appDelegate.groupsMembers_Detail.count > 0) {
        NSString *userId = [_addUserList componentsJoinedByString:@","];
        [self.delegate userArray:userId];
        [self.navigationController popViewControllerAnimated:true];
        
    } else {
        [self.navigationController popViewControllerAnimated:true];

    }
    
}

-(void)getALlSearchList
{
    [[Webclient sharedWeatherHTTPClient] getAllUserList:@"" viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (MOGoldMember*) responseObject;
        [self updateTableData:@""];

        //        [self updateTableData:@""];
        
        //        MOGoldMember
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            //[tvEvents reloadData];
            
            for (int i = 0; i< tempmasterObj.eventList.count; i++) //yourTableSize = how many rows u got
            {
                [_selectedButton addObject:@"NO"];
            }
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
           value:@"Invite User In Group Screen"];
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
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self updateTableData:searchText];
    }
    else {
        [self updateTableData:@""];
        
        //        isSearching = NO;
    }
   
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


- (IBAction)btnInviteUser:(UIButton *)sender {
    
    [SVProgressHUD show];
    
    if (self.addUserList.count <= 50) {
        for (int i = 0 ; i < self.addUserList.count; i++) {
            NSString *myJID ;
            NSString *idOfSelectedUser = self.addUserList[i];
            XMPPRoomMemoryStorage *roomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
            myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", idOfSelectedUser];
            XMPPJID *inviteUserJbID = [XMPPJID  jidWithString:myJID];
            XMPPJID *roomJID = [XMPPJID jidWithString:self.selectedRoom.roomJbID];
            XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomMemoryStorage
                                                                   jid:roomJID dispatchQueue:dispatch_get_main_queue()];
            [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
            [xmppRoom activate:[SharedDBChatManager xmppStream]];
            [xmppRoom editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"member" jid:inviteUserJbID]]];
            [xmppRoom inviteUser:inviteUserJbID withMessage:self.selectedRoom.room_Name];
            [self sendPushNotificatin];
            
        }
        
        [SVProgressHUD dismiss] ;
        
        [NotifCentre postNotificationName:kGroupChatAddUSer object:_selectedUser];
        
        NSString *userId = [_addUserList componentsJoinedByString:@","];
        [self.delegate userArray:userId];
        [self.navigationController popViewControllerAnimated:true];

    } else {
        [self showAlertViewWithTitle:@"ALERT" message:@"Group member not exceed from 50"];

    }
   

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
        return _letters;
        
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_letters indexOfObject:title];
        
}

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
        _tblView.backgroundView      = noDataLabel;
        _tblView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    }
    
    return _letters.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSString* letter = [_letters objectAtIndex:section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
    return arrayForLetter.count;

}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//{
//    return tempmasterObj.eventList.count;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOAllUserList *cell = (YPOAllUserList *)[tableView dequeueReusableCellWithIdentifier:@"YPOAllUserList"];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userObj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    
    if (tempmasterObj.eventList.count > 0){
        NSString* letter = [_letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];

        MOGoldMemberObject *obj = (MOGoldMemberObject *)[arrayForLetter objectAtIndex:indexPath.row];
        
        if ([_groupUserId containsObject:obj.ids]) {
            [cell.btnOfImageSelected setSelected:YES];
            [_selectedButton replaceObjectAtIndex:indexPath.row withObject:@"YES"];
            [cell.btnOfImageSelected setUserInteractionEnabled:false];

        }else {
//            [cell.btnOfImageSelected setSelected:false];
            [cell.btnOfImageSelected setSelected:NO];
            [_selectedButton replaceObjectAtIndex:indexPath.row withObject:@"NO"];

            [cell.btnOfImageSelected setUserInteractionEnabled:true];


        }
        
//        if ([obj.ids isEqualToString:userObj.loginUserID]) {
//            [cell.btnOfImageSelected setHidden:true];
//
//
//        } else {
//            [cell.btnOfImageSelected setHidden:false];
//
//        }
        
        
        
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
        
        if([[_selectedButton objectAtIndex:indexPath.row]isEqualToString:@"NO"])
        {
            [cell.btnOfImageSelected setSelected:NO];
        }
        else
        {
            [cell.btnOfImageSelected setSelected:YES];
        }
        
    }
    
    cell.delegate = self ;
    cell.index = indexPath ;
    return  cell ;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70.0 ;
}

//static XMPPJID * extracted(XMPPJID *inviteUserJbID) {
//    return [XMPPJID jidWithString:inviteUserJbID];
//}

//-(void)sendPushNotificatin:(NSString*)message{
//
//
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//
//    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//    message = [NSString stringWithFormat:@"%@ %@", obj.loginDisplayName,@"invited you for this group"] ;
//    NSString *receiverIDs = [_selectedUser componentsJoinedByString:@","];
//
//
//    NSDictionary *params = nil;
//    params =        @{@"SenderId"                :     obj.loginUserID,
//                      @"SenderName"              :     _txtGroupName.text,
//                      @"RecieverId"              :     receiverIDs ,
//                      @"Message"                 :     message ,
//                      @"SentDate"                :     @"" ,
//                      @"IsChat"                  :     @"true"
//                      };
//
//
//
//    [SVHTTPRequest POST:KBaseUrlForNotification parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        if (!error) {
//
//            NSDictionary *dict = (NSDictionary*)response;
//            NSLog(@"what's here %@",dict);
//
//        }
//        else{
//
//            NSLog(@"what's here %@",error.description);
//
//
//        }
//
//    }];
//
//}


-(void)addUser:(YPOAllUserList *)cell indexPathRow:(NSIndexPath *)indexPathRow {
    NSString* letter = [_letters objectAtIndex:indexPathRow.section];
    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
//    MOGoldMemberObject *goldMember  =  (MOGoldMemberObject *)[arrayForLetter objectAtIndex:indexPathRow.row];

    MOGoldMemberObject *obj  =  (MOGoldMemberObject *)[arrayForLetter objectAtIndex:indexPathRow.row];
    
    //    int x =   (int)cell.btnOfImageSelected.tag - (int)cell.index.row ;     //get the table's row
    if([cell.btnOfImageSelected isSelected]) //if the button is selected, deselect it, and then replace the "YES" in the array with "NO"
    {
//        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//        loginResponse *userObj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
        
        
        appDelegate.isUserAddOrDelete = true ;
        [appDelegate.groupsMembers_Detail addObject:obj.ids];
        [_addUserList addObject:obj.ids];
        [_selectedButton replaceObjectAtIndex:indexPathRow.row withObject:@"YES"];
        [_selectedUser addObject:[NSString stringWithFormat:@"%@ %@", obj.firstName ,obj.lastName]];
        [cell.btnOfImageSelected setSelected:YES];
//        [self.selectedUserForGroup addObject:obj];
//         XMPPRoomMemoryStorage *roomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
//
//            NSString *myJID ;
//
//            myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", obj.ids];
//            XMPPJID *inviteUserJbID = [XMPPJID  jidWithString:myJID];
//            XMPPJID *roomJID = [XMPPJID jidWithString:self.selectedRoom.roomJbID];
//            XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomMemoryStorage
//                                jid:roomJID dispatchQueue:dispatch_get_main_queue()];
//            [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
//            [xmppRoom activate:[SharedDBChatManager xmppStream]];
////
//            [xmppRoom editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"member" jid:inviteUserJbID]]];
//            [xmppRoom inviteUser:inviteUserJbID withMessage:@"Ypu are Invite"];
//
//
//
//
//            [self sendPushNotificatin:[NSString stringWithFormat:@"%@", obj.ids]];
        
        
    }
    else if (![cell.btnOfImageSelected isSelected]) //if the button is unselected, select it, and then replace the "NO" in the array with "YES"
    {
        [_selectedButton replaceObjectAtIndex:indexPathRow.row withObject:@"NO"];
        [cell.btnOfImageSelected setSelected:NO];
        [appDelegate.groupsMembers_Detail removeObject:obj.ids];
        [_addUserList removeObject:obj.ids];
        [_selectedUser addObject:[NSString stringWithFormat:@"%@ %@", obj.firstName ,obj.lastName]];
        [_selectedUser removeObject:[NSString stringWithFormat:@"%@ %@", obj.firstName ,obj.lastName]];

//        [self.selectedUserForGroup removeObject:obj];
        
    }
    
    
    
}

//-(void)sendPushNotificatin:(NSString*)message{
//
//
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//
//    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//    if ([_groupMembersID containsObject:obj.loginUserID]){
//        [_groupMembersID removeObject:obj.loginUserID];
//
//    }
//
//    NSString *receiverIDs = [_groupMembersID componentsJoinedByString:@","];
//
//
//    NSString *txtString = [NSString stringWithFormat:@"@%@: %@", obj.loginDisplayName , message];
//
//    NSDictionary *params = nil;
//
//    params =         @{@"SenderId"               :     obj.loginUserID,
//                       @"SenderName"              :     obj.loginDisplayName,
//                       @"RecieverId"              :     receiverIDs,
//                       @"Message"                 :     txtString ,
//                       @"SentDate"                :     @"" ,
//                       @"IsChat"                  :     @"true" ,
//                       @"groupId"                 :     _selectedRoom.roomJbID ,
//                       @"GroupName"               :     _selectedRoom.room_Name
//                       };
//
//    [SVHTTPRequest POST:KBaseUrlForNotification parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        if (!error) {
//
//            NSDictionary *dict = (NSDictionary*)response;
//            //            NSLog(@"what's here %@",dict);
//
//
//
//        }
//        else{
//
//            //            NSLog(@"what's here %@",error.description);
//
//
//        }
//
//    }];
//}

-(void)sendPushNotificatin {
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSString *message = [NSString stringWithFormat:@"%@ %@", self.ownerName,@"invited you for this group"] ;
    if ([_addUserList containsObject:obj.loginUserID]){
        [_addUserList removeObject:obj.loginUserID];

    }

    NSString *userId = [_addUserList componentsJoinedByString:@","];

  
    
    NSDictionary *params = nil;
    params =        @{@"SenderId"                :     self.adMinId,
                      @"SenderName"              :     self.selectedRoom.room_Name ,
                      @"RecieverId"              :     userId ,
                      @"Message"                 :     message ,
                      @"SentDate"                :     @"" ,
                      @"IsChat"                  :     @"true",
                      @"GroupName"               :     self.roomName ,
                      @"groupId"                 :     self.selectedRoom.roomJbID
                      };
    [SVProgressHUD show];
    [SVHTTPRequest POST:KBaseUrlForNotification parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [SVProgressHUD dismiss];

        if (!error) {
            NSDictionary *dict = (NSDictionary*)response;
            NSLog(@"what's here %@",dict);
        }
        else{
            
            NSLog(@"what's here %@",error.description);
            
            
        }
        
    }];
    
}


@end
