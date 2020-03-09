//
//  UIBarButtonItem+UDBarButtonItem.h
//  Poice
//
//  Created by Uzair Danish on 10/09/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (UDBarButtonItem)

+ (UIBarButtonItem *)customBarButtonItemWithTarget:(id)target action:(SEL)action withButtonImage:(NSString *)buttonImageName;

+ (UIBarButtonItem *)notificationBarButtonItemWithTarget:(id)target action:(SEL)action withButtonImage:(NSString *)buttonImage withButtonTitle:(NSString *)buttonTitle withNumber:(NSString *)number;

+ (UIBarButtonItem *)notificationBarButtonItemWithTargetAndLargeSize:(id)target action:(SEL)action withButtonImage:(NSString *)buttonImageName withButtonTitle:(NSString *)buttonTitle withNumber:(NSString *)number;

@end
