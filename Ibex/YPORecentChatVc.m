//
//  YPORecentChatVc.m
//  YPO
//
//  Created by Ahmed Durrani on 12/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPORecentChatVc.h"
#import "Roaster+CoreDataClass.h"
#import "Chat+CoreDataClass.h"
#import "YPORecentCell.h"
#import "YPOChatViewController.h"
#import "AppDelegate.h"
#import "YPOGroupChatViewController.h"
#import "Utility.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+Badge.h"
#import "YPOCreateGroupVC.h"
#import "ChatRooms+CoreDataClass.h"
#import "GroupMessage+CoreDataClass.h"
#import "YPOGroupChatDetailVC.h"
#import "loginResponse.h"
#import "SVHTTPRequest.h"
#import "MORoom.h"
#import "UIImageView+AGCInitials.h"
#import "GroupChatMessageStatus+CoreDataClass.h"
#import "YPORecentCells.h"
#import "YPOAllUserListVC.h"
@interface YPORecentChatVc ()<UITableViewDelegate , UITableViewDataSource>
{
    Roaster *obj ;

    IBOutlet UIView *oneToOneChatView;
    AppDelegate *appdelegate ;
    IBOutlet UIView *goupChatView;
    NSArray *arrayOfCount ;
    NSArray *unReadMessage ;
    Chat *profile;
    GroupMessage *groupMessageProfile ;
    NSArray *arrayOfGroupMessageCount ;
    NSArray *unReadMessageOfGroup ;

    IBOutlet UIButton *btnRecent;
    
    IBOutlet UIButton *btnGroup;

    IBOutlet UIButton *btnGroupMember;
    
}
@property (strong, nonatomic) IBOutlet UITableView *recentListUserTableView;
@property (nonatomic , strong)NSMutableArray *arrayOfRecentUser ;
@property (nonatomic , strong)NSArray *arrayOfFilterUserInRecentChat ;

@property (nonatomic , strong)NSMutableArray *arrayOfMessageUnCount ;
@property (assign) BOOL isRecentChatOrGroup;
@property (nonatomic , strong)NSMutableArray *arrayOfGroupNumber ;
@property (nonatomic , strong)NSMutableArray *arrayOffilterUser ;
@property (nonatomic , strong)NSMutableArray *unReadMessageOfGroupMessage ;
@property (nonatomic , strong)NSMutableArray *jabberIdStringArray ;
@property (nonatomic , strong)NSMutableArray *arrayOfUnSorted ;




@end

@implementation YPORecentChatVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(messageReceived:)  name:kChatMessageReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(updateUI:)  name:KUpdateUIOfMessage object:nil];
    [NotifCentre addObserver:self selector:@selector(updateUIOfGroup:)  name:kGroupChatUIUpdate object:nil];
    [NotifCentre addObserver:self selector:@selector(CreateMessage:)  name:kGroupChatCreateMessage object:nil];
    [NotifCentre addObserver:self selector:@selector(messageRecivedOfGroup:)  name:kGroupChatMessageReceived object:nil];

    

    
    
    [btnRecent setSelected:true];
//    [btnGroupMember setHidden:true];
//    IBOutlet UIView *oneToOneChatView;
//    IBOutlet UIView *goupChatView;
    [oneToOneChatView setHidden:false] ;
    [goupChatView setHidden:true] ;
    if (_jabberIdOfPush){
        [self goToChatDetail];
    }
  
    // Do any additional setup after loading the view.
}

- (void)CreateMessage:(NSNotification*)notif
{
    YPOGroupChatDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGroupChatDetailVC"];
    ChatRooms *roomCheck = (ChatRooms *)notif.object ;
    
//    ChatRooms *checkList = (ChatRooms *)[self.arrayOfGroupNumber objectAtIndex:indexPath.row];
    vc.selectedRoom = roomCheck ;
    appdelegate.pushType = 1 ;
//    vc.pushType = 1 ;
    [self.navigationController pushViewController:vc animated:true];

}


- (void)notifiationReceiveced:(NSNotification*)notif
{
    _arrayOfMessageUnCount = [Chat fetchAll].mutableCopy ;
    [_recentListUserTableView reloadData];
}


- (void)updateUIOfGroup:(NSNotification*)notif
{
    
    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
    _unReadMessageOfGroupMessage = [GroupChatMessageStatus fetchAll].mutableCopy ;

    NSSortDescriptor *sortDescriptorOfGroup = [[NSSortDescriptor alloc] initWithKey:@"dateOfRecentMessage" ascending:NO];
    NSArray *orderedArrayOfGroup = [_arrayOfGroupNumber sortedArrayUsingDescriptors:@[sortDescriptorOfGroup]];
    //
    _arrayOfGroupNumber = [orderedArrayOfGroup mutableCopy];
    [_recentListUserTableView reloadData];
  
}

- (void)updateUI:(NSNotification*)notif
{
    
    _arrayOfRecentUser = [Roaster fetchAll].mutableCopy ;
    _unReadMessageOfGroupMessage = [GroupChatMessageStatus fetchAll].mutableCopy ;

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfRecentMessage" ascending:NO];
    NSArray *orderedArray = [_arrayOfRecentUser sortedArrayUsingDescriptors:@[sortDescriptor]];
    //
    _arrayOfRecentUser = [orderedArray mutableCopy];


    [_recentListUserTableView reloadData];

}

- (void)messageRecivedOfGroup:(NSNotification*)notif
{
    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
   
    [_recentListUserTableView reloadData];
    
}

- (void)messageReceived:(NSNotification*)notif
{
    
    _arrayOfRecentUser = [Roaster fetchAll].mutableCopy ;
    [_recentListUserTableView reloadData];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appdelegate.isViewVisible = true ;
    _arrayOfRecentUser = [[NSMutableArray alloc] init];
    _arrayOfGroupNumber = [[NSMutableArray alloc] init];
    _arrayOfFilterUserInRecentChat = [[NSArray alloc] init];
    _jabberIdStringArray   = [[NSMutableArray alloc] init];
    _arrayOfUnSorted = [[NSMutableArray alloc] init];
    
    _unReadMessageOfGroupMessage = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.isNotifyOfGroupChat = false ;

    _unReadMessageOfGroupMessage = [GroupChatMessageStatus fetchAll].mutableCopy ;
    _arrayOfMessageUnCount = [Chat fetchAll].mutableCopy ;
    arrayOfCount = [[NSArray alloc]init];
    unReadMessage = [[NSArray alloc]init];
    unReadMessageOfGroup = [[NSArray alloc] init];
    arrayOfGroupMessageCount = [[NSArray alloc] init];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *objOfUser = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"userJbID == %@", objOfUser.loginUserID] ;

    NSArray *arrayOfRecentGroupMember = [ChatRooms fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
    
    
    _arrayOfRecentUser = [Roaster fetchAll].mutableCopy ;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfRecentMessage" ascending:NO];
    NSArray *orderedArray = [_arrayOfRecentUser sortedArrayUsingDescriptors:@[sortDescriptor]];
    //
    _arrayOfRecentUser = [orderedArray mutableCopy];

    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
    
    NSSortDescriptor *sortDescriptorOfGroup = [[NSSortDescriptor alloc] initWithKey:@"dateOfRecentMessage" ascending:NO];
    NSArray *orderedArrayOfGroup = [_arrayOfGroupNumber sortedArrayUsingDescriptors:@[sortDescriptorOfGroup]];
    //
    _arrayOfGroupNumber = [orderedArrayOfGroup mutableCopy];
    
    [_recentListUserTableView reloadData];
}

-(void)goToChatDetail {
    NSPredicate *predicates  = [NSPredicate predicateWithFormat:@"roomJbID == %@", _jabberIdOfPush] ;
    NSArray *arrayOfPush = [ChatRooms fetchWithPredicate:predicates sortDescriptor:nil fetchLimit:0];
    YPOGroupChatDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGroupChatDetailVC"];
    ChatRooms *checkList = (ChatRooms *)[arrayOfPush objectAtIndex:0];
    vc.selectedRoom = checkList ;
    _jabberIdOfPush  = nil ;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btnRecentChat_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [btnRecent setSelected:true];
    [btnGroup setSelected:false];
    _isRecentChatOrGroup = false ;
    
    
//    _arrayOfFilterUserInRecentChat = [Roaster fetchAll] ;
//
//    for (int i = 0;  i < _arrayOfFilterUserInRecentChat.count; i++) {
//
//        Roaster *obj = [_arrayOfFilterUserInRecentChat objectAtIndex:i];
//        NSString *checkValue = obj.jaber_ID ;
//        if ([_jabberIdStringArray containsObject :checkValue]) {
//            NSLog(@"added");
//        } else {
//            [_jabberIdStringArray addObject:checkValue];
//            [_arrayOfRecentUser addObject:obj];
//        }
//
//        [_recentListUserTableView reloadData];


//    _arrayOfRecentUser = [Roaster fetchAll].mutableCopy ;
    _arrayOfRecentUser = [Roaster fetchAll].mutableCopy ;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfRecentMessage" ascending:NO];
    NSArray *orderedArray = [_arrayOfRecentUser sortedArrayUsingDescriptors:@[sortDescriptor]];
    //
    _arrayOfRecentUser = [orderedArray mutableCopy];

    [_recentListUserTableView reloadData];
    [btnGroupMember setHidden:false];
    [oneToOneChatView setHidden:false] ;
    [goupChatView setHidden:true] ;

    }

    
    
//}
- (IBAction)btnGroupChat_Pressed:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    [btnGroup setSelected:true];
    [btnRecent setSelected:false];
    _isRecentChatOrGroup = true ;
//    _arrayOfGroupNumber = [[NSMutableArray alloc] init];
    [btnGroupMember setHidden:false];

//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//
//    loginResponse *objOfUser = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//
    
    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
    _unReadMessageOfGroupMessage = [GroupChatMessageStatus fetchAll].mutableCopy ;
    
    NSSortDescriptor *sortDescriptorOfGroup = [[NSSortDescriptor alloc] initWithKey:@"dateOfRecentMessage" ascending:NO];
    NSArray *orderedArrayOfGroup = [_arrayOfGroupNumber sortedArrayUsingDescriptors:@[sortDescriptorOfGroup]];
    //
    _arrayOfGroupNumber = [orderedArrayOfGroup mutableCopy];

    
////    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
//    NSSortDescriptor *sortDescriptorOfGroup = [[NSSortDescriptor alloc] initWithKey:@"dateOfRecentMessage" ascending:NO];
//    NSArray *orderedArrayOfGroup = [_arrayOfGroupNumber sortedArrayUsingDescriptors:@[sortDescriptorOfGroup]];
//    //
//    _arrayOfGroupNumber = [orderedArrayOfGroup mutableCopy];
//
//    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;

    
//    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
    [_recentListUserTableView reloadData];
    [oneToOneChatView setHidden:true] ;
    [goupChatView setHidden:false] ;


    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Chats Users List Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnCreateChatRoom:(UIButton *)sender {
    if (_isRecentChatOrGroup == false ){
        YPOAllUserListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOAllUserListVC"] ;
        [self.navigationController pushViewController:vc animated:true];

    } else {
        YPOCreateGroupVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOCreateGroupVC"];
        [self.navigationController pushViewController:vc animated:true];

    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_isRecentChatOrGroup == false) {
        NSInteger numOfSections = 0;
        if (_arrayOfRecentUser.count >0)
        {
            numOfSections                = 1;
            _recentListUserTableView.backgroundView = nil;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _recentListUserTableView.bounds.size.width, _recentListUserTableView.bounds.size.height)];
            [noDataLabel setNumberOfLines:10];
            noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
            noDataLabel.text             = @"There are currently no data.";
            noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            _recentListUserTableView.backgroundView = noDataLabel;
            _recentListUserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        return numOfSections;
    } else {
        NSInteger numOfSections = 0;
        if (_arrayOfGroupNumber.count >0)
        {
            numOfSections                = 1;
            _recentListUserTableView.backgroundView = nil;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _recentListUserTableView.bounds.size.width, _recentListUserTableView.bounds.size.height)];
            [noDataLabel setNumberOfLines:10];
            noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
            noDataLabel.text             = @"There are currently no data.";
            noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            _recentListUserTableView.backgroundView = noDataLabel;
            _recentListUserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        return numOfSections;
    }
    
  
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (_isRecentChatOrGroup == false){
        return self.arrayOfRecentUser.count ;

    } else {
        return  self.arrayOfGroupNumber.count ;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPORecentCell *cell = (YPORecentCell *)[tableView dequeueReusableCellWithIdentifier:@"YPORecentCell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    if (_isRecentChatOrGroup == false){
        Roaster *checkList = (Roaster *)[self.arrayOfRecentUser objectAtIndex:indexPath.row];
        if (self.arrayOfRecentUser.count > 0) {
            profile = [Chat fetchWithPredicate:[NSPredicate predicateWithFormat:@"from_Jabber == %@",checkList.jaber_ID] sortDescriptor:nil fetchLimit:0].lastObject;
        }
        arrayOfCount = [[NSArray alloc]init];
        unReadMessage = [[NSArray alloc]init];
        
        arrayOfCount  = [_arrayOfMessageUnCount filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"from_Jabber == %@", checkList.jaber_ID]];
        unReadMessage = [arrayOfCount filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"messageStatus == %@", @"Unread"]];
        if (unReadMessage.count > 0){
            [cell.btnNotificationDisplay setHidden:false];
            NSInteger badgeCount = unReadMessage.count ;
            [cell.btnNotificationDisplay setTitle:[NSString stringWithFormat:@"%ld", badgeCount] forState:UIControlStateNormal];
            //        cell.btnNotificationDisplay.badgeValue = [NSString stringWithFormat:@"%ld", (long)badgeCount];
        } else {
            [cell.btnNotificationDisplay setHidden:true];
        }
        NSString *imageURLString = [Utility getProductUrlForProductImagePath:checkList.sender_Image];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [cell.imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:cell.imageOfUser radius:cell.imageOfUser.frame.size.width/2];
        cell.lblLastMessage.text =  checkList.lastMessage ;
//        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//        //    NSDate *date = [outputFormatter dateFromString:dateTime];
//        [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//        //    [outputFormatter setDateFormat:@"HH:mm"];
//        NSDate * now = checkList.dateOfRecentMessage ;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *localDateString = [dateFormatter stringFromDate:checkList.dateOfRecentMessage];
        NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:localDateString];
        cell.lblDate.text = timeAgoFormattedDate ;
        cell.lblUserName.text = checkList.sender_Name ;
//        if (checkList.senderAndReceiverName == nil) {
//            cell.lblUserName.text = checkList.sender_Name  ;
//
//        } else {
//            cell.lblUserName.text = checkList.senderAndReceiverName ;
//
//        }
        return  cell ;
    } else {
        ChatRooms *checkList = (ChatRooms *)[self.arrayOfGroupNumber objectAtIndex:indexPath.row];
        if (self.arrayOfGroupNumber.count > 0) {
            groupMessageProfile = [GroupMessage fetchWithPredicate:[NSPredicate predicateWithFormat:@"group_Jabber_Id == %@",checkList.roomJbID] sortDescriptor:nil fetchLimit:0].lastObject;
        }
        
        if (self.unReadMessageOfGroupMessage.count > 0){
            
//            NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"jabberIdOfUser == %@" , checkList.roomJbID] ;
            
            arrayOfGroupMessageCount  = [_unReadMessageOfGroupMessage filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"jabberIdOfUser == %@", checkList.roomJbID]];
            unReadMessageOfGroup = [arrayOfGroupMessageCount filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"messageStatus == %@", @"Unread"]];
            if (unReadMessageOfGroup.count > 0 ){
                [cell.btnNotificationDisplay setHidden:false];
                NSInteger badgeCount = unReadMessageOfGroup.count ;
                [cell.btnNotificationDisplay setTitle:[NSString stringWithFormat:@"%ld", (long)badgeCount] forState:UIControlStateNormal];

            
            } else  {
                [cell.btnNotificationDisplay setHidden:true];

            }
            
//            NSArray *arrayOfRecentUser = [GroupChatMessageStatus fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];

        }
        else {
            [cell.btnNotificationDisplay setHidden:true];

        }
        
//      [cell.btnNotificationDisplay setHidden:true];
        cell.lblLastMessage.text =  checkList.lastMessage ;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *localDateString = [dateFormatter stringFromDate:checkList.dateOfRecentMessage];
        NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:localDateString];

//        NSString *mysqlDatetime = groupMessageProfile.dateAndTimeOfMessage ;
//        NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];
        cell.lblDate.text = timeAgoFormattedDate ;
        cell.lblUserName.text = checkList.room_Name ;
        [cell.imageOfUser agc_setImageWithInitialsFromName:checkList.room_Name];
        [Utility setViewCornerRadius:cell.imageOfUser radius:cell.imageOfUser.frame.size.width/2];
        return  cell ;
        
        
    }
    
   
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isRecentChatOrGroup == false ){
        YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
        Roaster *checkList = (Roaster *)[self.arrayOfRecentUser objectAtIndex:indexPath.row];

//        Roaster *checkList = (Roaster *)[self.arrayOfRecentUser objectAtIndex:indexPath.row];
        profile = [Chat fetchWithPredicate:[NSPredicate predicateWithFormat:@"from_Jabber == %@",checkList.jaber_ID] sortDescriptor:nil fetchLimit:0].lastObject;
        vc.userSelectedChat = profile ;
        vc.selectedUser  = checkList ;
        vc.pushTypeGoldOrYpoMember = 2 ;
        [self.navigationController pushViewController:vc animated:true];

    } else {
        
        YPOGroupChatDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGroupChatDetailVC"];
        
        ChatRooms *checkList = (ChatRooms *)[self.arrayOfGroupNumber objectAtIndex:indexPath.row];
        vc.selectedRoom = checkList ;
        appdelegate.pushType = 2 ;
        [self.navigationController pushViewController:vc animated:true];

    }
   
    
    
}





@end
