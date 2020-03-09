//
//  YPOFeatureCell.m
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOFeatureCell.h"

@implementation YPOFeatureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setEventList:(EventObject *)eventList
{
    _eventList = eventList ;
  
    
}
@end
