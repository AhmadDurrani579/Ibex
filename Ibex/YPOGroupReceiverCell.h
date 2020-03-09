//
//  YPOGroupReceiverCell.h
//  YPO
//
//  Created by Ahmed Durrani on 22/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPOGroupReceiverCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameOfUser;
@property (strong, nonatomic) IBOutlet UILabel *messageOfUser;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *imageOfReceiver;

@end
