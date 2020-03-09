//
//  EventsCell.h
//  Ibex
//
//  Created by Ahmed Durrani on 02/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SWTableViewCell.h"
#import "EventObject.h"

@interface EventsCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewOfShadow;

@property (nonatomic, strong) EventObject *schedule;


@end
