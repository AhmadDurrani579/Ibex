//
//  UDNavigationBar.m
//  Poice
//
//  Created by Uzair Danish on 09/09/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import "UDNavigationBar.h"


@implementation UDNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (id)initWithRootViewController:(UIViewController *)rootViewController{

    self = [super init];
    
    return self;
}

+ (void)navigationBarSetBackground:(NSString *)imageName{

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:imageName] forBarMetrics:UIBarMetricsDefault];
}

+ (void)navigationBarSetBackButtonImage:(NSString *)imageName{

    UIImage *backButtonImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    
}

+ (void)navigationBarSetNavigationButtonImage:(NSString *)imageName{

    UIImage *barButtonImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

}



+ (void)navigationBarSetTitleImage:(NSString *)imageName{

    UIView *titleImage;
    [titleImage setFrame:CGRectMake(0, 0, 320, 50)];
    [titleImage setBackgroundColor:[UIColor redColor]];
    [titleImage setTag:100];
    [[UINavigationBar appearance] addSubview:titleImage];
    [titleImage bringSubviewToFront:[UINavigationBar appearance]];
    
    /*
    if ( [[UINavigationBar appearance] viewWithTag:100] ){
        titleImage = (UIImageView *)[[UINavigationBar appearance] viewWithTag:100];
    }
    
    else{
        [titleImage setFrame:CGRectMake(30, 0, 50, 50)];
        [titleImage setBackgroundColor:[UIColor redColor]];
        [titleImage setTag:100];
        [[UINavigationBar appearance] addSubview:titleImage];
    }
     */
}

@end
