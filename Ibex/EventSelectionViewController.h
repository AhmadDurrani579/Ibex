//
//  EventSelectionViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 30/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "ProfileMenuViewController.h"

@interface EventSelectionViewController : UIViewController<ProfileMenuDelegate, UIApplicationDelegate>{
    WYPopoverController *popover;
}
@property(nonatomic,strong) UIButton *profileButton;
@property(nonatomic,strong) UIButton *backButton;


@end
