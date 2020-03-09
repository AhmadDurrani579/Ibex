//
//  FAQDetailViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 13/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionObject.h"
#import "ExtendedViewController.h"

@interface FAQDetailViewController : ExtendedViewController
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UITextView *tvDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblEventTitle;

@property (strong, nonatomic) QuestionObject *qObj;

@end
