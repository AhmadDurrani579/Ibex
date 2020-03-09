//
//  GroupUserCell.h
//  YPO
//
//  Created by Ahmed Durrani on 02/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupUserCell;

@protocol selectUserForGroup <NSObject>
-(void)addUser:(GroupUserCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end

@interface GroupUserCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageOfUser;
@property (strong, nonatomic) IBOutlet UILabel *nameOfUser;
@property (strong, nonatomic) IBOutlet UIImageView *imageSelected;
@property (strong, nonatomic) IBOutlet UIButton *btnOfImageSelected;

@property(assign , nonatomic) id<selectUserForGroup> delegate ;
@property(nonatomic , strong)NSIndexPath *index ;

@end
