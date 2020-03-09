//
//  YPOGroupRecentCell.h
//  YPO
//
//  Created by Ahmed Durrani on 23/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPOGroupRecentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblGroupName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLastMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfUser;


@end
