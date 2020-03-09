//
//  FAQDetailViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 13/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "FAQDetailViewController.h"
#import "Utility.h"
#import "AppDelegate.h"

@interface FAQDetailViewController ()

@end

@implementation FAQDetailViewController
@synthesize lblDate,lblTime,lblTitle,tvDesc,qObj,lblEventTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self restoreData];
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void) restoreData{
    
//    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate ;
//    EventObject *obj = (EventObject*) appDelegate.eventObj;
    
    [lblEventTitle setText:qObj.qEventName];
    [lblTitle setText:qObj.qQuestion];
    [tvDesc setText:qObj.qAnswer];
    
    if(![Utility isEmptyOrNull:qObj.qModifiedDate]){
        [lblTime setText:[self timeFromStringFormatter:qObj.qModifiedDate]];
    }
    else{
        if(![Utility isEmptyOrNull:qObj.qCreateDate]){
            [lblTime setText:[self timeFromStringFormatter:qObj.qCreateDate]];
        }
        else{
            [lblTime setText:@"--:--"];
        }
    }
    
    if(![Utility isEmptyOrNull:qObj.qModifiedDate]){
        [lblDate setText:[self dateFromStringFormatter:qObj.qModifiedDate]];
    }
    else{
        if(![Utility isEmptyOrNull:qObj.qCreateDate]){
            [lblDate setText:[self dateFromStringFormatter:qObj.qCreateDate]];
        }
        else{
            [lblDate setText:@"--/--"];
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Faq Detail Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

-(NSString*) timeFromStringFormatter:(NSString*)timeString{
    if([Utility isEmptyOrNull:timeString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    NSDate *yourDate = [dateFormatter dateFromString:timeString];
    dateFormatter.dateFormat = @"hh:mm a";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}

-(NSString*) dateFromStringFormatter:(NSString*)timeString{
    if([Utility isEmptyOrNull:timeString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    NSDate *yourDate = [dateFormatter dateFromString:timeString];
    dateFormatter.dateFormat = @"MMM dd";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
