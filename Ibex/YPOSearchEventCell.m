//
//  YPOSearchEventCell.m
//  YPO
//
//  Created by Ahmed Durrani on 24/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSearchEventCell.h"

@implementation YPOSearchEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnChat_Pressed:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnChat_Pressed:indexPathRow:)]) {
        [self.delegate btnChat_Pressed:self indexPathRow:self.index];
        }
    
}

@end
