//
//  SignUpViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TooltipView.h"
#import "Validator.h"
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "MLPAutoCompleteTextField.h"

@interface SignUpViewController : UIViewController<ValidatorDelegate,UITextFieldDelegate, MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>{
    TooltipView *tooltipView;
}

@property (strong, nonatomic) IBOutlet UITextField *tfFirstName;
@property (strong, nonatomic) IBOutlet UITextField *tfLastName;
@property (strong, nonatomic) IBOutlet MLPAutoCompleteTextField *tfJobTitle;
@property (strong, nonatomic) IBOutlet UITextField *tfEmailAddress;
@property (strong, nonatomic) IBOutlet UITextField *tfCompany;
@property (strong, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property (strong, nonatomic) IBOutlet UITextField *tfConfirmPassword;

@property BOOL isJoinRequest;

@end
