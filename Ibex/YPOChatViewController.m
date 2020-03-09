//
//  YPOChatViewController.m
//  YPO
//
//  Created by Ahmed Durrani on 11/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOChatViewController.h"
#import "DBChatManager.h"
#import "MOMessage.h"
#import "EventAdd+CoreDataClass.h"
#import "CSGrowingTextView.h"
#import "YPOSenderCell.h"
#import "Constant.h"
#import "Chat+CoreDataClass.h"
#import "YPOReceiverCell.h"
#import "Utility.h"
#import "Webclient.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "TWMessageBarManager.h"
#import "UIViewController+Helper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "YPOSenderPhotoCell.h"
#import "YPOReceiverPhotoCell.h"
#import "IDMPhotoBrowser.h"
#import "IDMPhoto.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "NSDate+NVTimeAgo.h"
#import "Utility.h"
#import "UserProfileViewController.h"
#import "XMPPLastActivity.h"

@interface YPOChatViewController ()<CSGrowingTextViewDelegate , UITableViewDelegate , UITableViewDataSource , PhotoBrowser, PhotoBrowserOfReceiver, IDMPhotoBrowserDelegate>
{
    Chat *userChat ;
    loginResponse *userInfo ;
    AppDelegate *appDelegate ;

    IBOutlet UIButton *clearbtn_Pressed;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
//@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet CSGrowingTextView *growingTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *growingTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfUser;

@property (weak, nonatomic) IBOutlet UITableView *tbleView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign) BOOL isAnimated;
@property (strong, nonatomic) IBOutlet UIButton *btnChat;




@end

@implementation YPOChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isAnimated = false ;
    appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [self setNeedsStatusBarAppearanceUpdate];
    self.dataArray = [[NSMutableArray alloc] init];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOSenderCell" bundle:nil] forCellReuseIdentifier:@"YPOSenderCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOReceiverCell" bundle:nil] forCellReuseIdentifier:@"YPOReceiverCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOSenderPhotoCell" bundle:nil] forCellReuseIdentifier:@"YPOSenderPhotoCell"];
    [self.tbleView registerNib:[UINib nibWithNibName:@"YPOReceiverPhotoCell" bundle:nil] forCellReuseIdentifier:@"YPOReceiverPhotoCell"];
    
    _tbleView.rowHeight = UITableViewAutomaticDimension ;
    _tbleView.estimatedRowHeight = 100 ;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
       userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

    [NotifCentre addObserver:self selector:@selector(messageReceived:)  name:kChatMessageReceived object:nil];

    self.growingTextView.placeholderLabel.textColor = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1.0];
    
    self.growingTextView.placeholderLabel.text = @"Type a message" ;
    
    [Utility setViewBorder:self.growingTextView withWidth:2 andColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0]];
    self.growingTextView.delegate = self;
    if (_pushTypeGoldOrYpoMember == 1) {
        NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , self.selectGoldMember.ids] ;
        appDelegate.fromJabberId = self.selectGoldMember.ids ;
        [_lblName setText: [NSString stringWithFormat:@"%@ %@", self.selectGoldMember.firstName,self.selectGoldMember.lastName]];
        
        NSString *imageURLString = [Utility getProductUrlForProductImagePath:self.selectGoldMember.dpPathThumb];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [_imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:_imageOfUser radius:_imageOfUser.frame.size.width/2];
        [Chat save];
        NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
        self.dataArray = [arrayOfRecentUser mutableCopy];
        
        if (self.dataArray.count > 0) {
            [self.tbleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationFade];
        }
    } else if (_pushTypeGoldOrYpoMember == 2) {
        

        NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , _selectedUser.jaber_ID] ;
        appDelegate.fromJabberId = _selectedUser.jaber_ID ;

        NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
        
//        NSString  *myJID = [NSString stringWithFormat:@"%@@ibexglobal.com", _selectedUser.jaber_ID];
////        [XMPPJID jidWithString:FriendsJID]
        

//        XMPPJID *jid = [XMPPJID  jidWithString:myJID];
//        [[SharedDBChatManager xmppLastActivity] sendLastActivityQueryToJID:jid];
//        [[SharedDBChatManager xmppLastActivity] sendLastActivityQueryToJID:jid withTimeout:30.0];
        
        for (_userSelectedChat in arrayOfRecentUser) {
            
            _userSelectedChat.messageStatus = @"read" ;
        }
        [Chat save];

        _lblName.text = _selectedUser.sender_Name ;
        NSString *imageURLString = [Utility getProductUrlForProductImagePath:_selectedUser.sender_Image];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
     
        [_imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:_imageOfUser radius:_imageOfUser.frame.size.width/2];
//        [xmppStream sendElement:presence];
        [SharedDBChatManager lastSeen:[NSString stringWithFormat:@"%@@ibexglobal.com", _selectedUser.jaber_ID]];

        
        

        
        
        
        
        self.dataArray = [arrayOfRecentUser mutableCopy];
        if (self.dataArray.count > 0) {
            [self.tbleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationFade];
        }
        
    }
    
    else if (_pushTypeGoldOrYpoMember == 4) {

        NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , self.selectedSpeaker.speakerID] ;
        [_lblName setText: [NSString stringWithFormat:@"%@ %@", self.selectedSpeaker.speakerFirstName,self.selectedSpeaker.speakerLastName]];
        appDelegate.fromJabberId = self.selectedSpeaker.speakerID ;


        NSString *imageURLString = [Utility getProductUrlForProductImagePath:self.selectedSpeaker.speakerThumbImg];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [_imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:_imageOfUser radius:_imageOfUser.frame.size.width/2];
        
        //        _userSelectedChat.messageStatus = @"read";
        
        [Chat save];
        
        NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
        
        self.dataArray = [arrayOfRecentUser mutableCopy];
        if (self.dataArray.count > 0) {
            [self.tbleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationFade];
        }
    }
    else if (_pushTypeGoldOrYpoMember == 3) {
//        NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , _selectedUser.jaber_ID] ;
//        NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
//        _lblName.text = _selectedUser.name ;
//        //        _userSelectedChat.messageStatus = @"read";
//
//        //        [Chat save];
//
//
//        self.dataArray = [arrayOfRecentUser mutableCopy];
        
        NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , self.selectGoldMember.ids] ;
//        _lblName.text = self.selectGoldMember.firstName ;
        [_lblName setText: [NSString stringWithFormat:@"%@ %@", self.selectGoldMember.firstName,self.selectGoldMember.lastName]];
        appDelegate.fromJabberId = self.selectGoldMember.ids ;


        NSString *imageURLString = [Utility getProductUrlForProductImagePath:self.selectGoldMember.dpPathThumb];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [_imageOfUser setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
        [Utility setViewCornerRadius:_imageOfUser radius:_imageOfUser.frame.size.width/2];
        
        //        _userSelectedChat.messageStatus = @"read";
        
        [Chat save];
        
        NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
        
        self.dataArray = [arrayOfRecentUser mutableCopy];
        if (self.dataArray.count > 0) {
            [self.tbleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationFade];
        }
    }
  
    else {
        NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , _selectedUser.jaber_ID] ;
        NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
        appDelegate.fromJabberId =  _selectedUser.jaber_ID ;

//        _userSelectedChat.messageStatus = @"read";
//
//        [Chat save];

        self.dataArray = [arrayOfRecentUser mutableCopy];
        if (self.dataArray.count > 0) {
            [self.tbleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationFade];
        }
        
    }
//    Chat *profile = [Chat fetchWithPredicate:[NSPredicate predicateWithFormat:@"from_Jabber == %@", ] sortDescriptor:nil fetchLimit:0].lastObject;
    //        NSLog(@"print it %@", profile.chat_Id);
    //        NSLog(@"print it %@", profile.message);
    //        NSLog(@"print it %@", profile.to_Jabber);
    //        NSLog(@"print it %@", profile.from_Jabber);
    
    if (self.dataArray.count == 0){
        [clearbtn_Pressed setHidden:true];
    } else {
        [clearbtn_Pressed setHidden:false];

    }


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NotifCentre addObserver:self selector:@selector(presenceOnline:)   name:kPresenceUserOnline object:nil];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Chat Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    
}

#pragma mark - Message Received Notification -

- (void)presenceOnline:(NSNotification*)notif{
    if (notif.object) {
        XMPPPresence *presence = notif.object;
        if ([[[presence from] user] isEqualToString:_selectedUser.jaber_ID]) {
//            self.userOnline = true;
        }
    }
}

- (IBAction)btnUserProfileVc_Pressed:(UIButton *)sender {
    UserProfileViewController  *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"] ;
    vc.selectedVc = @"VCChat_Detail" ;
    if (_selectedSpeaker){
        vc.loginUserId = _selectedSpeaker.speakerID ;
        
    } else  if (_selectGoldMember){
        vc.loginUserId = _selectGoldMember.ids ;
    } else  {
        vc.loginUserId = _selectedUser.jaber_ID ;
        
    }
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btnClearChat:(UIButton *)sender {
    [self showConfirmationAlertViewWithTitle:@"YPO" message:@"Are you sure do you want to delete the Chat" withDismissCompletion:^{
        Roaster *user ;
        NSPredicate *Predicates ;
       if (_selectedSpeaker){
            Predicates = [NSPredicate predicateWithFormat:@"jaber_ID == %@" ,_selectedSpeaker.speakerID] ;
            NSArray *arrayOfObj  = [Roaster fetchWithPredicate:Predicates sortDescriptor:nil fetchLimit:0];
            user = (Roaster *)[arrayOfObj objectAtIndex:0];
           [Roaster deleteObject:user];
           
           for (_userSelectedChat in _dataArray) {
               [Chat deleteObject:_userSelectedChat];
           }
           [Chat save];

           
        } else if (_selectGoldMember) {
            Predicates = [NSPredicate predicateWithFormat:@"jaber_ID == %@" ,_selectGoldMember.ids] ;
            NSArray *arrayOfObj  = [Roaster fetchWithPredicate:Predicates sortDescriptor:nil fetchLimit:0];
            user = (Roaster *)[arrayOfObj objectAtIndex:0];
            [Roaster deleteObject:user];
            
            for (_userSelectedChat in _dataArray) {
                [Chat deleteObject:_userSelectedChat];
            }
            [Chat save];
            [self.navigationController popViewControllerAnimated:true];

        }
         if (_selectedUser){
            [Roaster deleteObject:_selectedUser];
            
            for (_userSelectedChat in _dataArray) {
                [Chat deleteObject:_userSelectedChat];
            }
            [Chat save];
            [self.navigationController popViewControllerAnimated:true];

        }
//         else {
//            NSPredicate *Predicate  = [NSPredicate predicateWithFormat:@"jaber_ID == %@" , _selectedUser.jaber_ID] ;
//            NSArray *arrayOfRecentUser = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
//
//            [Roaster deleteObject:user];
//
//            for (_userSelectedChat in arrayOfRecentUser) {
//                [Chat deleteObject:_userSelectedChat];
//            }
//            [Chat save];
//            [self.navigationController popViewControllerAnimated:true];
//        }
        
    }];
    

    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [NotifCentre postNotificationName:kChatNotificationRemoved object:nil];
   

    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.isViewVisible = false ;

    
    __weak id this = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      __strong YPOChatViewController *strongThis = this;
                                                      [strongThis keyboardWillAppearNotification:note];
                                                  }];
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
//    if  (_pushTypeGoldOrYpoMember == 1 ) {
//        [self dismissViewControllerAnimated:true completion:^{
//
//        }];
//
//    }else {
//        [self.navigationController popViewControllerAnimated:true];
//
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//- (BOOL)growingTextView:(CSGrowingTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//
//    if (text.length > 0) {
//        UIImage *buttonImage = [UIImage imageNamed:@"sendbtn"];
//        [_btnChat setImage:buttonImage forState:UIControlStateNormal];
//        } else {
//        UIImage *buttonImage = [UIImage imageNamed:@"send"];
//        [_btnChat setImage:buttonImage forState:UIControlStateNormal];
//        }
//    return  true ;
//}


//- (BOOL)growingTextViewShouldBeginEditing:(CSGrowingTextView *)textView {
//
//    return  true ;
//
//}



- (void)messageReceived:(NSNotification*)notif
{
    
    Chat *obj = notif.object ;
//    __block NSPredicate *Predicate ;
//    __block NSArray *arrayOfRecentUser ;
//     dispatch_async(dispatch_get_main_queue(), ^(void) {
//
//    if (_selectedUser){
//       Predicate = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , _selectedUser.jaber_ID] ;
//
//     arrayOfRecentUser   = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
//        self.dataArray = [arrayOfRecentUser mutableCopy];
//        [self.tbleView reloadData];
//
//    } else if (_selectedSpeaker){
//        Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" ,  self.selectedSpeaker.speakerID] ;
//
//        arrayOfRecentUser  = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
//        self.dataArray = [arrayOfRecentUser mutableCopy];
//
//        [self.tbleView reloadData];
//
//
//    } else if (_selectGoldMember){
//      Predicate  = [NSPredicate predicateWithFormat:@"from_Jabber == %@" , self.selectGoldMember.ids] ;
//
//      arrayOfRecentUser  = [Chat fetchWithPredicate:Predicate sortDescriptor:nil fetchLimit:0];
//        self.dataArray = [arrayOfRecentUser mutableCopy];
//        [self.tbleView reloadData];
//
//
//    }
//     });
//
//
////
//    [self.tbleView reloadData];
    _isAnimated = true ;

    dispatch_async(dispatch_get_main_queue(), ^(void) {

            [self.tbleView beginUpdates];
//
            NSIndexPath *row1 = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
            [self.dataArray insertObject:obj atIndex:_dataArray.count];
//
            [self.tbleView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];

            [self.tbleView endUpdates];
            if (self.dataArray.count == 0){
                [clearbtn_Pressed setHidden:true];
            } else {
            [clearbtn_Pressed setHidden:false];

        }
            if([self.tbleView numberOfRowsInSection:0]!=0)
            {
                NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbleView numberOfRowsInSection:0]-1 inSection:0];
                [self.tbleView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
            }});
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
                         
                         __strong YPOChatViewController *strongThis = this;
                         
                         self.contentViewBottomConstraint.constant = CGRectGetHeight(strongThis.view.bounds) - CGRectGetMaxY(frame);
                         [strongThis.contentView setNeedsUpdateConstraints];
                         [strongThis.contentView.superview layoutIfNeeded];
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
                      __strong YPOChatViewController *strongThis = this;
                        strongThis.growingTextViewHeightConstraint.constant = height;
                        [strongThis.growingTextView setNeedsUpdateConstraints];
                        [strongThis.growingTextView.superview layoutIfNeeded];
                     } completion:nil];
}


- (void)refreshMessages
{
    [self.tbleView reloadData];
    
    NSInteger section = [self numberOfSectionsInTableView:self.tbleView] - 1;
    NSInteger row     = [self tableView:self.tbleView numberOfRowsInSection:section] - 1;
    
    
    if([self.tbleView numberOfRowsInSection:0]!=0)
        {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbleView numberOfRowsInSection:0]-1 inSection:0];
        [self.tbleView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
//    if (row >= 0) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//        [self.tbleView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
}

- (IBAction)btnSend_Pressed:(UIButton *)sender {
    
    if([Utility connectedToNetwork]){
        if (self.growingTextView.internalTextView.text.length > 0){
            
            [SharedDBChatManager sendAndSaveMeesage:self.growingTextView.internalTextView.text andMessageType: MessageTypeText attendese:_selectedSpeaker modelType:self.selectGoldMember roasterLoadUser:self.selectedUser ofThread:userChat withCompletionHandler:^(Chat *soMessage, BOOL success) {
                
                self.growingTextView.internalTextView.text = @"";
                self.growingTextView.placeholderLabel.text = @"Type a message" ;
                
                if (success) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.tbleView beginUpdates];
                        
                        NSIndexPath *row1 = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
                        [self.dataArray insertObject:soMessage atIndex:_dataArray.count];
                        
                        [self.tbleView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
                        
                        [self.tbleView endUpdates];
                        //Always scroll the chat table when the user sends the message
                        if([self.tbleView numberOfRowsInSection:0]!=0)
                        {
                            NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbleView numberOfRowsInSection:0]-1 inSection:0];
                            [self.tbleView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
                        }
                    });
                }
            }];
        }
    } else {
        
        [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];

    }
    
   
    
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//
//
//
//}

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

- (void)sendImage:(UIImage *)image{
   
    [SharedDBChatManager sendAndSaveMeesage:image andMessageType: MessageTypeImage attendese:_selectedSpeaker modelType:self.selectGoldMember roasterLoadUser:self.selectedUser ofThread:userChat withCompletionHandler:^(Chat *soMessage, BOOL success) {

        if (success) {
//            [self.dataArray addObject:soMessage];

            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.tbleView beginUpdates];
                
                NSIndexPath *row1 = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
                [self.dataArray insertObject:soMessage atIndex:_dataArray.count];
                
                [self.tbleView insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
                
                [self.tbleView endUpdates];
                
                //Always scroll the chat table when the user sends the message
                if([self.tbleView numberOfRowsInSection:0]!=0)
                {
                    NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbleView numberOfRowsInSection:0]-1 inSection:0];
                    [self.tbleView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
                }
                
                
                //                [self refreshMessages];
            });
            [SVProgressHUD dismiss];

        }
    }];
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
    YPOReceiverCell *receiveCell = (YPOReceiverCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOReceiverCell" forIndexPath:indexPath];
    
    YPOSenderCell *cell = (YPOSenderCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOSenderCell" forIndexPath:indexPath];
   
    YPOSenderPhotoCell *photoSenderCell = (YPOSenderPhotoCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOSenderPhotoCell" forIndexPath:indexPath];
   
    YPOReceiverPhotoCell *photoReceiverCell = (YPOReceiverPhotoCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOReceiverPhotoCell" forIndexPath:indexPath];
    Chat *obj ;
    if (self.dataArray.count > 0) {
      obj  = (Chat *)[self.dataArray objectAtIndex:indexPath.row];
    }
    
    if ([obj.messageType  isEqual: MessageTypeImage]) {
         if (obj.is_Mine == true) {
             NSData *data = obj.image ;
             photoReceiverCell.delegateOfReceiver = self ;
             photoReceiverCell.index = indexPath ;

             UIImage *image = [UIImage imageWithData:data];
             photoReceiverCell.imageOfReceiverSend.image = image ;
             return  photoReceiverCell ;
         }else  {

//             NSData *data = obj.image ;
             
//             UIImage *image = [UIImage imageWithData:data];
             photoSenderCell.delegate = self ;
             photoSenderCell.index = indexPath ;
             NSURL *imageURL = [NSURL URLWithString:obj.imageUrl];

//             NSURL *imageURL = [NSURL URLWithString:imageURLString];
             NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
             [photoSenderCell.activityStartIndicator startAnimating];
             photoSenderCell.btnPreviewPhoto_Pressed.userInteractionEnabled = false ;
             [photoSenderCell.imageOfSenderSend setImageWithURLRequest:request
                                           placeholderImage:[UIImage imageNamed:@"imgplaceholder"]
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             [photoSenderCell.activityStartIndicator stopAnimating];
            photoSenderCell.btnPreviewPhoto_Pressed.userInteractionEnabled = true ;

             photoSenderCell.imageOfSenderSend.image = image;
             }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                        [photoSenderCell.activityStartIndicator stopAnimating];
                                                    }];
             
             

             return photoSenderCell ;
         }
        }
    else {
         if (obj.is_Mine == true) {
         
            receiveCell.lblTextInput.text = obj.message ;
             NSString *mysqlDatetime = obj.dateOfMessage ;
             NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];

            receiveCell.lblTime.text = timeAgoFormattedDate ;
            if(![Utility isEmptyOrNull:_selectedSpeaker.speakerThumbImg]){
                NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[_selectedSpeaker.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                NSURL *imageURL = [NSURL URLWithString:imageURLString];
                
                receiveCell.imageOfReciever.layer.cornerRadius = receiveCell.imageOfReciever.frame.size.height/2;
                receiveCell.imageOfReciever.clipsToBounds = YES;
                
                //            receiveCell.imageOfReciever.layer.cornerRadius = receiveCell.frame.size.height/2;
                //            receiveCell.imageOfReciever.layer.masksToBounds = YES;
                
                
                //            receiveCell.imageOfReciever.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
                
                [receiveCell.imageOfReciever setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];

            }
                return  receiveCell ;
            
        }
        else {
            
            cell.textOfMessage.text  =  obj.message ;
            
            NSString *mysqlDatetime = obj.dateOfMessage ;
            NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];

//            receiveCell.lblTime.text = timeAgoFormattedDate ;
            cell.lblDate.text        =  timeAgoFormattedDate ;
            NSString *imageURLString =  [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[userInfo.loginUserDP stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSURL *imageURL          =  [NSURL URLWithString:imageURLString];
            
            cell.imageOfSender.layer.cornerRadius = cell.imageOfSender.frame.size.height/2;
            cell.imageOfSender.clipsToBounds = YES;
            [cell.imageOfSender setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
            //        imageOfSender
            return  cell ;

//            receiveCell.lblTextInput.text = obj.message ;
//            receiveCell.lblTime.text = obj.dateOfMessage ;
//            if(![Utility isEmptyOrNull:_selectedSpeaker.speakerThumbImg]){
//                NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[_selectedSpeaker.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
//                NSURL *imageURL = [NSURL URLWithString:imageURLString];
//
//                receiveCell.imageOfReciever.layer.cornerRadius = receiveCell.imageOfReciever.frame.size.height/2;
//                receiveCell.imageOfReciever.clipsToBounds = YES;
//
//                //            receiveCell.imageOfReciever.layer.cornerRadius = receiveCell.frame.size.height/2;
//                //            receiveCell.imageOfReciever.layer.masksToBounds = YES;
//
//
//                //            receiveCell.imageOfReciever.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
//
//                [receiveCell.imageOfReciever setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
//                //            [receiveCell.imageOfReciever setContentMode:UIViewContentModeScaleAspectFill];
//                //            receiveCell.imageOfReciever.layer.cornerRadius = receiveCell.frame.size.height/2 ;
//                //             receiveCell.imageOfReciever.layer.masksToBounds = YES;
//            }
//            return  receiveCell ;
//
        }

    }
    }
//}

-(void)btnPhotoBrowserPressedReciver:(YPOReceiverPhotoCell *)cell indexPathRow:(NSIndexPath *)indexPathRow    {
    
    UIImageView *imageView = cell.imageOfReceiverSend;
    MOMessage *msg = [[MOMessage alloc] init];
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
    if (photos.count > 0) {
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
    

//    YPOChatViewController *chatVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
//    NSString* letter = [_dataArray objectAtIndex:indexPathRow.row];
//    NSArray* arrayForLetter = (NSArray*)[_filteredTableData objectForKey:letter];
//    EventSpeakerModel *obj  =  (EventSpeakerModel *)[arrayForLetter objectAtIndex:indexPathRow.row];
//    chatVc.selectedSpeaker = obj ;
//    [self.navigationController pushViewController:chatVc animated:true];

    
}

-(void)btnPhotoBrowserPressed:(YPOSenderPhotoCell *)cell indexPathRow:(NSIndexPath *)indexPathRow {
    UIImageView *imageView = cell.imageOfSenderSend;
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

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Chat *obj ;
    if (self.dataArray.count > 0) {
        obj  = (Chat *)[self.dataArray objectAtIndex:indexPath.row];
    }
    
    if (obj.is_Mine == true) {
        
    } else {
        
        if (_isAnimated == true){
            CGRect frame = cell.frame ;
            [cell setFrame:CGRectMake(0, self.tbleView.frame.size.height, frame.size.width , frame.size.height)];
            //    [cell setFrame:CGRectMake(0, self.tbleView.frame.size.height, frame.width, frame.height)];
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve  animations:^{
                [cell setFrame:frame];
            } completion:^(BOOL finished) {
            }];
        }
        

    }
}



@end
