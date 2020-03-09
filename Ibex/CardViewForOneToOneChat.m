//
//  CardViewForOneToOneChat.m
//  YPO
//
//  Created by Ahmed Durrani on 23/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "CardViewForOneToOneChat.h"

@implementation CardViewForOneToOneChat

static CGFloat radius = 20;

static int shadowOffsetWidth = 0;
static int shadowOffsetHeight = 2;
static float shadowOpacity = 0.2;

-(void)layoutSubviews{
    self.layer.cornerRadius = radius;
    UIBezierPath *shadowPath = [UIBezierPath
                                bezierPathWithRoundedRect: self.bounds
                                cornerRadius: radius];
    
    
    self.layer.masksToBounds = false;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(shadowOffsetWidth, shadowOffsetHeight);
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowPath = shadowPath.CGPath;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}

@end
