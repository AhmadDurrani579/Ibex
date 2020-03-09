//
//  YPOSenderPhotoCell.m
//  YPO
//
//  Created by Ahmed Durrani on 18/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSenderPhotoCell.h"

@implementation YPOSenderPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)prepareForReuse
{
    [super prepareForReuse];
//    _imageOfSenderSend.image =  nil;
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
