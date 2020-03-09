//
//  CustomTextViewBookFont.m
//  Ibex
//
//  Created by Sajid Saeed on 18/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "CustomTextViewBookFont.h"

@implementation CustomTextViewBookFont

-(void) awakeFromNib{
    [super awakeFromNib];
    [self setFont:[UIFont fontWithName:@"Axiforma-Book" size:14.0]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
