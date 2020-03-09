//
//  MediaCollectionCell.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MediaCollectionCell.h"

@implementation MediaCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _imageOfListes.image =  nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
