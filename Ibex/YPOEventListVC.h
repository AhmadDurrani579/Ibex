//
//  YPOEventListVC.h
//  YPO
//
//  Created by Ahmed Durrani on 24/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventListResponse.h"
@interface YPOEventListVC : UIViewController
@property (nonatomic , strong) EventListResponse *event ;
@property (nonatomic , assign) NSInteger pushType ;
@property(nonatomic , strong) NSString *titleOfView ;


@end
