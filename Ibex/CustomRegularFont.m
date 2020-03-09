//
//  CustomRegularFont.m
//  Ibex
//
//  Created by Sajid Saeed on 18/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "CustomRegularFont.h"

@implementation CustomRegularFont

-(void) awakeFromNib{
    [super awakeFromNib];
    
    self.font = [UIFont fontWithName:@"Axiforma-Regular" size:self.font.pointSize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
