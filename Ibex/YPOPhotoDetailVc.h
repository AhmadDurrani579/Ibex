//
//  YPOPhotoDetailVc.h
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGetAllSupportingObject.h"
#import "EventSupportModel.h"
@interface YPOPhotoDetailVc : UIViewController

@property (nonatomic , strong) EventSupportModel *objFile ;
@property (nonatomic, strong) NSMutableArray *imagesToScroll;

@end
