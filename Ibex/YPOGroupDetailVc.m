//
//  YPOGroupDetailVc.m
//  YPO
//
//  Created by Ahmed Durrani on 25/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOGroupDetailVc.h"
#import "SVHTTPRequest.h"
#import "Constant.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "EventSpeakerModel.h"
#import "YPOGroupDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "YPOAddParticipantVC.h"
#import "GroupMessage+CoreDataClass.h"
#import "NYAlertViewController.h"
#import "AttendeeSpeakerSessionViewController.h"
#import "YPOChatViewController.h"
#import "DBChatManager.h"
@interface YPOGroupDetailVc ()<UITableViewDataSource , UITableViewDelegate , LeaveBtnPressedDelegate , AllUserDelegate>
{
    
    IBOutlet UITableView *tblView;
    IBOutlet UILabel *lblAdminOfGroup;
    IBOutlet UILabel *lblNumberOfGroup;
    IBOutlet UILabel *lblGroupName;
    IBOutlet UIButton *btnAddParticipant_Pressed;
    IBOutlet UIButton *btnDelete_Pressed;
    NSString *receiverIDs ;
    NSString *stringWithoutSpaces ;
    AppDelegate *appDelegate ;
    NSString *idOfUser ;


}
@property(strong , nonatomic) NSMutableArray *allUserList ;
@property (assign) BOOL isAdminOrUser;
@property(nonatomic , strong)NSIndexPath    *indexRow ;
@property (assign) BOOL isBlockOrNot;



@end

@implementation YPOGroupDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    idOfUser = nil ;
    appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;

    appDelegate.pushType = 2 ;
    _isBlockOrNot = false ;
    if([Utility connectedToNetwork]){

    } else {
        [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
    }
    _allUserList = [[NSMutableArray alloc] init];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userObj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    if([[NSString stringWithFormat:@"%@", _ownderAdminId] isEqualToString:userObj.loginUserID]){
         [btnAddParticipant_Pressed setHidden:false];
         [btnDelete_Pressed setHidden:false];
         [btnDelete_Pressed setTitle:@"Delete Group" forState:UIControlStateNormal];
         _isAdminOrUser = true ;
    } else {
        if (appDelegate.groupsMembers_Detail.count > 3) {
            [btnAddParticipant_Pressed setHidden:true];
            _isAdminOrUser = false ;
            [btnDelete_Pressed setHidden:false];
            [btnDelete_Pressed setTitle:@"Leave Group" forState:UIControlStateNormal];
            

        } else {
            [btnAddParticipant_Pressed setHidden:true];
            _isAdminOrUser = false ;
            [btnDelete_Pressed setHidden:true];

            [btnDelete_Pressed setTitle:@"Leave Group" forState:UIControlStateNormal];

        }
        

    }
    lblGroupName.text = self.selectedRoom.room_Name ;
    [lblNumberOfGroup setText:[NSString stringWithFormat:@"%lu", (unsigned long)appDelegate.groupsMembers_Detail.count]];
    
//    WEBSERVICE_GETUSERBYID
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self getGroupDetail];

    });
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Chat Group detail Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)userArray:(NSString *)arrayOfValue {
    
//    [appDelegate.groupsMembers_Detail addObject:arrayOfValue];
    [lblNumberOfGroup setText:[NSString stringWithFormat:@"(%lu)", (unsigned long)appDelegate.groupsMembers_Detail.count]];

    [self getGroupDetail];
    NSLog(@"print it") ;
}

-(void)getGroupDetail {
    
    [_allUserList removeAllObjects];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userObj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
//    stringWithoutSpaces
    receiverIDs = [appDelegate.groupsMembers_Detail componentsJoinedByString:@","];
    if (idOfUser) {
        receiverIDs      = [receiverIDs
                                         stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",idOfUser] withString:@""];
    }
//    if (_isBlockOrNot == false) {
//
//    } else {
//      completeUrl  = [NSString stringWithFormat:@"%@/%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GETUSERBYID,stringWithoutSpaces];
//
//    }
    
   NSString *completeUrl = [NSString stringWithFormat:@"%@/%@%@",WEBSERVICE_DOMAIN_URL,WEBSERVICE_GETUSERBYID,receiverIDs];

    [SVProgressHUD show] ;
    [[SVHTTPClient sharedClient] GET:completeUrl  parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSLog(@"print it %@", response);
//        [self showNetworkIndicator:NO];
        [SVProgressHUD dismiss];
        
        if (response != nil){
            
            NSArray *results  = [response valueForKey:@"data"] ;
            [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *object = (NSDictionary*)obj;
                NSString *idOfSpeaker = [object valueForKey:@"id"] ;
             
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([[NSString stringWithFormat:@"%@", idOfSpeaker] isEqualToString:_ownerId]){
                        NSString *firstName  =  [object valueForKey:@"firstName"] ;
                        NSString *lastName   =  [object valueForKey:@"lastName"] ;
                        [lblAdminOfGroup setText:[NSString stringWithFormat:@"%@ %@%@", firstName , lastName,@"(Admin)"]];
                    }
                });
              
//
//                if([[NSString stringWithFormat:@"%@", idOfSpeaker] isEqualToString:userObj.loginUserID]){
//
//                } else {
////                    [btnAddParticipant_Pressed setHidden:true];
////                    [btnDelete_Pressed setHidden:true];
//
//                }

//                if ([modelObj.speakerID isEqualToString:userObj.loginUserID]) {
//                                    //                    [cell.lblAdmin setHidden:false];
//
//                    [lblAdminOfGroup setText:[NSString stringWithFormat:@"%@%@", modelObj.speakerFirstName , modelObj.speakerLastName]];
//                } else {
//                   //                    [cell.lblAdmin setHidden:true];
//
//                 }

                
            [_allUserList addObject:[EventSpeakerModel initWithDataAttendee:object]];
//                NSLog(@"print it %@", modelObj.speakerID);

         }];
            tblView.delegate = self ;
            tblView.dataSource = self ;
            [tblView reloadData];
            
            
        }

        }];


}
- (IBAction)btnDelete_Pressed:(UIButton *)sender {
    
    if(_isAdminOrUser == false) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
        
        [self showConfirmationAlertViewWithTitle:@"YPO" message:@"Are you sure do you want to leave this group" withDismissCompletion:^{
            
            appDelegate.isUserLeaveOrBlock = false ;

            NSString   *myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", obj.loginUserID];
            NSString *roomName ;
            NSRange range = [_selectedRoom.roomJbID rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                roomName = [_selectedRoom.roomJbID substringToIndex:range.location];
            }
            [NotifCentre postNotificationName:kGroupChatUserLeave object:obj];

            NSString *serviceName  = [NSString stringWithFormat:WEBSERVICE_CHATROOMS@"%@/members/%@",roomName,myJID];
            
            [SVHTTPRequest DELETEXMPP:serviceName parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (error == nil) {
                    
                    [self.myroom deactivate];
                    
                    appDelegate.isUserAddOrDelete = false ;


                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                        
                    });
                 
//                    
                }
                NSDictionary *dict = (NSDictionary*)response;
                //            NSLog(@"here it is %@",dict);
                
                
            }] ;
        }];
        

    
    } else {
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    
    alertViewController.title = @"YPO";
    alertViewController.message = @"Are you sure do you want to Delete this Group?";
    
    alertViewController.buttonCornerRadius = 20.0f;
    alertViewController.view.tintColor = self.view.tintColor;
    
    alertViewController.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0f];
    alertViewController.messageFont = [UIFont fontWithName:@"AvenirNext-Medium" size:16.0f];
    alertViewController.buttonTitleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:alertViewController.buttonTitleFont.pointSize];
    alertViewController.cancelButtonTitleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:alertViewController.cancelButtonTitleFont.pointSize];
    
    alertViewController.alertViewBackgroundColor = [UIColor colorWithRed:15/255.0  green:45/255.0 blue:65/255.0 alpha:1.0];
    alertViewController.alertViewCornerRadius = 10.0f;
    
    alertViewController.titleColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    alertViewController.messageColor = [UIColor colorWithWhite:0.92f alpha:1.0f];
    
    alertViewController.buttonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.buttonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    alertViewController.cancelButtonColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    alertViewController.cancelButtonTitleColor = [UIColor colorWithWhite:0.19f alpha:1.0f];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                            handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                              [self.myroom destroyRoom];
                                                              [GroupMessage deleteObject:self.selectedRoom];
//                                                              [self.navigationController popViewControllerAnimated:true];
                                                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

                                                              
                                                          }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(NYAlertAction *action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }]];
    
    [self presentViewController:alertViewController animated:YES completion:nil];
    
//    [self showAlertViewWithTitle:@"YPO" message:@"Group are delete Successfully" withDismissCompletion:^{
//
//
//        [self.navigationController popViewControllerAnimated:true];
//    }] ;

    }
}

-(void)sendPushNotificatin:(NSString*)message{
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    if ([_groupMembersID containsObject:obj.loginUserID]){
        [_groupMembersID removeObject:obj.loginUserID];
        
    }
    
    NSString *receiverIDs = [_groupMembersID componentsJoinedByString:@","];
    
    
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

- (IBAction)btnAddParticipant_Pressed:(UIButton *)sender {
    
    YPOAddParticipantVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOAddParticipantVC"];
//    ownderAdminId
    vc.adMinId = self.ownerId ;
    vc.ownerName = lblAdminOfGroup.text ;
    vc.selectedRoom = self.selectedRoom ;
    vc.delegate = self ;
    vc.roomName = lblGroupName.text ;
    
    vc.groupUserId = appDelegate.groupsMembers_Detail ;
    
//    receiverIDs
    [self.navigationController pushViewController:vc animated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _allUserList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOGroupDetailCell *cell = (YPOGroupDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOGroupDetailCell"];
    
//
//
    if (_allUserList.count > 0){
        EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:indexPath.row];

        if([[NSString stringWithFormat:@"%@", obj.speakerID] isEqualToString:_ownerId]){
            [cell.lblAdmin setHidden:false];
        } else {
            [cell.lblAdmin setHidden:true];
        }

        [cell.nameOfUser setText:[NSString stringWithFormat:@"%@ %@", obj.speakerFirstName , obj.speakerLastName]];
        cell.emialOfUser.text = obj.speakerEmailAddress ;
//
//
        NSURL *imageURL ;
        id  thumbnailImage = obj.speakerThumbImg ;

        if (thumbnailImage != [NSNull null]) {
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            imageURL = [NSURL URLWithString:imageURLString];
//
        }else {

        }
        //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,event.eventThumbImg]];
        
        
        cell.delegate = self ;
        cell.index = indexPath ;
        
        [cell.imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:cell.imageOfUser radius:cell.imageOfUser.frame.size.width/2];
//        [cell.btnOfImageSelected setTag:indexPath.row];
//
//        if([[_selectedButton objectAtIndex:indexPath.row]isEqualToString:@"NO"])
//        {
//            [cell.btnOfImageSelected setSelected:NO];
//        }
//        else
//        {
//            [cell.btnOfImageSelected setSelected:YES];
//        }
    
    }
    
//    cell.delegate = self ;
//    cell.index = indexPath ;
    return  cell ;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70.0 ;
}

-(void)btnLeaveGroup:(YPOGroupDetailCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userObj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:indexPathRow.row];
    if (_ownderAdminId) {
        if([[NSString stringWithFormat:@"%@", obj.speakerID] isEqualToString:_ownerId]){
            
        } else {
            UIActionSheet *lifeStatus ;
            if (appDelegate.groupsMembers_Detail.count > 3) {
             lifeStatus = [[UIActionSheet alloc] initWithTitle:self.selectedRoom.room_Name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"View Profile" otherButtonTitles:@"Start Chat", @"Block", nil];
                lifeStatus.tag = 201 ;

            } else {
                lifeStatus = [[UIActionSheet alloc] initWithTitle:self.selectedRoom.room_Name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"View Profile" otherButtonTitles:@"Start Chat", nil];
                lifeStatus.tag = 203 ;


            }
            
//            UIActionSheet *lifeStatus = [[UIActionSheet alloc] initWithTitle:self.selectedRoom.room_Name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"View Profile" otherButtonTitles:@"Start Chat", nil];

            
            _indexRow = indexPathRow ;
//            lifeStatus.tag = 201 ;
            [lifeStatus showInView:self.view];
        }
    } else  {
        
        if([[NSString stringWithFormat:@"%@", obj.speakerID] isEqualToString:userObj.loginUserID]){
            
        } else {
            UIActionSheet *lifeStatus = [[UIActionSheet alloc] initWithTitle:self.selectedRoom.room_Name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"View Profile" otherButtonTitles:@"Start Chat", nil];
            
            _indexRow = indexPathRow ;
            lifeStatus.tag = 202 ;
            [lifeStatus showInView:self.view];
        }
        
       

    }
    

//    if([[NSString stringWithFormat:@"%@", obj.speakerID] isEqualToString:userObj.loginUserID]){
//
//
//    }
//
//
//
//    NSLog(@"print it ");
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 201){
        if (buttonIndex == 2){
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;

             EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:_indexRow.row];

//            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

//            NSString   *myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", obj.speakerID];
//            NSString *roomName ;
//            NSRange range = [_selectedRoom.roomJbID rangeOfString:@"@"];
//            if (range.location != NSNotFound) {
//                roomName = [_selectedRoom.roomJbID substringToIndex:range.location];
//            }
//            NSString *serviceName  = [NSString stringWithFormat:WEBSERVICE_CHATROOMS@"%@/members/%@",roomName,myJID];
//            //        NSLog(@"print it %@", serviceName);
//            appDelegate.isUserLeaveOrBlock = true ;
            appDelegate.groupAdminName =  lblAdminOfGroup.text ;
            NSString   *myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", obj.speakerID];
            NSString *roomName ;
            NSRange range = [_selectedRoom.roomJbID rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                roomName = [_selectedRoom.roomJbID substringToIndex:range.location];
            }
            NSString *serviceName  = [NSString stringWithFormat:WEBSERVICE_CHATROOMS@"%@/members/%@",roomName,myJID];
            //        NSLog(@"print it %@", serviceName);
            //            app.groupAdminName =  lblAdminOfGroup.text ;
            
            [SVHTTPRequest DELETEXMPP:serviceName parameters:nil completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (error == nil) {
//                    [NotifCentre postNotificationName:kGroupChatUserBock object:obj];
                    
                    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                    loginResponse *objss = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
                    XMPPMessage *message = [[XMPPMessage alloc]init];
                    NSString *text ;
                    //            if (app.isUserLeaveOrBlock == true){
                    text = [NSString stringWithFormat:@"%@ %@ %@",obj.speakerFirstName, obj.speakerLastName ,@"has been blocked from group"] ; // enter the text in text field
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
                    NSXMLElement *outcast_id ;
                    NSXMLElement *actionUser_id ;
                    NSXMLElement *action_Id ;

                    
                    senderImage  =      [NSXMLElement elementWithName:@"sender_image" stringValue: objss.loginUserDP];
                    senderID     =      [NSXMLElement elementWithName:@"id" stringValue: str];
                    group_id     =      [NSXMLElement elementWithName:@"group_id" stringValue: _selectedRoom.roomJbID];
                    senderIDs    =      [NSXMLElement elementWithName:@"sender_id" stringValue: objss.loginUserID];
                    senderName   =      [NSXMLElement elementWithName:@"sender_name" stringValue: objss.loginDisplayName];
                    message_Type =      [NSXMLElement elementWithName:@"msg_type" stringValue: @"3"] ;
                    outcast_id   =      [NSXMLElement elementWithName:@"outcast_id" stringValue: [NSString stringWithFormat:@"%@", obj.speakerID]] ;
                    actionUser_id =     [NSXMLElement elementWithName:@"actioned_user_id" stringValue: [NSString stringWithFormat:@"%@", obj.speakerID]] ;
                    action_Id     =     [NSXMLElement elementWithName:@"action_id" stringValue: @"3"] ;


                    [attachment addChild:senderName];
                    [attachment addChild:senderID];
                    [attachment addChild:senderImage];
                    [attachment addChild:senderIDs];
                    [attachment addChild:message_Type];
                    [attachment addChild:outcast_id];
                    [attachment addChild:actionUser_id];
                    [attachment addChild:action_Id];

                    [attachment addChild:group_id];
                    [message    addBody:text];
                    [message    addChild:attachment];
                    [self.myroom sendMessage:message];

                    

                    
                    
                    //                    self.isBlockOrNot = true ;
                    //                    idOfUser = [NSString stringWithFormat:@"%@", obj.speakerID];
                    //                    [self getGroupDetail];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
//                                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                        [self.navigationController popViewControllerAnimated:true];
                    });
                    
                    //                    [self showAlertViewWithTitle:@"Alert" message:@"Leave Group Successfully"];
                    
                }
                NSDictionary *dict = (NSDictionary*)response;
                NSLog(@"here it is %@",dict);
                
                
            }] ;

            

//            dispatch_async(dispatch_get_main_queue(), ^(void) {
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//
//
//            });

        }
        
        else  if (buttonIndex == 1) {
            EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:_indexRow.row];
            YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
            vc.selectedSpeaker = obj ;
            vc.pushTypeGoldOrYpoMember = 4 ;
            [self.navigationController pushViewController:vc animated:true];

            
            
        } else if (buttonIndex == 0) {
            EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:_indexRow.row];
            AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
            //            EventSpeakerModel *model  =  (EventSpeakerModel *)[tempmasterObj. objectAtIndex:indexPath.row];
            vc.selectedSpeaker = obj ;
            [self.navigationController pushViewController:vc animated:true];

        }
        
    } else if (actionSheet.tag == 203) {
        if (buttonIndex == 1) {
            EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:_indexRow.row];
            YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
            vc.selectedSpeaker = obj ;
            vc.pushTypeGoldOrYpoMember = 4 ;
            [self.navigationController pushViewController:vc animated:true];
        } else if (buttonIndex == 0) {
            EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:_indexRow.row];
            AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
            //            EventSpeakerModel *model  =  (EventSpeakerModel *)[tempmasterObj. objectAtIndex:indexPath.row];
            vc.selectedSpeaker = obj ;
            [self.navigationController pushViewController:vc animated:true];
            
        }

    }
    
    
    
    else if (actionSheet.tag == 202){
        if (buttonIndex == 1) {
            EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:_indexRow.row];
            YPOChatViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
            vc.selectedSpeaker = obj ;
            vc.pushTypeGoldOrYpoMember = 4 ;
            [self.navigationController pushViewController:vc animated:true];
        } else if (buttonIndex == 0) {
            EventSpeakerModel *obj = (EventSpeakerModel *)[_allUserList objectAtIndex:_indexRow.row];
            AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
            //            EventSpeakerModel *model  =  (EventSpeakerModel *)[tempmasterObj. objectAtIndex:indexPath.row];
            vc.selectedSpeaker = obj ;
            [self.navigationController pushViewController:vc animated:true];

        }
        
        
    }

}


@end
