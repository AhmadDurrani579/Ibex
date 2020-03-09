//
//  GoldMemberCell.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "GoldMemberCell.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
@interface GoldMemberCell()
{
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblDesignation;
    __weak IBOutlet UIImageView *ImageOfMemberOfGold;
    
    __weak IBOutlet UILabel *designation;
}

@end

@implementation GoldMemberCell


#pragma mark - Setter method of the MOGoldMember-

- (IBAction)btnMessage_Pressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnMessagePressedInGoldMember:indexPathRow:)]) {
        [self.delegate btnMessagePressedInGoldMember:self indexPathRow:_index];
        
        
    }
    
}

-(void) setGoldOfflineMember:(GetGoldMember *)goldOfflineMember {
    _goldOfflineMember = goldOfflineMember ;
    [lblName setText:[NSString stringWithFormat:@"%@  %@", _goldOfflineMember.firstName , _goldOfflineMember.lastName]];
    [designation setText:_goldOfflineMember.jobtitle];
    //    NSString *aString = goldMemberObj.company;
    
    if ([_goldOfflineMember.company isEqual: [NSNull null]]) {
        
    }else {
        NSString *designation = _goldOfflineMember.company ;
        lblDesignation.text = designation ;
        
    }
    
    //    [lblDesignation setText:goldMemberObj.company];
    
    NSString *imageURLString = [Utility getProductUrlForProductImagePath:_goldOfflineMember.dpPathThumb];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [ImageOfMemberOfGold setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
    //    [ImageOfMemberOfGold setContentMode:UIViewContentModeScaleAspectFit];
    [Utility setViewCornerRadius:ImageOfMemberOfGold radius:ImageOfMemberOfGold.frame.size.width/2];

}


-(void)setGoldMemberObj:(MOGoldMemberObject *)goldMemberObj
{
    _goldMemberObj = goldMemberObj ;
    [lblName setText:[NSString stringWithFormat:@"%@  %@", goldMemberObj.firstName , goldMemberObj.lastName]];
    [designation setText:goldMemberObj.jobtitle];
//    NSString *aString = goldMemberObj.company;

    if ([goldMemberObj.company isEqual: [NSNull null]]) {
        
    }else {
        NSString *designation = goldMemberObj.company ;
        lblDesignation.text = designation ;

    }

//    [lblDesignation setText:goldMemberObj.company];

    NSString *imageURLString = [Utility getProductUrlForProductImagePath:goldMemberObj.dpPathThumb];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [ImageOfMemberOfGold setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
//    [ImageOfMemberOfGold setContentMode:UIViewContentModeScaleAspectFit];
    [Utility setViewCornerRadius:ImageOfMemberOfGold radius:ImageOfMemberOfGold.frame.size.width/2];

}

@end
