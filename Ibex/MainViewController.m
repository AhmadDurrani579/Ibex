//
//  MainViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 25.04.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "SideMenuViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (strong, nonatomic) SideMenuViewController *leftViewController;
@property (strong, nonatomic) SideMenuViewController *rightViewController;
@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainViewController

- (void)setupWithPresentationStyle:(LGSideMenuPresentationStyle)style
                              type:(NSUInteger)type
{
    _leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SideMenuVC"];
    _rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SideMenuVC"];

    
    
    
    [self setLeftViewEnabledWithWidth:310.0f
                    presentationStyle:style
                 alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnPhoneLandscape|LGSideMenuAlwaysVisibleOnPadLandscape];
    
    //self.leftViewStatusBarStyle = UIStatusBarStyleDefault;
    //self.leftViewStatusBarVisibleOptions = LGSideMenuAlwaysVisibleOnPadLandscape;
   // self.leftViewBackgroundImage = [UIImage imageNamed:@"image"];
    
    //_leftViewController.tableView.backgroundColor = [UIColor clearColor];
    //_leftViewController.tintColor = [UIColor whiteColor];
    
    // -----
    
    /*
    [self setRightViewEnabledWithWidth:100.f
                     presentationStyle:LGSideMenuPresentationStyleSlideAbove
                  alwaysVisibleOptions:LGSideMenuAlwaysVisibleOnNone];
     
     
    
    self.rightViewStatusBarStyle = UIStatusBarStyleDefault;
    self.rightViewStatusBarVisibleOptions = LGSideMenuAlwaysVisibleOnPadLandscape;
    self.rightViewBackgroundColor = [UIColor colorWithWhite:1.f alpha:0.9];
    */
    //_rightViewController.tableView.backgroundColor = [UIColor clearColor];
   // _rightViewController.tintColor = [UIColor blackColor];
    
     [self.leftView addSubview:_leftViewController.view];
     //[self.leftView addSubview:_leftViewController.tableView];

  }

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super leftViewWillLayoutSubviewsWithSize:size];
    if (![UIApplication sharedApplication].isStatusBarHidden && (_type == 2 || _type == 3))
        _leftViewController.view.frame = CGRectMake(0.f , 20.f, size.width, size.height-20.f);
    else
        _leftViewController.view.frame = CGRectMake(0.f , 0.f, size.width, size.height);

}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size
{
    [super rightViewWillLayoutSubviewsWithSize:size];

}

@end
