//
//  YPOMapViewController.h
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObject.h"
#import "YPOScheduleObject.h"
@interface YPOMapViewController : UIViewController
@property (nonatomic, strong) EventObject *eventObj;
@property (nonatomic, strong) YPOScheduleObject *scheduleObj;

@property (nonatomic, assign) NSInteger  selectedVc ;


@end
