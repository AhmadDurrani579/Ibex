//
//  SideMenuViewController.h
//  COI
//
//  Created by Sajid Saeed on 03/10/2016.
//  Copyright © 2016 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginResponse.h"
//#import "NSUserDefaults+DemoSettings.h"

@interface SideMenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *uvProfileDisplay;
@property (strong, nonatomic) IBOutlet UITableView *sideMenuTableView;
@property (strong, nonatomic) NSMutableArray *itemList;
@property (strong, nonatomic) IBOutlet UIImageView *ivProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileName;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileDesignation;
@property (strong, nonatomic) IBOutlet UILabel *msgBadge;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property (strong, nonatomic) UIViewController *homeVCRef;
//@property (strong, nonatomic) LoginResponse *userData;
@end
