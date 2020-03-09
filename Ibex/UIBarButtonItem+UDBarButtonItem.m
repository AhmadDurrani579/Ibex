//
//  UIBarButtonItem+UDBarButtonItem.m
//  Poice
//
//  Created by Uzair Danish on 10/09/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import "UIBarButtonItem+UDBarButtonItem.h"
#import "Utility.h"

@implementation UIBarButtonItem (UDBarButtonItem)

+ (UIBarButtonItem *)customBarButtonItemWithTarget:(id)target action:(SEL)action withButtonImage:(NSString *)buttonImageName
{
    if ([Utility systemVersionGreaterThanOrEqualTo:@"7.0"])
        buttonImageName = [NSString stringWithFormat:@"%@-568h",buttonImageName];
    
    UIImage *buttonImage = [UIImage imageNamed:buttonImageName];
    
    //create the button and assign the image
    UIButton *buttonTarget = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTarget setImage:buttonImage forState:UIControlStateNormal];
    buttonTarget.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [buttonTarget addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:buttonTarget];
    [customBarItem setWidth:buttonImage.size.width];
    [customBarItem setStyle:UIBarButtonItemStylePlain];
    
    return customBarItem;
}


+ (UIBarButtonItem *)notificationBarButtonItemWithTarget:(id)target action:(SEL)action withButtonImage:(NSString *)buttonImageName withButtonTitle:(NSString *)buttonTitle withNumber:(NSString *)number
{
    UIImage *buttonImage = [UIImage imageNamed:buttonImageName];
    
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)];
    [notificationView setBackgroundColor:[UIColor clearColor]];
    
    //create the button and assign the image
    UIButton *buttonTarget = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTarget setImage:buttonImage forState:UIControlStateNormal];
    buttonTarget.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [buttonTarget addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [notificationView addSubview:buttonTarget];
    
    //create the Label and assign the text
    UILabel *notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)];
    [notificationLabel setText:number];
    [notificationLabel setBackgroundColor:[UIColor clearColor]];
    [notificationLabel setTextAlignment:NSTextAlignmentCenter];
    [notificationLabel setTextColor:[UIColor whiteColor]];
    [notificationLabel setAdjustsFontSizeToFitWidth:YES];
    [notificationLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
    [notificationView  addSubview:notificationLabel];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:notificationView];
    [customBarItem setWidth:buttonImage.size.width];
    [customBarItem setStyle:UIBarButtonItemStylePlain];
    
    return customBarItem;
}

+ (UIBarButtonItem *)notificationBarButtonItemWithTargetAndLargeSize:(id)target action:(SEL)action withButtonImage:(NSString *)buttonImageName withButtonTitle:(NSString *)buttonTitle withNumber:(NSString *)number
{
    UIImage *buttonImage = [UIImage imageNamed:buttonImageName];
    
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonImage.size.width+5, buttonImage.size.height+5)];
    [notificationView setBackgroundColor:[UIColor clearColor]];
    
    //create the button and assign the image
    UIButton *buttonTarget = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTarget setImage:buttonImage forState:UIControlStateNormal];
    buttonTarget.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [buttonTarget addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [notificationView addSubview:buttonTarget];
    
    //create the Label and assign the text
    UILabel *notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)];
    [notificationLabel setText:number];
    [notificationLabel setBackgroundColor:[UIColor clearColor]];
    [notificationLabel setTextAlignment:NSTextAlignmentCenter];
    [notificationLabel setTextColor:[UIColor whiteColor]];
    [notificationLabel setAdjustsFontSizeToFitWidth:YES];
    [notificationLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13.0]];
    [notificationView  addSubview:notificationLabel];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:notificationView];
    [customBarItem setWidth:buttonImage.size.width];
    [customBarItem setStyle:UIBarButtonItemStylePlain];
    
    return customBarItem;
}

@end
