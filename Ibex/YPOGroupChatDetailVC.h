//
//  YPOGroupChatDetailVC.h
//  YPO
//
//  Created by Ahmed Durrani on 22/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRooms+CoreDataClass.h"
#import "GroupChatMessageStatus+CoreDataClass.h"

@interface YPOGroupChatDetailVC : UIViewController
@property(nonatomic , strong) ChatRooms *selectedRoom ;
@property(nonatomic , strong) GroupChatMessageStatus *messageStatusOfGroup ;

@end
