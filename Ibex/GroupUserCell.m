//
//  GroupUserCell.m
//  YPO
//
//  Created by Ahmed Durrani on 02/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "GroupUserCell.h"

@implementation GroupUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)btnSelecttion:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(addUser:indexPathRow:)]) {
        [self.delegate addUser:self indexPathRow:self.index];
    }

}

@end
