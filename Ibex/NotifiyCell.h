//
//  NotifiyCell.h
//  YPO
//
//  Created by Ahmed Durrani on 05/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifiyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageOfUser;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@end
