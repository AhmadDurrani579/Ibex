//
//  AgendaViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 29/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedViewController.h"
#import "EventObject.h"
#import "YPOScheduleObject.h"
@interface AgendaViewController : ExtendedViewController
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topAlignmentConstraint;
@property (strong, nonatomic) IBOutlet UITableView *tvAgenda;
@property (nonatomic, strong) EventObject *eventObj;
@property (nonatomic, strong) YPOScheduleObject *schedule  ;
@property(nonatomic , assign) NSInteger vcPushType ;



@end
