//
//  UDNavigationBar.h
//  Poice
//
//  Created by Uzair Danish on 09/09/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UDNavigationBar : UINavigationBar

+ (void)navigationBarSetBackground:(NSString *)imageName;
+ (void)navigationBarSetBackButtonImage:(NSString *)imageName;
+ (void)navigationBarSetNavigationButtonImage:(NSString *)imageName;
+ (void)navigationBarSetTitleImage:(NSString *)imageName;

@end
