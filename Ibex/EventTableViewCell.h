//
//  EventTableViewCell.h
//  Ibex
//
//  Created by Sajid Saeed on 30/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"

@interface EventTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet THLabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UIImageView *imgThumnail;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfGoldUser;
@property (strong, nonatomic) IBOutlet UIView *viewOfColouring;
@property (strong, nonatomic) IBOutlet UIImageView *imageOfColour;
@property (strong, nonatomic) IBOutlet UILabel *isPastOrFuture;
@property (strong, nonatomic) IBOutlet UIImageView *imageOfPastOrUpComping;



@end
