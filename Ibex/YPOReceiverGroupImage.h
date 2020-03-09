//
//  YPOReceiverGroupImage.h
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPOReceiverGroupImage;


@protocol PhotoBrowserOfGroupReceiver <NSObject>
-(void)btnGroupPhotoBrowserPressed:(YPOReceiverGroupImage *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end

@interface YPOReceiverGroupImage : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageOfReciever;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfUser;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityStartIndicator;
@property (strong, nonatomic) IBOutlet UIButton *btnPreviewPhoto_Pressed;
@property(nonatomic , strong)NSIndexPath *index ;
@property(assign , nonatomic) id<PhotoBrowserOfGroupReceiver> delegate ;


@end
