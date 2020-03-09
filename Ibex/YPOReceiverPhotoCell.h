//
//  YPOReceiverPhotoCell.h
//  YPO
//
//  Created by Ahmed Durrani on 18/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPOReceiverPhotoCell;


@protocol PhotoBrowserOfReceiver <NSObject>

-(void)btnPhotoBrowserPressedReciver:(YPOReceiverPhotoCell *)cell indexPathRow:(NSIndexPath *)indexPathRow;
@end


@interface YPOReceiverPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageOfReceiverSend;
@property(assign , nonatomic) id<PhotoBrowserOfReceiver> delegateOfReceiver ;
@property(nonatomic , strong)NSIndexPath *index ;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityStartIndicator;
@property (strong, nonatomic) IBOutlet UIButton *btnPreviewPhoto_Pressed;

@end
