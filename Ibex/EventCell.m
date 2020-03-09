//
//  EventCell.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventCell.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"

@interface EventCell()
{
    __weak IBOutlet UILabel *nameOfEvent;
    __weak IBOutlet UILabel *descriptionOfEvent;
    __weak IBOutlet UILabel *dateAndDay;
    __weak IBOutlet UIImageView *imageOfEvent;
    __weak IBOutlet UILabel *lblOfTimeOfEvent;
    __weak IBOutlet UIView *viewOfDifferentUser;
    
    __weak IBOutlet UILabel *lblAddress;
    __weak IBOutlet UILabel *dayNAme;
}

@end


@implementation EventCell


- (void)awakeFromNib {
    [super awakeFromNib];

    [self setShadow:self.viewOfShadow];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShadow:(UIView *)view
{
    view.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
    [view.layer setCornerRadius:5.0f];
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.5f];
    [view.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [view.layer setShadowOpacity:1.0];
    [view.layer setShadowRadius:5.0];
    [view.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
    
}


-(void) setSchedule:(YPOScheduleObject *)schedule
{
    _schedule = schedule ;
    
    [nameOfEvent setText: schedule.name];
    [descriptionOfEvent setText: schedule.descriptionOfEvent];
    [lblOfTimeOfEvent setText: schedule.endTime];
//    [lblAddress setText:schedule.venueAddress] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [schedule.startDate stringByReplacingOccurrencesOfString:@"T"
                                         withString:@"  "];
    
    NSDate *date = [dateFormatter dateFromString:str];
    [dateFormatter setDateFormat:@"dd"];
    NSString *curentDayDate = [dateFormatter stringFromDate:date];

    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName = [dateFormatter stringFromDate:date];
    dayName=[dayName substringToIndex:3];
    
    
//    NSMutableAttributedString *stringText = [[NSMutableAttributedString alloc] initWithString:@"This is a text"];
//    //Bold the first four characters.
//    [stringText addAttribute: NSFontAttributeName value: [NSFont fontWithName: @"Helvetica-Bold"] range: NSMakeRange(0, 4)];
//    // Sets the font color of last four characters to green.
//    [stringText addAttribute: NSForegroundColorAttributeName value: [UIColor greenColor] range: NSMakeRange(9, 4)];
    [dateAndDay setText:curentDayDate];
    [dayNAme setText:dayName];
    NSString *imageURLString = [Utility getProductUrlForProductImagePath:schedule.logoPathThumb];

    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [imageOfEvent setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
    [Utility setViewCornerRadius:imageOfEvent radius:imageOfEvent.frame.size.width/2];
    BOOL boolValue = [schedule.isFeatured boolValue];
    if (boolValue)
    {
        viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:242/255.0 green: 184/255.0 blue:67/255.0 alpha:1.0];
    }
    else
    {
        viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:72/255.0 green:141/255.0 blue:251/255.0 alpha:1.0];
    }
    
}

@end
