//
//  EventSpeakerTableViewCell.h
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"
@class EventSpeakerTableViewCell;


@protocol MessageBtnDelegate <NSObject>

-(void)btnMessage_Pressed:(EventSpeakerTableViewCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end


@interface EventSpeakerTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet THLabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *subHeading1;
@property (strong, nonatomic) IBOutlet UILabel *subHeading2;
@property (strong, nonatomic) IBOutlet UILabel *subHeading3;
@property (strong, nonatomic) IBOutlet UIImageView *ivUserPic;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property(assign , nonatomic) id<MessageBtnDelegate> delegate ;
@property(nonatomic , strong)NSIndexPath *index ;


@end
