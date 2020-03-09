//
//  EventDetailDocViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 19/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedViewController.h"

@interface EventDetailDocViewController : ExtendedViewController<UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tvSupport;
@property (strong, nonatomic) IBOutlet UIImageView *ivEventImage;
@property (strong, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEventTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEventDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEventLoc;
@property (strong, nonatomic) IBOutlet UITextView *tvEventDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblSessionCount;
@property (strong, nonatomic) IBOutlet UILabel *lblTrackCount;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerCount;
@property (strong, nonatomic) IBOutlet UILabel *lblEventType;
@property (strong, nonatomic) IBOutlet UILabel *lblEventTopic;
@property (strong, nonatomic) IBOutlet UILabel *lblRegistrationType;

@end
