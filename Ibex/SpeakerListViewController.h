//
//  SpeakerListViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgendaSessionModel.h"
#import "ExtendedViewController.h"

@interface SpeakerListViewController : ExtendedViewController

@property (strong, nonatomic) IBOutlet UITableView *tvSpeakerList;
@property (strong, nonatomic) AgendaSessionModel *sessionObj;

@end
