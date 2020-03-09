//
//  YPOSenderImageGroup.h
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPOSenderImageGroup;


@protocol PhotoBrowserOfGroupSender <NSObject>

-(void)btnPhotoBrowserPressed:(YPOSenderImageGroup *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end


@interface YPOSenderImageGroup : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageOfSenderSend;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfUser;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityStartIndicator;
@property(assign , nonatomic) id<PhotoBrowserOfGroupSender> delegate ;
@property (strong, nonatomic) IBOutlet UIButton *btnPreviewPhoto_Pressed;
@property(nonatomic , strong)NSIndexPath *index ;




@end
