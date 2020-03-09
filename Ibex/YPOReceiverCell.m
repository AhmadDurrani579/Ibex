//
//  YPOReceiverCell.m
//  YPO
//
//  Created by Ahmed Durrani on 11/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOReceiverCell.h"

@implementation YPOReceiverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)prepareForReuse
{
    [super prepareForReuse];
//    _imageOfReciever.image =  nil;
//    _lblTextInput.text = @"";
//    _lblTime.text = @"";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
