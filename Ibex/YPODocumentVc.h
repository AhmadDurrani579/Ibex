//
//  YPODocumentVc.h
//  Ibex
//
//  Created by Ahmed Durrani on 27/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventObject.h"
@interface YPODocumentVc : UIViewController
@property (nonatomic, strong) NSMutableArray *listOfDocument;
@property(nonatomic , strong) EventObject *supportingList ;

@end
