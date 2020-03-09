//
//  YPOMemberCell.h
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPOMemberCell;


@protocol MessageBtn_YPOMemberDelegate <NSObject>

-(void)btnMesaage_YPOMember_Pressed:(YPOMemberCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end
#import "MOGoldMemberObject.h"

@interface YPOMemberCell : UITableViewCell
@property (nonatomic, strong) MOGoldMemberObject *goldMemberObj;
@property(assign , nonatomic) id<MessageBtn_YPOMemberDelegate> delegate ;
@property(nonatomic , strong)NSIndexPath *index ;

@end
