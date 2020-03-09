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
#import "MOGoldMemberObject.h"
@interface AttendeeSpeakerSessionViewController : ExtendedViewController

@property (strong, nonatomic) IBOutlet UIImageView *ivProfilePic;
@property (strong, nonatomic) EventSpeakerModel *selectedSpeaker;
@property (strong, nonatomic) MOGoldMemberObject *selectGoldMember;
@property(nonatomic , assign) NSInteger pushTypeGoldOrYpoMember ;
@property (strong, nonatomic) IBOutlet UIView *viewMiddle;
@property (strong, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfCompany;
@property (strong, nonatomic) IBOutlet UITextField *tfIndustry;
@property (strong, nonatomic) IBOutlet UITextField *tfJobtitle;
@property (strong, nonatomic) IBOutlet UITextField *tfJobFunction;

@end
