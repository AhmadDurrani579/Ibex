//
//  YPODisplayDocument.h
//  Ibex
//
//  Created by Ahmed Durrani on 27/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventSupportModel.h"
#import "NewsLetterModelObject.h"
@interface YPODisplayDocument : UIViewController
@property(nonatomic , strong) EventSupportModel *allSupportableobj ;
@property(nonatomic , strong) NewsLetterModelObject *detailOfNewsLetter ;


@end
