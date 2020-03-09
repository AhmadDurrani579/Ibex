//
//  EventSpeakerSessionViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSpeakerModel.h"
#import "ExtendedViewController.h"
#import "THLabel.h"

@interface EventSpeakerSessionViewController : ExtendedViewController


@property (strong, nonatomic) IBOutlet UITextView *tvBiography;
@property (strong, nonatomic) IBOutlet UITableView *tvSessions;
@property (strong, nonatomic) IBOutlet UIImageView *ivProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubheading1;
@property (strong, nonatomic) IBOutlet UILabel *lblSubHeading2;
@property (strong, nonatomic) EventSpeakerModel *selectedSpeaker;
@property (strong, nonatomic) IBOutlet UIView *viewMiddle;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomName;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomIndustry;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomJobtitle;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomJobFunction;

@end
