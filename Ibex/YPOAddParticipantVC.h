//
//  YPOAddParticipantVC.h
//  YPO
//
//  Created by Ahmed Durrani on 25/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRooms+CoreDataClass.h"

@protocol AllUserDelegate <NSObject>
-(void)userArray:(NSString *)arrayOfValue ;
@end

@interface YPOAddParticipantVC : UIViewController

@property(nonatomic , strong) ChatRooms *selectedRoom ;
@property(nonatomic , strong) NSString *allUserId ;
@property (strong, nonatomic) NSMutableArray *groupUserId;
@property(assign , nonatomic) id<AllUserDelegate> delegate ;
@property(nonatomic , strong) NSString *ownerName ;
@property(nonatomic , strong) NSString *adMinId ;
@property(nonatomic , strong) NSString *roomName ;





@end
