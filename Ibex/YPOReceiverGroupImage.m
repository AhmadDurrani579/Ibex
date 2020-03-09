//
//  YPOReceiverGroupImage.m
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOReceiverGroupImage.h"

@implementation YPOReceiverGroupImage

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnSenderCell:(UIButton *)sender {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnGroupPhotoBrowserPressed:indexPathRow:)]) {
        [self.delegate btnGroupPhotoBrowserPressed:self indexPathRow:self.index];
    }
}
@end
