//
//  YPOGroupDetailCell.m
//  YPO
//
//  Created by Ahmed Durrani on 25/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOGroupDetailCell.h"

@implementation YPOGroupDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnLeaveTheGroup:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnLeaveGroup:indexPathRow:)]) {
        [self.delegate btnLeaveGroup:self indexPathRow:self.index];
        
    }

    
}

@end
