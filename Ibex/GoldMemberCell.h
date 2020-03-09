//
//  GoldMemberCell.h
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGoldMember.h"
#import "MOGoldMemberObject.h"
#import "GetGoldMember+CoreDataClass.h"
@class GoldMemberCell;


@protocol MessageBtn_PressedDelegate <NSObject>

-(void)btnMessagePressedInGoldMember:(GoldMemberCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end

@interface GoldMemberCell : UITableViewCell
@property (nonatomic, strong) MOGoldMemberObject *goldMemberObj;
@property (nonatomic, strong) GetGoldMember *goldOfflineMember;

@property(assign , nonatomic) id<MessageBtn_PressedDelegate> delegate ;
@property(nonatomic , strong)NSIndexPath *index ;
@property (strong, nonatomic) IBOutlet UIButton *btnOfImageSelected;


@end
