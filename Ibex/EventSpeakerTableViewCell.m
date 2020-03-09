//
//  EventSpeakerTableViewCell.m
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSpeakerTableViewCell.h"

@implementation EventSpeakerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnMessage_Pressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnMessage_Pressed:indexPathRow:)]) {
        [self.delegate btnMessage_Pressed:self indexPathRow:self.index];
        
    }

}

@end
