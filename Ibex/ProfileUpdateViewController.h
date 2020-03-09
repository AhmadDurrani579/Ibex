//
//  ProfileUpdateViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 10/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZPickerView.h"
#import "TooltipView.h"
#import "Validator.h"
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "MLPAutoCompleteTextField.h"

@interface ProfileUpdateViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,CZPickerViewDelegate,CZPickerViewDataSource,ValidatorDelegate,UITextFieldDelegate,MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>{
    TooltipView    *_tooltipView;
}

@property (strong, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UITextField *tfCompany;
@property (strong, nonatomic) IBOutlet MLPAutoCompleteTextField *tfIndustry;
@property (strong, nonatomic) IBOutlet MLPAutoCompleteTextField *tfJobTitle;
@property (strong, nonatomic) IBOutlet MLPAutoCompleteTextField *tfJobFunction;
@property (strong, nonatomic) IBOutlet UIImageView *ivProfile;
@property (strong, nonatomic) IBOutlet UITextField *tfFBURL;
@property (strong, nonatomic) IBOutlet UITextField *tfTwitterURL;
@property (strong, nonatomic) IBOutlet UITextField *tfLinkedinURL;
@property (strong, nonatomic) IBOutlet UITextField *tfAngelListURL;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UILabel *fbLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitter;
@property (strong, nonatomic) IBOutlet UILabel *lnkedIn;
@property (strong, nonatomic) IBOutlet UILabel *websiteLbl;



@end
