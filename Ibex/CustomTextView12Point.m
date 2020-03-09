//
//  CustomTextView12Point.m
//  Ibex
//
//  Created by Sajid Saeed on 21/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "CustomTextView12Point.h"

@implementation CustomTextView12Point

-(void) awakeFromNib{
    [super awakeFromNib];
    [self setFont:[UIFont fontWithName:@"Axiforma-Book" size:12.0]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
