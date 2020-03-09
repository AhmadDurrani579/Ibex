//
//  AgendaTableViewCell.h
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"

@interface AgendaTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet THLabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc2;
@property (weak, nonatomic)   IBOutlet UILabel *lblSessionNumber;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintTopLine;

@property (strong, nonatomic) IBOutlet UIScrollView *svSpeakers;
@property (strong, nonatomic) IBOutlet UIView *viewSpeakersIcons;
@property (weak, nonatomic) IBOutlet UILabel *lblTrackEvent;


@end
