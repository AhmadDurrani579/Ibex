//
//  YPOGroupDetailCell.h
//  YPO
//
//  Created by Ahmed Durrani on 25/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPOGroupDetailCell;


@protocol LeaveBtnPressedDelegate <NSObject>
-(void)btnLeaveGroup:(YPOGroupDetailCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end

@interface YPOGroupDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageOfUser;
@property (strong, nonatomic) IBOutlet UILabel *nameOfUser;
@property (strong, nonatomic) IBOutlet UILabel *emialOfUser;
@property (strong, nonatomic) IBOutlet UILabel *lblAdmin;
@property(nonatomic , strong)NSIndexPath *index ;
@property(assign , nonatomic) id<LeaveBtnPressedDelegate> delegate ;

@end
