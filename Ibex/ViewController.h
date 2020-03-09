//
//  ViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 22/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TooltipView.h"
#import "Validator.h"

@interface ViewController : UIViewController<ValidatorDelegate>{
    TooltipView *tooltipView;
}

@property (strong, nonatomic) IBOutlet UITextField *tfUserName;
@property (strong, nonatomic) IBOutlet UITextField *tfPassword;
@property BOOL isJoin;

@end

