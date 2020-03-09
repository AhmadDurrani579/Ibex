//
//  YPOSenderImageGroup.m
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSenderImageGroup.h"

@implementation YPOSenderImageGroup

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)btnSenderCell:(UIButton *)sender {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnPhotoBrowserPressed:indexPathRow:)]) {
        [self.delegate btnPhotoBrowserPressed:self indexPathRow:self.index];
    }
}
@end
