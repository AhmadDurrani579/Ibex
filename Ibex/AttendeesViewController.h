//
//  AttendeesViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 29/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedViewController.h"
#import "AttendessResponse.h"
@interface AttendeesViewController : ExtendedViewController

@property (strong, nonatomic) IBOutlet UITableView *tvAttendees;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topAlignmentConstraint;
@property(nonatomic , strong) AttendessResponse *masterObj;



@end
