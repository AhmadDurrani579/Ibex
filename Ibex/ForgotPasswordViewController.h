//
//  ForgotPasswordViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TooltipView.h"
#import "Validator.h"

@interface ForgotPasswordViewController : UIViewController<ValidatorDelegate>{
    TooltipView *tooltipView;
}
@property (strong, nonatomic) IBOutlet UITextField *tfEmailAddress;


@end
