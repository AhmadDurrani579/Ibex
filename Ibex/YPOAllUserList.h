//
//  YPOAllUserList.h
//  YPO
//
//  Created by Ahmed Durrani on 06/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPOAllUserList;

@protocol selectUserDelegate <NSObject>

-(void)addUser:(YPOAllUserList *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end

@interface YPOAllUserList : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageOfUser;
@property (strong, nonatomic) IBOutlet UILabel *nameOfUser;
@property (strong, nonatomic) IBOutlet UILabel *emialOfUser;

@property (strong, nonatomic) IBOutlet UIButton *btnOfImageSelected;

@property(assign , nonatomic) id<selectUserDelegate> delegate ;
@property(nonatomic , strong)NSIndexPath *index ;

@end
