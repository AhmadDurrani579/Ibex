//
//  YPOGroupMessageSenderCell.h
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPOGroupMessageSenderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTextInput;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UIImageView *imageOfReciever;

@end
