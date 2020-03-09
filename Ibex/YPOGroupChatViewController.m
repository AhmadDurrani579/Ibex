//
//  YPOGroupChatViewController.m
//  YPO
//
//  Created by Ahmed Durrani on 21/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOGroupChatViewController.h"
#import "UIViewController+Helper.h"
#import "Constant.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "DBChatManager.h"
#import "ChatRooms+CoreDataClass.h"
#import "YPOGroupRecentCell.h"
#import "YPOGroupChatDetailVC.h"
#import "YPOCreateGroupVC.h"
@interface YPOGroupChatViewController ()<UITableViewDataSource , UITableViewDelegate>
{
    NSString *groupName ;
    __weak IBOutlet UITableView *tbleView;
}
@property (nonatomic,strong) ChatRooms *roomChat;
@property (nonatomic , strong)NSMutableArray *arrayOfGroupNumber ;

@end

@implementation YPOGroupChatViewController

- (void)loadView {
    [super loadView];
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter The Group Name"
//                                                                   message:@"Enter some text below"
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
//                                                   handler:^(UIAlertAction * action) {
//
//                                                       if (alert.textFields.count > 0) {
//
//                                                           UITextField *textField = [alert.textFields firstObject];
//                                                           groupName = textField.text ;
//
//                                                           [self createChatRoom];
//
//                                                                          }
//
//                                                   }];
//    [alert addAction:submit];
//
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"something"; // if needs
//    }];
//
//
//    [self presentViewController:alert animated:YES completion:nil];

    
}



- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _arrayOfGroupNumber = [[NSMutableArray alloc] init];
    
    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
    [tbleView reloadData];

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
    NSString *name         = [NSString stringWithFormat:@"%@%@%@ibexglobal.com", obj.loginUserID ,groupName, kBaseConfrence]; //
    
    
    
    NSString *username;
    
    NSString *str = name;
    
    XMPPJID *roomJID = [XMPPJID jidWithString:name];
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage
                                                           jid:roomJID
                                                 dispatchQueue:dispatch_get_main_queue() withDescription:@"Any Thing"];
    
    
//    - (id)initWithRoomStorage:(id <XMPPRoomStorage>)storage jid:(XMPPJID *)roomJID dispatchQueue:(dispatch_queue_t)queue;

    [xmppRoom activate:[SharedDBChatManager xmppStream]];
    [xmppRoom addDelegate:self
            delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:[SharedDBChatManager xmppStream].myJID.user
                            history:nil
                           password:nil];
    
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
    
    NSLog(@"room created successfully");
    XMPPJID *roomJidStr = [sender roomJID];
    
    
    if(!_roomChat)        {
        _roomChat = (ChatRooms *) [ChatRooms create];
    }
    
    _roomChat.room_Name = groupName ;
    _roomChat.roomJbID = [NSString stringWithFormat:@"%@",roomJidStr] ;
    _roomChat.userJbID = [NSString stringWithFormat:@"%@",[SharedDBChatManager xmppStream].myJID.user] ;
    [ChatRooms save];
    [self getAllGroupFromDB];
    
    
}

-(void)getAllGroupFromDB {
    
    _arrayOfGroupNumber = [ChatRooms fetchAll].mutableCopy ;
    
    tbleView.delegate = self ;
    tbleView.dataSource = self ;
    [tbleView reloadData];
    
    
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    
    [sender fetchConfigurationForm];
}
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult{
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    
    NSLog(@"what's here %@",items);
    
    
}
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items{
    
    NSLog(@"what's here %@",items);
}
- (IBAction)btnGoTOChatViewController:(UIButton *)sender {
    YPOCreateGroupVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOCreateGroupVC"];
    [self.navigationController pushViewController:vc animated:true];
    
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
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
    [sender changeRoomSubject:groupName];
//    XMPPUserCoreDataStorageObject *usr = [cellSelected objectAtIndex:i];
    
    
    XMPPJID *inviteUserJbID = [XMPPJID jidWithString:@"14@ibexglobal.com"];

    NSLog(@"what's here %@",inviteUserJbID);
    
//    XMPPJID jidOfInviteUser = [NSString stringWithFormat:@"%@", inviteUserJbID];
    
    
    [sender editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"member" jid:inviteUserJbID]]];
    //End
    [sender inviteUser:inviteUserJbID withMessage: @"Hello"];

//    [sender inviteUser:[XMPPJID jidWithString:usr.jidStr] withMessage:_txtGroupName.text withDescription:_txtDescription.text andColor:[self returnColorSelected]];

    
//    [SharedDBChatManager.xmppRoom editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"member" jid: inviteUserJbID]]];
//    [SharedDBChatManager.xmppRoom inviteUser:inviteUserJbID withMessage: @"Hello"];

    
//    [sender editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"member" jid:inviteUserJbID]]] ;
//    [sender editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"member" jid:inviteUserJbID]]];
    //End
    
//    [sender inviteUser:inviteUserJbID withMessage:groupName];
//    [sender inviteUser:[XMPPJID jidWithString:usr.jidStr] withMessage:groupName withDescription:_txtDescription.text andColor:[self returnColorSelected]];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    NSInteger numOfSections = 0;
//    if (_arrayOfRecentUser.count >0)
//    {
//        numOfSections                = 1;
//        _recentListUserTableView.backgroundView = nil;
//    }
//    else
//    {
//        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _recentListUserTableView.bounds.size.width, _recentListUserTableView.bounds.size.height)];
//        [noDataLabel setNumberOfLines:10];
//        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
//        noDataLabel.text             = @"There are currently no data.";
//        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
//        noDataLabel.textAlignment    = NSTextAlignmentCenter;
//        _recentListUserTableView.backgroundView = noDataLabel;
//        _recentListUserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _arrayOfGroupNumber.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOGroupRecentCell *cell = (YPOGroupRecentCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOGroupRecentCell" forIndexPath:indexPath];
    
    ChatRooms *room = (ChatRooms *)[self.arrayOfGroupNumber objectAtIndex:indexPath.row] ;
    cell.lblGroupName.text = room.room_Name ;
    return  cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YPOGroupChatDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGroupChatDetailVC"];
    ChatRooms *checkList = (ChatRooms *)[self.arrayOfGroupNumber objectAtIndex:indexPath.row];
    vc.selectedRoom = checkList ;
    
    [self.navigationController pushViewController:vc animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 94.0 ;
    
}






@end
