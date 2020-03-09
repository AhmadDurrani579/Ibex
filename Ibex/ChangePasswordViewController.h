//
//  ChangePasswordViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TooltipView.h"
#import "Validator.h"

@interface ChangePasswordViewController : UIViewController<ValidatorDelegate,UITextFieldDelegate>{
    TooltipView *tooltipView;
}


@property (strong, nonatomic) IBOutlet UITextField *lblOldPass;
@property (strong, nonatomic) IBOutlet UITextField *lblNewPass;
@property (strong, nonatomic) IBOutlet UITextField *lblConfirmPass;
@property(nonatomic  , assign) NSInteger comeForSideMenuOrTab ;

@end
