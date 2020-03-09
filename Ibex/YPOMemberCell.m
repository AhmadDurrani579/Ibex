//
//  YPOMemberCell.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOMemberCell.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"

@interface YPOMemberCell()
{
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblDesignation;
    __weak IBOutlet UIImageView *ImageOfMemberOfYPO;
    __weak IBOutlet UILabel *designation;

}

@end

@implementation YPOMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)btnMessage_Pressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnMesaage_YPOMember_Pressed:indexPathRow:)]) {
        [self.delegate btnMesaage_YPOMember_Pressed:self indexPathRow:_index];
        
        
    }
    
}

#pragma mark - Setter method of the MOGoldMember-

-(void)setGoldMemberObj:(MOGoldMemberObject *)goldMemberObj
{
    _goldMemberObj = goldMemberObj ;

    //        [self.btnTime setTitle:[NSString stringWithFormat:@"%@ - %@", eventObj.eventStartTime,eventObj.eventEndTime] forState:UIControlStateNormal] ;
    
    [lblName setText:[NSString stringWithFormat:@"%@ - %@", goldMemberObj.firstName , goldMemberObj.lastName]];
    
    [lblDesignation setText:goldMemberObj.company];
    [designation setText:goldMemberObj.jobtitle];

    
    NSString *imageURLString = [Utility getProductUrlForProductImagePath:goldMemberObj.dpPathThumb];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [ImageOfMemberOfYPO setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
    //    [ImageOfMemberOfGold setContentMode:UIViewContentModeScaleAspectFit];
    [Utility setViewCornerRadius:ImageOfMemberOfYPO radius:ImageOfMemberOfYPO.frame.size.width/2];
    
}



@end
