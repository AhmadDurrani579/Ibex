//
//  HomeViewViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 22/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewViewController : UIViewController

@property(nonatomic,strong) NSString *headingText;
@property(nonatomic,strong) UIButton *listButton;
@property(nonatomic,strong) UIButton *notifButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contraint_bottom_spacer;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UIImageView *ivHomeBackground;

@end
