//
//  UDNavigationController.h
//  Poice
//
//  Created by Uzair Danish on 13/09/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UDNavigationController : UINavigationController<UINavigationControllerDelegate>

- (id)initWithRootViewController:(UIViewController *)rootViewController withNavigationBarBackground:(NSString *)backgroundImageName withNavigationBarBackButtonImage:(NSString *)backButtonImageName;
- (void)navigationBarSetBackground:(NSString *)imageName;
- (void)navigationBarSetBackButtonImage:(NSString *)imageName;
- (void)navigationBarSetNavigationButtonImage:(NSString *)imageName;
- (void)navigationBarSetTitleTextAttribute:(UIFont *)textFont TextColor:(UIColor *)textColor TextShadowColor:(UIColor *)textShadowColor TextShadowOffset:(NSValue *)valueWithOffset;
-(void) navigationBarSetFont:(NSString*)fontName fontSize:(float)fontSize;


@end
