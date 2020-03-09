//
//  YPORecentCells.h
//  YPO
//
//  Created by Ahmed Durrani on 15/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SWTableViewCell.h"

@interface YPORecentCells : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLastMessage;
@property (strong, nonatomic) IBOutlet UIImageView *imageOfUser;
@property (strong, nonatomic) IBOutlet UIButton *btnNotificationDisplay;

@end
