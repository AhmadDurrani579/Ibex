//
//  ImagesCollectionCell.h
//  Ibex
//
//  Created by Ahmed Durrani on 27/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageOfCollection;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
