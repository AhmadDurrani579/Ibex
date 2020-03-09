//
//  CustomButtonBookFont.m
//  Ibex
//
//  Created by Sajid Saeed on 18/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "CustomButtonBookFont.h"

@implementation CustomButtonBookFont

-(void) awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:self.titleLabel.font.pointSize];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
