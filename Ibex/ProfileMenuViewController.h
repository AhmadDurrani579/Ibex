//
//  ProfileMenuViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileMenuViewController;
@protocol ProfileMenuDelegate <NSObject>
@optional
- (void)settingsButtonPressed:(id)button;
- (void)editProfileButtonPressed:(id)button;
- (void)logoutButtonPressed:(id)button;

@end

@interface ProfileMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *btnSettings;
@property (strong, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;

@property (nonatomic, weak) id <ProfileMenuDelegate> delegate;
@end

