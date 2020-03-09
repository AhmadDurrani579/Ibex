//
//  YPOVideoDetailVc.h
//  Ibex
//
//  Created by Ahmed Durrani on 26/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObject.h"

@interface YPOVideoDetailVc : UIViewController

@property (nonatomic, strong) NSMutableArray *listOfVideo;
@property (nonatomic, strong) NSMutableArray *listOfThumbnail;
@property(nonatomic , strong) EventObject *supportingList ;


@end
