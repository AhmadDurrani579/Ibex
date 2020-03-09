//
//  EventCell.h
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPOScheduleObject.h"
@interface EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewOfShadow;

@property (nonatomic, strong) YPOScheduleObject *schedule;

@end
