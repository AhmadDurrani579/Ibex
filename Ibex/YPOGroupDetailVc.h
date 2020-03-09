//
//  YPOGroupDetailVc.h
//  YPO
//
//  Created by Ahmed Durrani on 25/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRooms+CoreDataClass.h"
#import "XMPPRoom.h"
@interface YPOGroupDetailVc : UIViewController
@property(nonatomic , strong) ChatRooms *selectedRoom ;
@property (strong, nonatomic) NSMutableArray *groupMembersID;
@property(strong , nonatomic) NSString *ownerId ;
@property(strong , nonatomic) NSString *ownderAdminId ;
@property (nonatomic,strong) XMPPRoom *myroom;


@end
