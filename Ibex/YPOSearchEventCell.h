//
//  YPOSearchEventCell.h
//  YPO
//
//  Created by Ahmed Durrani on 24/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YPOSearchEventCell;


@protocol ChatBtn_PressedDelegate <NSObject>
-(void)btnChat_Pressed:(YPOSearchEventCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end

@interface YPOSearchEventCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblNameOfEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeOfEvent;
@property (strong, nonatomic) IBOutlet UIImageView *imageOfEvent;

@property (strong, nonatomic) IBOutlet UIButton *btnChat_Pressed;

@property(assign , nonatomic) id<ChatBtn_PressedDelegate> delegate ;
@property(nonatomic , strong)NSIndexPath *index ;


@end
