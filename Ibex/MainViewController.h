//
//  MainViewController.h
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LGSideMenuController.h"
#import "EventObject.h"

@interface MainViewController : LGSideMenuController

@property (nonatomic, strong) EventObject *eventObj;

- (void)setupWithPresentationStyle:(LGSideMenuPresentationStyle)style
                              type:(NSUInteger)type;



@end
