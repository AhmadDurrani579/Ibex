//
//  EventDetailViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 03/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedViewController.h"
#import "EventObject.h"
#import "THLabel.h"
#import "YPOScheduleObject.h"
#import "IsJoinedResponsed.h"

@interface EventDetailViewController : ExtendedViewController


@property (nonatomic, strong) EventObject *eventObj;
@property (nonatomic, strong) YPOScheduleObject *scheduleObj ;
@property (nonatomic, strong) IsJoinedResponsed *joinResponse ;




@property (strong, nonatomic) IBOutlet UIImageView *ivLogi;
@property (strong, nonatomic) IBOutlet THLabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *tvDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLocationName;
@property (strong, nonatomic) IBOutlet UIButton *btnJoin;
@property BOOL isJoinButton;
@property BOOL isPrevious;
@property BOOL isUserAlreadyRegister;

@property (strong, nonatomic) IBOutlet UIView *viewApproved;
@property (strong, nonatomic) IBOutlet UILabel *lblEventTopic;
@property (strong, nonatomic) IBOutlet UILabel *lblRegistrationType;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;
@property (weak, nonatomic) IBOutlet UIButton *btnLocationName;
@property(nonatomic , assign) NSInteger pushType ;


@end
