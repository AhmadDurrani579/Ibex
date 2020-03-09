//
//  YPOSenderCell.h
//  YPO
//
//  Created by Ahmed Durrani on 11/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPOSenderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textOfMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfSender;

@end
