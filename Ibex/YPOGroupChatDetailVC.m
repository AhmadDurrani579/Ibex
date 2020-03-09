//
//  YPOGroupChatDetailVC.m
//  YPO
//
//  Created by Ahmed Durrani on 22/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOGroupChatDetailVC.h"
#import "XMPPRoom.h"
#import "XMPP.h"
#import "XMPPPing.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "GCDAsyncSocket.h"
#import "XMPPRoomMemoryStorage.h"
#import "DBChatManager.h"
#import "CSGrowingTextView.h"
#import "GroupMessage+CoreDataClass.h"
#import "YPOReceiverCell.h"
#import "YPOSenderCell.h"
#import "YPOGroupReceiverCell.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "loginResponse.h"
#import "Utility.h"
#import "UIViewController+Helper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SVHTTPRequest.h"
#import "MORoom.h"
#import "GroupChatMessageStatus+CoreDataClass.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking/AFNetworking.h"
#import "UIImage+ImageCompress.h"
#import "YPOSenderPhotoCell.h"
#import "YPOReceiverPhotoCell.h"
#import "IDMPhotoBrowser.h"
#import "IDMPhoto.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "YPOGroupMessageSenderCell.h"
#import "YPOSenderImageGroup.h"
#import "YPOReceiverGroupImage.h"
#import "YPOGroupDetailVc.h"
#import "YPOLeftGroupCell.h"
@interface YPOGroupChatDetailVC ()<CSGrowingTextViewDelegate , UIActionSheetDelegate , PhotoBrowserOfGroupReceiver>
{
    NSString *ownerRoomName ;
    AppDelegate *app ;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet CSGrowingTextView *growingTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *growingTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tbleView;
@property (nonatomic,strong) XMPPRoom *myroom;
@property (nonatomic,assign) BOOL isAlreadyJoined ;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UILabel *titleOfGroup;
@property (strong, nonatomic) NSMutableArray *occupentArray;
@property (strong, nonatomic) NSMutableArray *allUserListInRoom;
@property (strong, nonatomic) NSMutableArray *members;
@property (strong, nonatomic) NSMutableArray *groupsMembersArray;
@property (strong, nonatomic) NSMutableArray *userAddInGroup;

@property (strong, nonatomic) IBOutlet UIButton *btnSendMessage_Pressed;
@property (strong, nonatomic) IBOutlet UIButton *btnLeaveOrDeleteGroup;
@property (strong, nonatomic) IBOutlet UIButton *btnAttachment;
@property (strong, nonatomic) IBOutlet UIView *viewOfGroup;
@property (strong, nonatomic) IBOutlet UILabel *titleOfDeleteOrLeave;

@property(nonatomic , strong) GroupMessage *userSelectedChat ;
@property (strong, nonatomic) IBOutlet UIButton *btnGroupDetail;
@property(nonatomic , strong) ChatRooms *userSelectRoom ;



@end

@implementation YPOGroupChatDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    self.dataArray = [[NSMutableArray alloc] init];
    _occupentArray = [[NSMutableArray alloc] init];
    _allUserListInRoom = [[NSMutableArray alloc] init];
    _members    = [[NSMutableArray alloc] init];
    _groupsMembersArray = [[NSMutableArray alloc] init];
    _userAddInGroup = [[NSMutableArray alloc] init] ;
    
    _titleOfGroup.text = self.selectedRoom.room_Name ;
    
    NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"group_Jabber_Id == %@" , self.selectedRoom.roomJbID] ;
//    [GroupMessage save];
    
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOSenderCell" bundle:nil] forCellReuseIdentifier:@"YPOSenderCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOReceiverCell" bundle:nil] forCellReuseIdentifier:@"YPOReceiverCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOGroupReceiverCell" bundle:nil] forCellReuseIdentifier:@"YPOGroupReceiverCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOSenderPhotoCell" bundle:nil] forCellReuseIdentifier:@"YPOSenderPhotoCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOReceiverPhotoCell" bundle:nil] forCellReuseIdentifier:@"YPOReceiverPhotoCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOGroupMessageSenderCell" bundle:nil] forCellReuseIdentifier:@"YPOGroupMessageSenderCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOSenderImageGroup" bundle:nil] forCellReuseIdentifier:@"YPOSenderImageGroup"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOReceiverGroupImage" bundle:nil] forCellReuseIdentifier:@"YPOReceiverGroupImage"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOLeftGroupCell" bundle:nil] forCellReuseIdentifier:@"YPOLeftGroupCell"];
    self.growingTextView.placeholderLabel.textColor = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1.0];
    
  
    
//    [self fetchMembersList];
    self.growingTextView.placeholderLabel.text = @"Type a message" ;
    NSPredicate *pred  = [NSPredicate predicateWithFormat:@"jabberIdOfUser == %@" , _selectedRoom.roomJbID] ;
    NSArray *arrayOfGroupMessage = [GroupChatMessageStatus fetchWithPredicate:pred sortDescriptor:nil fetchLimit:0];
    
    
    for (_messageStatusOfGroup in arrayOfGroupMessage) {

        _messageStatusOfGroup.messageStatus = @"read" ;
    }
    [GroupChatMessageStatus save];

    
    [Utility setViewBorder:self.growingTextView withWidth:2 andColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0]];
    self.growingTextView.delegate = self;

    _tbleView.rowHeight = UITableViewAutomaticDimension ;
    _tbleView.estimatedRowHeight = 100 ;
//    self.dataArray = [GroupMessage fetchAll].mutableCopy ;
    
    NSArray *arrayOfMEssages = [GroupMessage fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
    self.dataArray = [arrayOfMEssages mutableCopy];
    if (self.dataArray.count == 0) {
//        [self.viewOfGroup setHidden:false];
//        [titleOfDeleteOrLeave setText:[NSString stringWithFormat:@""]]
    }
    
    if (self.dataArray.count > 0) {
        [self.tbleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationFade];
    }
    
    [NotifCentre addObserver:self selector:@selector(userLeaveGroup:)  name:kGroupChatUserLeave object:nil];
    [NotifCentre addObserver:self selector:@selector(userBlockOnGroup:)  name:kGroupChatUserBock object:nil];
    [NotifCentre addObserver:self selector:@selector(userAdd:)  name:kGroupChatAddUSer object:nil];
    [NotifCentre addObserver:self selector:@selector(messageReceived:)  name:kGroupChatMessageReceived object:nil];
}
-(void)groupCreate  {
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if([Utility connectedToNetwork]){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            XMPPMessage *message = [[XMPPMessage alloc]init];
            
            
            NSString *text = [NSString stringWithFormat:@"%@ %@",obj.loginDisplayName, @"Created the group"];
            
            NSString *str = [SharedDBChatManager xmppStream].generateUUID ;
            
            NSXMLElement *attachment = [NSXMLElement elementWithName:@"msg_extras" xmlns:@"org.ypo"];
            NSXMLElement *senderName ;
            NSXMLElement *senderIDs ;
            NSXMLElement *senderImage ;
            NSXMLElement *senderID ;
            NSXMLElement *group_id ;
            NSXMLElement *message_Type ;
            NSXMLElement *actionUser_id ;
            NSXMLElement *action_Id ;


//            GROUPCREATED
//            actioned_user_id
//            actioned_user_name
//            action_id
            
            senderImage =      [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
            senderID    =      [NSXMLElement elementWithName:@"id" stringValue: str];
            group_id    =      [NSXMLElement elementWithName:@"group_id" stringValue: _selectedRoom.roomJbID];
            senderIDs    =     [NSXMLElement elementWithName:@"sender_id" stringValue: obj.loginUserID];
            senderName  =      [NSXMLElement elementWithName:@"sender_name" stringValue: obj.loginDisplayName];
            message_Type =     [NSXMLElement elementWithName:@"msg_type" stringValue: @"3"] ;
            actionUser_id =     [NSXMLElement elementWithName:@"actioned_user_id" stringValue: obj.loginUserID] ;
            action_Id     =     [NSXMLElement elementWithName:@"action_id" stringValue: @"5"] ;

            [attachment addChild:senderName];
            [attachment addChild:senderID];
            [attachment addChild:senderImage];
            [attachment addChild:senderIDs];
            [attachment addChild:message_Type];
            [attachment addChild:group_id];
            [attachment addChild:actionUser_id];
            [attachment addChild:action_Id];

            [message    addBody:text];
            [message    addChild:attachment];
            [self.myroom sendMessage:message];
         
            
            
        } else {
            [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
        }
        
        
    });
    
}


-(void)userAdd :(NSNotification *)notify {
    
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if([Utility connectedToNetwork]){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            XMPPMessage *message = [[XMPPMessage alloc]init];
            
            _userAddInGroup = notify.object ;
            NSString *userName = [_userAddInGroup componentsJoinedByString:@","];

            NSString *text = [NSString stringWithFormat:@"%@ %@",userName, @"added in this group"];
          
            NSString *str = [SharedDBChatManager xmppStream].generateUUID ;
            
            NSXMLElement *attachment = [NSXMLElement elementWithName:@"msg_extras" xmlns:@"org.ypo"];
            NSXMLElement *senderName ;
            NSXMLElement *senderIDs ;
            NSXMLElement *senderImage ;
            NSXMLElement *senderID ;
            NSXMLElement *group_id ;
            NSXMLElement *message_Type ;
            NSXMLElement *action_Id ;
            NSXMLElement *actionUser_id ;

            
            
            
            senderImage =       [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
            senderID    =       [NSXMLElement elementWithName:@"id" stringValue: str];
            group_id    =       [NSXMLElement elementWithName:@"group_id" stringValue: _selectedRoom.roomJbID];
            senderIDs    =      [NSXMLElement elementWithName:@"sender_id" stringValue: obj.loginUserID];
            senderName   =      [NSXMLElement elementWithName:@"sender_name" stringValue: obj.loginDisplayName];
            message_Type =      [NSXMLElement elementWithName:@"msg_type" stringValue: @"3"] ;
            actionUser_id =     [NSXMLElement elementWithName:@"actioned_user_id" stringValue: userName] ;
            action_Id     =     [NSXMLElement elementWithName:@"action_id" stringValue: @"0"] ;

            
//            typeOfJoint  =     [NSXMLElement elementWithName:@"action_id" stringValue: @"0"] ;
//            actionUser_id  =   [NSXMLElement elementWithName:@"actioned_user_id" stringValue: userName] ;

            [attachment addChild:senderName];
            [attachment addChild:senderID];
            [attachment addChild:senderImage];
            [attachment addChild:senderIDs];
            [attachment addChild:message_Type];
            [attachment addChild:group_id];
            [attachment addChild:action_Id];
            [attachment addChild:actionUser_id];


            [message    addBody:text];
            [message    addChild:attachment];
            [self.myroom sendMessage:message];
         
            
        } else {
            [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
        }
        
        
    });
    
}


-(void)userLeaveGroup :(NSNotification *)notify {
    
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if([Utility connectedToNetwork]){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            XMPPMessage *message = [[XMPPMessage alloc]init];
            NSString *text ;
            EventSpeakerModel *userInfo = (EventSpeakerModel *)notify.object ;
            if (app.isUserLeaveOrBlock == true){
                text = [NSString stringWithFormat:@"%@ %@ %@ %@",app.groupAdminName,@"removed",userInfo.speakerFirstName, userInfo.speakerLastName] ; // enter the text in text field
//                appDelegate.groupAdminName
                
            } else {
                text = [NSString stringWithFormat:@"%@ %@", obj.loginDisplayName ,@"has left the group"] ; // enter the text in text field
                
            }
            //            NSString *text = [NSString stringWithFormat:@"%@ %@", obj.loginDisplayName ,@"has left the group"] ; // enter the text in text field
            NSString *str = [SharedDBChatManager xmppStream].generateUUID ;
            
            NSXMLElement *attachment = [NSXMLElement elementWithName:@"msg_extras" xmlns:@"org.ypo"];
            NSXMLElement *senderName ;
            NSXMLElement *senderIDs ;
            NSXMLElement *senderImage ;
            NSXMLElement *senderID ;
            NSXMLElement *group_id ;
            NSXMLElement *message_Type ;
            NSXMLElement *actionUser_id ;
            NSXMLElement *action_Id ;

            
            senderImage =      [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
            senderID    =      [NSXMLElement elementWithName:@"id" stringValue: str];
            group_id    =      [NSXMLElement elementWithName:@"group_id" stringValue: _selectedRoom.roomJbID];
            senderIDs    =     [NSXMLElement elementWithName:@"sender_id" stringValue: obj.loginUserID];
            senderName  =      [NSXMLElement elementWithName:@"sender_name" stringValue: obj.loginDisplayName];
            message_Type =     [NSXMLElement elementWithName:@"msg_type" stringValue: @"3"] ;
            actionUser_id =     [NSXMLElement elementWithName:@"actioned_user_id" stringValue: obj.loginUserID] ;
            action_Id     =     [NSXMLElement elementWithName:@"action_id" stringValue: @"2"] ;

            [attachment addChild:senderName];
            [attachment addChild:senderID];
            [attachment addChild:senderImage];
            [attachment addChild:senderIDs];
            [attachment addChild:message_Type];
            [attachment addChild:group_id];
            [attachment addChild:actionUser_id];
            [attachment addChild:action_Id];

            [message    addBody:text];
            [message    addChild:attachment];
            [self.myroom sendMessage:message];
            
            
         
            
            
            
            
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
//
//            });
            
            
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //                [self sendPushNotificatin:text];
            //
            //            });
            //            self.growingTextView.internalTextView.text = @"";
            //            self.growingTextView.placeholderLabel.text = @"Type a message" ;
            
            
            
            
        } else {
            [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
        }

    
    });
    
}

-(void)userBlockOnGroup :(NSNotification *)notify {
    
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if([Utility connectedToNetwork]){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            XMPPMessage *message = [[XMPPMessage alloc]init];
            NSString *text ;
            EventSpeakerModel *userInfo = (EventSpeakerModel *)notify.object ;
//            if (app.isUserLeaveOrBlock == true){
                text = [NSString stringWithFormat:@"%@ %@ %@ %@",app.groupAdminName,@"removed",userInfo.speakerFirstName, userInfo.speakerLastName] ; // enter the text in text field
                //                appDelegate.groupAdminName
                
//            } else {
//                text = [NSString stringWithFormat:@"%@ %@", obj.loginDisplayName ,@"has left the group"] ; // enter the text in text field
//
//            }
            //            NSString *text = [NSString stringWithFormat:@"%@ %@", obj.loginDisplayName ,@"has left the group"] ; // enter the text in text field
            NSString *str = [SharedDBChatManager xmppStream].generateUUID ;
            
            NSXMLElement *attachment = [NSXMLElement elementWithName:@"msg_extras" xmlns:@"org.ypo"];
            NSXMLElement *senderName ;
            NSXMLElement *senderIDs ;
            NSXMLElement *senderImage ;
            NSXMLElement *senderID ;
            NSXMLElement *group_id ;
            NSXMLElement *message_Type ;
            NSXMLElement *actionUser_id ;
            NSXMLElement *action_Id ;

            
            senderImage   =     [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
            senderID      =     [NSXMLElement elementWithName:@"id" stringValue: str];
            group_id      =     [NSXMLElement elementWithName:@"group_id" stringValue: _selectedRoom.roomJbID];
            senderIDs     =     [NSXMLElement elementWithName:@"sender_id" stringValue: obj.loginUserID];
            senderName    =     [NSXMLElement elementWithName:@"sender_name" stringValue: obj.loginDisplayName];
            message_Type  =     [NSXMLElement elementWithName:@"msg_type" stringValue: @"3"] ;
            actionUser_id =     [NSXMLElement elementWithName:@"actioned_user_id" stringValue: obj.loginUserID] ;
            action_Id     =     [NSXMLElement elementWithName:@"action_id" stringValue: @"3"] ;

            
            [attachment addChild:senderName];
            [attachment addChild:senderID];
            [attachment addChild:senderImage];
            [attachment addChild:senderIDs];
            [attachment addChild:message_Type];
            [attachment addChild:group_id];
            [attachment addChild:actionUser_id];
            [attachment addChild:action_Id];

            [message    addBody:text];
            [message    addChild:attachment];
            [self.myroom sendMessage:message];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                
            });
            
           
            
            
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            //
            //            });
            
            
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //                [self sendPushNotificatin:text];
            //
            //            });
            //            self.growingTextView.internalTextView.text = @"";
            //            self.growingTextView.placeholderLabel.text = @"Type a message" ;
            
            
            
            
        } else {
            [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
        }
        
        
    });
    
}



- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    
}

-(void)isMemberAddd {
    XMPPRoomMemoryStorage *storage = [[XMPPRoomMemoryStorage alloc]init];
    self.myroom = [[XMPPRoom alloc] initWithRoomStorage:storage
                                                    jid:[XMPPJID jidWithString:_selectedRoom.roomJbID]
                                          dispatchQueue:dispatch_get_main_queue()];

    [self.myroom activate:[SharedDBChatManager xmppStream]];
    [self.myroom addDelegate:self
               delegateQueue:dispatch_get_main_queue()];

    [self.myroom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user history:nil];
    if (app.pushType == 1) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self groupCreate];

        });
    } else  {
        NSLog(@"Some Error Occur ");
    }

}

- (IBAction)btnGroup_Detail_Pressed:(UIButton *)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    YPOGroupDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGroupDetailVc"];
    vc.selectedRoom = self.selectedRoom ;
    vc.groupMembersID = self.groupsMembersArray ;
    appDelegate.groupsMembers_Detail = self.groupsMembersArray ;
    vc.myroom = self.myroom ;
    if([[NSString stringWithFormat:@"%@",ownerRoomName] isEqualToString:obj.loginUserID]){
        
        vc.ownderAdminId = ownerRoomName ;
    } else {
        vc.ownderAdminId = nil ;

    }
    
    vc.ownerId = ownerRoomName ;
    
    [self.navigationController pushViewController:vc animated:true];
    
    
    
}




-(void)fetchMembersList{

    [_groupsMembersArray removeAllObjects];
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//    NSString *roomName = [[NSString stringWithFormat:@"%@",myroom.roomJID] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",kBaseConfrence] withString:@""];
    NSString *roomName ;
    NSRange range = [_selectedRoom.roomJbID rangeOfString:@"@"];
     if (range.location != NSNotFound) {
        roomName = [_selectedRoom.roomJbID substringToIndex:range.location];
    }
    
//    = [[NSString stringWithFormat:@"%@",_selectedRoom.roomJbID] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",kBaseConfrence] withString:@""];
    NSString *serviceName  = [NSString stringWithFormat:WEBSERVICE_CHATROOMS@"%@",roomName];
    
//    [SVProgressHUD show];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SVHTTPRequest GETUserFriendName:[NSString stringWithFormat:@"%@", serviceName] parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        [SVProgressHUD dismiss];
        
        if ([[response valueForKey:@"message"] isEqualToString:@"Could not find the chat room"]){
            [_btnSendMessage_Pressed setHidden:true];
            [_btnAttachment setHidden:true] ;
//            @property (strong, nonatomic) IBOutlet UIView *viewOfGroup;
//            @property (strong, nonatomic) IBOutlet UILabel *titleOfDeleteOrLeave;
            
            [self.viewOfGroup setHidden:false];
            self.titleOfDeleteOrLeave.text = @"Group has been Deleted" ;
            [_btnGroupDetail setUserInteractionEnabled:false];
            
            [self.myroom leaveRoom];
            [self.growingTextView setHidden:true];
            
        }
        else  {
            if (response!=nil) {
            NSError *error;
            if (!error) {
            if ([[[response valueForKey:@"owners"]valueForKey:@"owner"] isKindOfClass:[NSNull class]]){
                NSLog(@"Null") ;
            }else {
                ownerRoomName    = [[response valueForKey:@"owners"]valueForKey:@"owner"] ;

            }
            if ([ownerRoomName containsString:@"@"]) {
                 ownerRoomName = [ownerRoomName substringWithRange: NSMakeRange(0, [ownerRoomName rangeOfString: @"@"].location)];
                }
                MORoom *room = [[MORoom alloc]initWithDictionary:response];
                _members = [room.roomMembers mutableCopy];
               
                if (_members.count>0) {
                    //[self.membersCollView reloadData];
                    
                    for (int i=0; i<_members.count; i++) {
                        
                        NSString *userName = [_members objectAtIndex:i];
                        
                        if ([userName containsString:@"@"]) {
                            
                            userName = [userName substringWithRange: NSMakeRange(0, [userName rangeOfString: @"@"].location)];
                            
                        }
                        
                        [_groupsMembersArray addObject:userName];
                        
                    }
                  
                    
                    if ([obj.loginUserID isEqualToString:ownerRoomName]){
                        [self.btnSendMessage_Pressed setUserInteractionEnabled:true];
                        self.growingTextView.userInteractionEnabled = true ;
                        [self isMemberAddd];
                        [_btnGroupDetail setUserInteractionEnabled:true];
                        [self.btnLeaveOrDeleteGroup  setHidden:false];
                        [self.btnSendMessage_Pressed setImage:UIImageWithName(@"sendbtn") forState:UIControlStateNormal];
                    }
                    else  if ([_groupsMembersArray containsObject:obj.loginUserID]){
                        [self.btnSendMessage_Pressed setUserInteractionEnabled:true];
                        [self isMemberAddd];
                        [_btnGroupDetail setUserInteractionEnabled:true];

//                        XMPPRoomMemoryStorage *storage = [[XMPPRoomMemoryStorage alloc]init];
//                        self.myroom = [[XMPPRoom alloc] initWithRoomStorage:storage
//                                                                        jid:[XMPPJID jidWithString:_selectedRoom.roomJbID]
//                                                              dispatchQueue:dispatch_get_main_queue()];
//
//                        [self.myroom activate:[SharedDBChatManager xmppStream]];
//                        [self.myroom addDelegate:self
//                                   delegateQueue:dispatch_get_main_queue()];
//
//                        [self.myroom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user
//                                                   history:nil
//                                                  password:nil];
                        self.growingTextView.userInteractionEnabled = true ;
                        [self.btnLeaveOrDeleteGroup  setHidden:false];
                        [self.btnSendMessage_Pressed setImage:UIImageWithName(@"sendbtn") forState:UIControlStateNormal];
                        
                    } else {
                        
                        [_btnSendMessage_Pressed setHidden:true];
                        [_btnAttachment setHidden:true] ;
                        [self.growingTextView setHidden:true];
                        [self.myroom leaveRoom];
//                        [self.myroom removeDelegate:[XMPPJID jidWithString:_selectedRoom.roomJbID] delegateQueue:dispatch_get_main_queue()];
//                        [self.myroom removeDelegate:[SharedDBChatManager xmppStream]];
                        

                        [self.viewOfGroup setHidden:false];
                        self.titleOfDeleteOrLeave.text = @"You are not part of the group anymore";
//                        XMPPRoomMemoryStorage *storage = [[XMPPRoomMemoryStorage alloc]init];
//                        self.myroom = [[XMPPRoom alloc] initWithRoomStorage:storage
//                                                                        jid:[XMPPJID jidWithString:_selectedRoom.roomJbID]
//                                                              dispatchQueue:dispatch_get_main_queue()];
//                        [self.myroom deactivate];
//                        [self.myroom activate:[SharedDBChatManager xmppStream]];

//                        if (app.isUserLeaveOrBlock == false){
////                            self.titleOfDeleteOrLeave.text = @"You have left this group";
//
//
//                        } else {
////                            self.titleOfDeleteOrLeave.text = @"You have been blocked By group admin";
//
//                        }
                        [_btnGroupDetail setUserInteractionEnabled:false];

                        
//                        XMPPRoomMemoryStorage *storage = [[XMPPRoomMemoryStorage alloc]init];
//                        self.myroom = [[XMPPRoom alloc] initWithRoomStorage:storage
//                                                                        jid:[XMPPJID jidWithString:_selectedRoom.roomJbID]
//                                                              dispatchQueue:dispatch_get_main_queue()];
//
//                        [self.myroom activate:[SharedDBChatManager xmppStream]];
//                        [self.myroom addDelegate:self
//                                   delegateQueue:dispatch_get_main_queue()];
//
//                        [self.myroom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user
//                                                   history:nil
//                                                  password:nil];
                        

//                        [self.btnSendMessage_Pressed setImage:UIImageWithName(@"send") forState:UIControlStateNormal];
//                        self.growingTextView.userInteractionEnabled = false ;
//                        [self.btnSendMessage_Pressed setUserInteractionEnabled:false];
//
//                        [self.btnLeaveOrDeleteGroup  setHidden:true];
                    }
                    
                    //                    else {
                    //
                    //                    }
                } else  {
                    if ([obj.loginUserID isEqualToString:ownerRoomName]){
                        if (_members == nil) {
                            [_btnSendMessage_Pressed setHidden:true];
                            [_btnAttachment setHidden:true] ;
                            [self.growingTextView setHidden:true];
                            [self.myroom leaveRoom];
                            [self.viewOfGroup setHidden:false];
                            self.titleOfDeleteOrLeave.text = @"Group has been Deleted" ;
                            [_btnGroupDetail setUserInteractionEnabled:false];


                            
                            NSLog(@"Group are delete");

                        } else {
                            [_btnSendMessage_Pressed setHidden:false];
                            [_btnAttachment setHidden:false] ;
                            [self.growingTextView setHidden:false];
//                            [self.myroom leaveRoom];

                        }
                        

                    } else {
                        [_btnSendMessage_Pressed setHidden:true];
                        [_btnAttachment setHidden:true] ;
                        [self.growingTextView setHidden:true];
                        [self.myroom leaveRoom];
                        [self.viewOfGroup setHidden:false];

                        self.titleOfDeleteOrLeave.text = @"Group has been Deleted" ;
                        
                        [_btnGroupDetail setUserInteractionEnabled:false];

                        NSLog(@"Group are delete");

                    }
                    
                }
                
                
//                else  if ([obj.loginUserID isEqualToString:ownerRoomName]){
//                    [self.btnSendMessage_Pressed setUserInteractionEnabled:true];
//                    self.growingTextView.userInteractionEnabled = true ;
//                    [self.btnLeaveOrDeleteGroup  setHidden:false];
//                    [self.btnSendMessage_Pressed setImage:UIImageWithName(@"sendbtn") forState:UIControlStateNormal];
//                }
//                else {
//                        [self.btnSendMessage_Pressed setImage:UIImageWithName(@"send") forState:UIControlStateNormal];
//                        self.growingTextView.userInteractionEnabled = false ;
//                        [self.btnSendMessage_Pressed setUserInteractionEnabled:false];
//
//                        [self.btnLeaveOrDeleteGroup  setHidden:true];
////
//
//
//                }
                if (ownerRoomName == nil){
                    
                } else {
                    [_groupsMembersArray addObject:ownerRoomName];

                }
                

            }

        }
    }
//        else {
////            [SVProgressHUD dismiss];
//
//
////             [MBProgressHUD hideHUDForView:self.view animated:YES];
////            [UtilityFunctions showAlertView:@"Error" message:@"Unable to fetch member list"];
//
//
//
//        }

    }];


}

//- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
//        NSLog(@"xmppRoomDidJoin");
//    // I use the same code to create or join a room that's why I commented the next line
//        [sender fetchConfigurationForm];
//    XMPPRoomMemoryStorage *storage = sender.xmppRoomStorage;
//    _occupentArray =  storage.occupants.mutableCopy ;
//
//    NSLog(@"print it %lu", (unsigned long)storage.occupants.count);
//
////    NSXMLElement *elemet = [sender fetchConfigurationForm];
//
//    //Next line generates the error:
//
//}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.myroom leaveRoom];
    [self.navigationController popViewControllerAnimated:true];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;
   
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Chat Group Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {

        if (_isAlreadyJoined == NO) {
            
            
//            XMPPRoomMemoryStorage *storage = [[XMPPRoomMemoryStorage alloc]init];
//            self.myroom = [[XMPPRoom alloc] initWithRoomStorage:storage
//                                                            jid:[XMPPJID jidWithString:_selectedRoom.roomJbID]
//                                                  dispatchQueue:dispatch_get_main_queue() withDescription:@"Any Thing"];
//            NSLog(@"print it %@", [XMPPJID jidWithString:_selectedRoom.roomJbID]);
//
//
//            [self.myroom activate:[SharedDBChatManager xmppStream]];
//
//            [self.myroom addDelegate:self
//                       delegateQueue:dispatch_get_main_queue()];
//
//
//            [self.myroom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user history:nil];

//            [self.myroom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user
//                                       history:nil
//                                      password:nil];
            

            
            
            
            
        }
        else {
            
        }
    });
    
}




- (void)messageReceived:(NSNotification*)notif
{
    GroupMessage *obj = notif.object ;
    //    isAnimated = true ;
    
    if (obj){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self.tbleView beginUpdates];
            
            
            NSIndexPath *row1 = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
            [self.dataArray insertObject:obj atIndex:_dataArray.count];
            //
            [self.tbleView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
            
            [self.tbleView endUpdates];
            //
            //            //Always scroll the chat table when the user sends the message
            if([self.tbleView numberOfRowsInSection:0]!=0)
            {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbleView numberOfRowsInSection:0]-1 inSection:0];
                [self.tbleView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
            }});
    }
   
}

- (IBAction)btnAttachment_Pressed:(UIButton *)sender {

    [self.view endEditing:true];
    [self pickMediaWithType:VCTypeImagePicker sender:sender withCompletion:^(NSURL *mediaURL, NSData *data, VCType type, BOOL success) {
        [SVProgressHUD showWithStatus:@""];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        if([Utility connectedToNetwork]){
            if (data == nil) {
                [SVProgressHUD dismiss];

            } else {
                [self performSelector:@selector(sendImage:) withObject:[UIImage imageWithData:data] afterDelay:1.0];
            }

        } else {
            [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
        }

    }];
}

-(NSString*)getCurrentTime
{
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    [dateFormatter setDateFormat:@"MMddyyyyHHmmss"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    //    NSString *md5 = [dateInStringFormated MD5String];
    
    
    return dateInStringFormated;
    
    
}

-(NSString*)getLocalFilePath:(UIImage*)image{
    
    NSData *webData = UIImageJPEGRepresentation(image, 0.9);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",[self getCurrentTime]]];
    [webData writeToFile:localFilePath atomically:YES];
    
    return localFilePath;
}
- (void)sendImage:(UIImage *)image{
    
    UIImage *compressedImage = [UIImage compressImage:image compressRatio:0.6f];
    NSString *filePath = [self getLocalFilePath:compressedImage];
    
    
    // xmp send Image
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    XMPPMessage *message = [[XMPPMessage alloc]init];
    NSString *text = self.growingTextView.internalTextView.text ; // enter the text in text field
    NSString *str = [SharedDBChatManager xmppStream].generateUUID ;
    
    NSXMLElement *attachment = [NSXMLElement elementWithName:@"msg_extras" xmlns:@"org.ypo"];
    NSXMLElement *senderName ;
    NSXMLElement *senderIDs ;
    NSXMLElement *senderImage ;
    NSXMLElement *senderID ;
    NSXMLElement *group_id ;
    NSXMLElement *message_Type ;
    __block NSXMLElement *file ;


    
    
    senderImage =      [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
    senderID    =      [NSXMLElement elementWithName:@"id" stringValue: str];
    group_id    =      [NSXMLElement elementWithName:@"group_id" stringValue: _selectedRoom.roomJbID];
    senderIDs    =     [NSXMLElement elementWithName:@"sender_id" stringValue: obj.loginUserID];
    senderName  =      [NSXMLElement elementWithName:@"sender_name" stringValue: obj.loginDisplayName];
    message_Type =     [NSXMLElement elementWithName:@"msg_type" stringValue: @"2"] ;

   
    
    
    
    //         [message addAttributeWithName:@"senderName" stringValue: obj.loginDisplayName];
//    [message addBody:text];
    [message addChild:attachment];

    
    NSData *imageDatass = UIImageJPEGRepresentation(compressedImage, 1.0);
    NSDictionary *params = @{@"user_id"  : @"32",
                             @"msg_id"   : @"134"
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:100];
    
    
    [manager POST:WEBSERVICE_UPLOAD_PICTURE parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageDatass name:@"file_image" fileName:[filePath lastPathComponent] mimeType:@"image/jpeg"];
        
        for (int i = 0; i < params.allKeys.count; ++i)  {
            
            NSString *key =   [[params allKeys] objectAtIndex:i];
            NSString *value = [params valueForKey:key];
            [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
            
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary *dic = (NSMutableDictionary *)responseObject;
        NSDictionary *dict  =  [dic valueForKey:@"attachment_data"];
        [SVProgressHUD dismiss];

//        fileOfSender = [NSXMLElement elementWithName:@"file" stringValue:[dict valueForKey:@"main_url"]];
        
        file =   [NSXMLElement elementWithName:@"file" stringValue:[dict valueForKey:@"main_url"]] ;
        [attachment addChild:senderName];
        [attachment addChild:senderID];
        [attachment addChild:senderImage];
        [attachment addChild:senderIDs];
        [attachment addChild:message_Type];
        [attachment addChild:group_id];
        [attachment addChild:file];
        [message addBody:@"Image"];

        
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
            [self.myroom sendMessage:message];
            
//        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [self sendPushNotificatin:@"Image"];
            
        });
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    }

//-(void)fetchRoomRelatedData:(XMPPRoom*)sender{
//
//    [sender fetchMembersList];
//
//
////    if (_isAlreadyJoined==NO) {
////
////        [self.btnOptionsEnable setEnabled:YES];
////    }
//
//
//     [self getHistory:sender];
//}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [NotifCentre postNotificationName:kChatNotificationRemoved object:nil];
    
    [NotifCentre postNotificationName:kChatNotificationRemoved object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.isViewVisible = false ;
    appDelegate.isNotifyOfGroupChat = true ;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self fetchMembersList];
    });
    
    __weak id this = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      __strong YPOGroupChatDetailVC *strongThis = this;
                                                      [strongThis keyboardWillAppearNotification:note];
                                                  }];
//    dispatch_async(dispatch_get_main_queue(), ^(void) {
//
//        [self fetchMembersList] ;
//
//    });
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Remove notification for keyboard change events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}


-(void)keyboardWillChange:(NSNotification *)notification
{
    // Retrieve the keyboard begin / end frame values
    CGRect beginFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame =  [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat delta = (endFrame.origin.y - beginFrame.origin.y);
    NSLog(@"Keyboard YDelta %f -> B: %@, E: %@", delta, NSStringFromCGRect(beginFrame), NSStringFromCGRect(endFrame));
    
    // Lets only maintain the scroll position if we are already scrolled at the bottom
    // or if there is a change to the keyboard position
    
        // Construct the animation details
        NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
    
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            
            // Make the tableview scroll opposite the change in keyboard offset.
            // This causes the scroll position to match the change in table size 1 for 1
            // since the animation is the same as the keyboard expansion
            self.tbleView.contentOffset = CGPointMake(0, self.tbleView.contentOffset.y - delta);
            
        } completion:nil];
    
}


#pragma mark - CSGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(CSGrowingTextView *)textView {
    [textView resignFirstResponder];
    
    //    self.textView.text = textView.internalTextView.text;
    //    textView.internalTextView.text = @"";
    
    return YES;
}

- (void)growingTextView:(CSGrowingTextView *)growingTextView willChangeHeight:(CGFloat)height {
    __weak id this = self;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         __strong YPOGroupChatDetailVC *strongThis = this;
                         strongThis.growingTextViewHeightConstraint.constant = height;
                         [strongThis.growingTextView setNeedsUpdateConstraints];
                         [strongThis.growingTextView.superview layoutIfNeeded];
                     } completion:nil];
}

#pragma mark - Layout Changes

- (void)keyboardWillAppearNotification:(NSNotification *)note {
    
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect contentViewFrame = self.view.bounds;
    
    BOOL isKeyboardShown = (CGRectGetMinY(keyboardFrame) < CGRectGetHeight([[UIScreen mainScreen] bounds]));
    if (isKeyboardShown) {
        contentViewFrame.size.height -= CGRectGetHeight(keyboardFrame);
    }
    
    [self adjustTableViewFrame:contentViewFrame
          keyboardNotification:note];
}

- (void)adjustTableViewFrame:(CGRect)frame
        keyboardNotification:(NSNotification *)note {
    
    UIViewAnimationOptions animationCurve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __weak id this = self;
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurve
                     animations:^{
                         
                         __strong YPOGroupChatDetailVC *strongThis = this;
                         
                         self.contentViewBottomConstraint.constant = CGRectGetHeight(strongThis.view.bounds) - CGRectGetMaxY(frame);
                         [strongThis.contentView setNeedsUpdateConstraints];
                         [strongThis.contentView.superview layoutIfNeeded];
                     } completion:nil];
}

-(void)getHistory:(XMPPRoom*)userRoom{
    
    XMPPRoomMemoryStorage *storage = userRoom.xmppRoomStorage;
    
//    NSArray *messagesArray = [storage.messages mutableCopy];
//
//    [self removeDuplicates:[messagesArray mutableCopy]];
    
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getConverWithDelay) name:@"groupushNotification" object:nil];
    
}

- (IBAction)btnSendChatPressed:(id)sender {
    
    if([Utility connectedToNetwork]){
        if (_growingTextView.internalTextView.text.length > 0) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            XMPPMessage *message = [[XMPPMessage alloc]init];
            NSString *text = self.growingTextView.internalTextView.text ; // enter the text in text field
            NSString *str = [SharedDBChatManager xmppStream].generateUUID ;
            
            NSXMLElement *attachment = [NSXMLElement elementWithName:@"msg_extras" xmlns:@"org.ypo"];
            NSXMLElement *senderName ;
            NSXMLElement *senderIDs ;
            NSXMLElement *senderImage ;
            NSXMLElement *senderID ;
            NSXMLElement *group_id ;
            NSXMLElement *message_Type ;

            
            senderImage =      [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
            senderID    =      [NSXMLElement elementWithName:@"id" stringValue: str];
            group_id    =      [NSXMLElement elementWithName:@"group_id" stringValue: _selectedRoom.roomJbID];
            senderIDs    =      [NSXMLElement elementWithName:@"sender_id" stringValue: obj.loginUserID];
            senderName  =      [NSXMLElement elementWithName:@"sender_name" stringValue: obj.loginDisplayName];
            message_Type =   [NSXMLElement elementWithName:@"msg_type" stringValue: @"1"] ;
            
            [attachment addChild:senderName];
            [attachment addChild:senderID];
            [attachment addChild:senderImage];
            [attachment addChild:senderIDs];
            [attachment addChild:message_Type];
            [attachment addChild:group_id];
            [message addBody:text];
            [message addChild:attachment];

           
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
                [self.myroom sendMessage:message];

            });


            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                [self sendPushNotificatin:text];

            });
            self.growingTextView.internalTextView.text = @"";
            self.growingTextView.placeholderLabel.text = @"Type a message" ;
            
            
            
        }
    } else {
        [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
    }
   
//    NSString *messageId = [SharedDBChatManager xmppStream].generateUUID ;
    
    
  
}

-(void)sendPushNotificatin:(NSString*)message{

    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    if ([_groupsMembersArray containsObject:obj.loginUserID]){
        [_groupsMembersArray removeObject:obj.loginUserID];
        
    }

    NSString *receiverIDs = [_groupsMembersArray componentsJoinedByString:@","];
    
    
    NSString *txtString = [NSString stringWithFormat:@"@%@: %@", obj.loginDisplayName , message];

    NSDictionary *params = nil;
    
    params =         @{@"SenderId"               :     obj.loginUserID,
                      @"SenderName"              :     obj.loginDisplayName,
                      @"RecieverId"              :     receiverIDs,
                      @"Message"                 :     txtString ,
                      @"SentDate"                :     @"" ,
                      @"IsChat"                  :     @"true" ,
                      @"groupId"                 :     _selectedRoom.roomJbID ,
                      @"GroupName"               :     _selectedRoom.room_Name
                      };
 
    [SVHTTPRequest POST:KBaseUrlForNotification parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error) {

            NSDictionary *dict = (NSDictionary*)response;
//            NSLog(@"what's here %@",dict);



        }
        else{

//            NSLog(@"what's here %@",error.description);


        }

    }];
}
- (IBAction)btnLeaveOrDeleteGroup_Pressed:(UIButton *)sender {
  
    
    if (_dataArray.count > 0){
        [self showConfirmationAlertViewWithTitle:@"YPO" message:@"Are you sure do you want to delete the Chat" withDismissCompletion:^{
            
         NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"group_Jabber_Id == %@" , _selectedRoom.roomJbID] ;
         NSArray *arrayOfRecentUser = [GroupMessage fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
          for (_userSelectedChat in arrayOfRecentUser) {
                [GroupMessage deleteObject:_userSelectedChat];
            }
            [GroupMessage save];
            [self.navigationController popViewControllerAnimated:true];
        }];
        
    }

//            for (_userSelectedChat in _dataArray) {
//                [GroupMessage deleteObject:_userSelectedChat];
//            }
//            [GroupMessage save];
//            [self.navigationController popViewControllerAnimated:true];
   
    
    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//
//    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//    UIActionSheet *actionSheet ;
//    if ([obj.loginUserID isEqualToString:ownerRoomName]){
//        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to Delete or Destroy this Group?"
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:@"Delete This Group"
//                                                        otherButtonTitles: nil , nil];
//
//        actionSheet.tag = 200 ;
//
//        [actionSheet showInView:self.view];
//
//    } else {
//        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to Leave  this Group?"
//                                                  delegate:self
//                                         cancelButtonTitle:@"Cancel"
//                                    destructiveButtonTitle: nil
//                                         otherButtonTitles:@"Leave This Group" , nil];
//        actionSheet.tag = 201 ;
//        [actionSheet showInView:self.view];
//    }
    
  
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 201){
        if (buttonIndex == 0){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            
            NSString   *myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", obj.loginUserID];
            NSString *roomName ;
            NSRange range = [_selectedRoom.roomJbID rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                roomName = [_selectedRoom.roomJbID substringToIndex:range.location];
            }
            
            NSString *serviceName  = [NSString stringWithFormat:WEBSERVICE_CHATROOMS@"%@/members/%@",roomName,myJID];
            //        NSLog(@"print it %@", serviceName);
            
            [SVHTTPRequest DELETEXMPP:serviceName parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (error == nil) {
                    [self.btnSendMessage_Pressed setUserInteractionEnabled:false];
                    self.growingTextView.userInteractionEnabled = false ;
                    //                [ChatRooms deleteObject:_selectedRoom];
                    
                    [self.btnSendMessage_Pressed setImage:UIImageWithName(@"send") forState:UIControlStateNormal];
                    [self.btnLeaveOrDeleteGroup  setHidden:true];
                    
                    [self showAlertViewWithTitle:@"Alert" message:@"Leave Group Successfully"];
                    
                }
                NSDictionary *dict = (NSDictionary*)response;
                //            NSLog(@"here it is %@",dict);
                
                
            }] ;
        
        } else {
            
        }
        
       
        }
      else if (actionSheet.tag == 200) {
          if (buttonIndex == 0){
              [self.myroom destroyRoom];
              [GroupMessage deleteObject:_selectedRoom];
              
              [self showAlertViewWithTitle:@"YPO" message:@"Group are delete Successfully" withDismissCompletion:^{
                  [self.navigationController popViewControllerAnimated:true];
              }] ;
              
          
          } else {
              
          }
      

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    YPOReceiverCell *receiveCell = (YPOReceiverCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOReceiverCell" forIndexPath:indexPath];
   YPOGroupReceiverCell *cell = (YPOGroupReceiverCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOGroupReceiverCell" forIndexPath:indexPath];
    YPOReceiverGroupImage *photoSenderCell = (YPOReceiverGroupImage *)[tableView dequeueReusableCellWithIdentifier:@"YPOReceiverGroupImage" forIndexPath:indexPath];
    
    YPOSenderImageGroup *photoReceiverCell = (YPOSenderImageGroup *)[tableView dequeueReusableCellWithIdentifier:@"YPOSenderImageGroup" forIndexPath:indexPath];
 
    YPOGroupMessageSenderCell *receiveCell = (YPOGroupMessageSenderCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOGroupMessageSenderCell" forIndexPath:indexPath];
    YPOLeftGroupCell *leftCell = (YPOLeftGroupCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOLeftGroupCell" forIndexPath:indexPath];

    
//    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOSenderImageGroup" bundle:nil] forCellReuseIdentifier:@"YPOSenderImageGroup"];
//    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOReceiverGroupImage" bundle:nil] forCellReuseIdentifier:@"YPOReceiverGroupImage"];

    

    GroupMessage *obj ;
    if (self.dataArray.count > 0) {
        obj  = (GroupMessage *)[self.dataArray objectAtIndex:indexPath.row];
    }
    
    if ([obj.messageType isEqualToString:@"1"]) {
        if (obj.is_Mine == true) {
            
            receiveCell.lblTextInput.text = obj.messageOfGroup ;
            NSString *mysqlDatetime = obj.dateAndTimeOfMessage ;
            NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];
            
            receiveCell.lblTime.text = timeAgoFormattedDate ;
            receiveCell.lblName.text = obj.senderName ;
            NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.image];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            [receiveCell.imageOfReciever setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            [Utility setViewCornerRadius:receiveCell.imageOfReciever radius:receiveCell.imageOfReciever.frame.size.width/2];
            return  receiveCell ;
        }  else {
            cell.nameOfUser.text = obj.senderName ;
            cell.messageOfUser.text = obj.messageOfGroup ;
            NSString *mysqlDatetime = obj.dateAndTimeOfMessage ;
            NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];
            NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.image];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            [cell.imageOfReceiver setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            [Utility setViewCornerRadius:cell.imageOfReceiver radius:cell.imageOfReceiver.frame.size.width/2];
            cell.lblDate.text        =  timeAgoFormattedDate ;
            return  cell ;
            
            
        }
    } else if ([obj.messageType isEqualToString:@"2"]) {
        if (obj.is_Mine == true){
//            photoReceiverCell.delegateOfReceiver = self ;
//            photoReceiverCell.index = indexPath ;
            NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.image];
            NSURL *imageURLss = [NSURL URLWithString:imageURLString];
            [photoReceiverCell.imageOfUser setImageWithURL:imageURLss placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            [Utility setViewCornerRadius:photoReceiverCell.imageOfUser radius:photoReceiverCell.imageOfUser.frame.size.width/2];

            
            NSURL *imageURL = [NSURL URLWithString:obj.imageUrl];
            
            //             NSURL *imageURL = [NSURL URLWithString:imageURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            [photoReceiverCell.activityStartIndicator startAnimating];
//            photoReceiverCell.btnPreviewPhoto_Pressed.userInteractionEnabled = false ;
            [photoReceiverCell.imageOfSenderSend setImageWithURLRequest:request
                                                     placeholderImage:[UIImage imageNamed:@"imgplaceholder"]
                                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                  [photoReceiverCell.activityStartIndicator stopAnimating];
//                                                                  photoReceiverCell.btnPreviewPhoto_Pressed.userInteractionEnabled = true ;
                                                                  
                                                                  photoReceiverCell.imageOfSenderSend.image = image;
                                                              }
                                                              failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                  [photoReceiverCell.activityStartIndicator stopAnimating];
                                                              }];
            
            
            
            return photoReceiverCell ;

        } else {
            photoSenderCell.delegate = self ;
            photoSenderCell.index = indexPath ;
            
            NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.image];
            NSURL *imageURLss = [NSURL URLWithString:imageURLString];
            [photoSenderCell.imageOfUser setImageWithURL:imageURLss placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            [Utility setViewCornerRadius:photoSenderCell.imageOfUser radius:photoSenderCell.imageOfUser.frame.size.width/2];

            NSURL *imageURL = [NSURL URLWithString:obj.imageUrl];
            
            //             NSURL *imageURL = [NSURL URLWithString:imageURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
            [photoSenderCell.activityStartIndicator startAnimating];
//            photoSenderCell.btnPreviewPhoto_Pressed.userInteractionEnabled = false ;
            [photoSenderCell.imageOfReciever setImageWithURLRequest:request
                                                         placeholderImage:[UIImage imageNamed:@"imgplaceholder"]
                                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                      [photoSenderCell.activityStartIndicator stopAnimating];
//                                                                      photoSenderCell.btnPreviewPhoto_Pressed.userInteractionEnabled = true ;
                                                                      
                                                                      photoSenderCell.imageOfReciever.image = image;
                                                                  }
                                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                      [photoSenderCell.activityStartIndicator stopAnimating];
                                                                  }];
            
            
            
            return photoSenderCell ;

        }
    } else {
        leftCell.lblLeftGroupUser.text = obj.messageOfGroup ;
        
        return  leftCell ;
        
    }
    
   
   
        
    
}

-(void)btnGroupPhotoBrowserPressed:(YPOReceiverGroupImage *)cell indexPathRow:(NSIndexPath *)indexPathRow {
    UIImageView *imageView = cell.imageOfReciever;
    NSMutableArray *photos = [NSMutableArray new];
    if (imageView.image) {
        [photos addObject:imageView.image];
    }
    
    //    for (int i=0; i<self.dataArray.count; i++) {
    //        msg = self.dataArray[i];
    //        [photos addObject:msg.thumbnail];
    //
    ////        if ([msg.type  isEqual: MessageTypeImage] && imageView.tag != i) {
    ////        }
    //    }
    photos = [[IDMPhoto photosWithImages:photos] mutableCopy];
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:imageView];
    // using initWithPhotos:animatedFromView: method to use the zoom-in animation
    browser.delegate = self;
    browser.displayActionButton = YES;
    browser.displayArrowButton = YES;
    browser.displayCounterLabel = YES;
    browser.usePopAnimation = YES;
    browser.scaleImage = imageView.image;
    browser.useWhiteBackgroundColor = NO;
    // Show
    [self presentViewController:browser animated:YES completion:nil];
}



@end
