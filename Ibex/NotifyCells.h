//
//  NotifyCells.h
//  YPO
//
//  Created by Ahmed Durrani on 08/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SWTableViewCell.h"
#import "MONotificationObject.h"
@interface NotifyCells : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageOfUser;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) MONotificationObject *notify;

@end
