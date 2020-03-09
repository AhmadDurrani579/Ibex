//
//  YPOAllUserList.m
//  YPO
//
//  Created by Ahmed Durrani on 06/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOAllUserList.h"

@implementation YPOAllUserList

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnSelecttion:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(addUser:indexPathRow:)]) {
        [self.delegate addUser:self indexPathRow:self.index];
    }
    
}


@end
