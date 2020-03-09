//
//  YPOReceiverPhotoCell.m
//  YPO
//
//  Created by Ahmed Durrani on 18/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOReceiverPhotoCell.h"

@implementation YPOReceiverPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [super prepareForReuse];
//    _imageOfReceiverSend.image =  nil;
}

- (IBAction)btnReceiverBtnClick:(UIButton *)sender {
   
    if (self.delegateOfReceiver && [self.delegateOfReceiver respondsToSelector:@selector(btnPhotoBrowserPressedReciver:indexPathRow:)]) {
        [self.delegateOfReceiver btnPhotoBrowserPressedReciver:self indexPathRow:self.index];
    }

}

@end
