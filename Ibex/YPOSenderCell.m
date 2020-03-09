//
//  YPOSenderCell.m
//  YPO
//
//  Created by Ahmed Durrani on 11/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSenderCell.h"

@implementation YPOSenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)prepareForReuse
{
    [super prepareForReuse];
//    _imageOfSender.image =  nil;
//    _textOfMessage.text = @"";
//    _lblDate.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
