//
//  YPOFeatureCell.h
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObject.h"
#import "THLabel.h"

@interface YPOFeatureCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UIImageView *imgThumnail;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfFeatureEvent;
@property (strong, nonatomic) IBOutlet UIImageView *sideImage;

@property (weak, nonatomic) IBOutlet UIView *viewOfColour;
@property (nonatomic, strong) EventObject *eventList;

@end
