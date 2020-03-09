//
//  UserProfileViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 10/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGoldMemberObject.h"
@interface UserProfileViewController : UIViewController
@property (strong , nonatomic) NSString *selectedVc ;
@property (strong, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfCompany;
@property (strong, nonatomic) IBOutlet UITextField *tfIndustry;
@property (strong, nonatomic) IBOutlet UITextField *tfJobTitle;
@property (strong, nonatomic) IBOutlet UITextField *tfFunction;
@property (strong, nonatomic) IBOutlet UIImageView *ivPRofilePic;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong , nonatomic) NSString  *loginUserId ;
@property (strong, nonatomic) MOGoldMemberObject *selectMember;



@end
