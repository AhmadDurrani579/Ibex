//
//  YPOSenderPhotoCell.h
//  YPO
//
//  Created by Ahmed Durrani on 18/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPOSenderPhotoCell;


@protocol PhotoBrowser <NSObject>

-(void)btnPhotoBrowserPressed:(YPOSenderPhotoCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end


@interface YPOSenderPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageOfSenderSend;
@property(assign , nonatomic) id<PhotoBrowser> delegate ;
@property (strong, nonatomic) IBOutlet UIButton *btnPreviewPhoto_Pressed;
@property(nonatomic , strong)NSIndexPath *index ;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityStartIndicator;


@end
