//
//  YPONewsViewController.h
//  YPO
//
//  Created by Ahmed Durrani on 03/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventListResponse.h"
@interface YPONewsViewController : UIViewController
@property(nonatomic , assign) NSInteger vcPushType ;
@property (nonatomic , strong) EventListResponse *event ;
@property (nonatomic , strong) NSString *selectDoc ;

@end
