//
//  EventsCell.m
//  Ibex
//
//  Created by Ahmed Durrani on 02/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventsCell.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "EventSupportModel.h"
#import "EventObject.h"
@interface EventsCell()
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
@implementation EventsCell


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


-(void) setSchedule:(EventObject *)schedule
{
    _schedule = schedule ;
//    _schedule.supportingContentList.lastObject
    
    NSDictionary *dict = _schedule.supportingContentList.lastObject ;
    
    
//    EventSupportModel *obj = (EventSupportModel *)[array];
    
    
    
    [nameOfEvent setText: schedule.eventName];
    [descriptionOfEvent setText: schedule.eventDescription];
    [lblOfTimeOfEvent setText: schedule.eventStartTime];
    //    [lblAddress setText:schedule.venueAddress] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [schedule.eventStartDate stringByReplacingOccurrencesOfString:@"T"
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
    NSString *imageURLString = [Utility getProductUrlForProductImagePath:schedule.eventThumbImg];
    
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [imageOfEvent setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
    [Utility setViewCornerRadius:imageOfEvent radius:imageOfEvent.frame.size.width/2];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
    
    NSString *boolValue = [dict valueForKey:@"eventRegistrationType"];
  
    
    if ([boolValue isEqualToString:@"Gold"]){
        
        NSDate * now = [NSDate date];
        NSDate * mile = date;
        NSComparisonResult result = [now compare:mile];
        
        NSLog(@"%@", now);
        NSLog(@"%@", mile);
        switch (result)
        {
            case NSOrderedAscending:
                
                if ([mile compare:newDate] == NSOrderedAscending) {
                    
                    viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];
                    
                    //                    viewOfColour
                } else {
                    viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:243/255.0 green: 185/255.0 blue:51/255.0 alpha:1.0];
                }
                
                break;
            case NSOrderedDescending:
                
                viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:251/255.0 green: 221/255.0 blue:161/255.0 alpha:1.0];
                
                break;
            case NSOrderedSame:
                viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:248/255.0 green: 206/255.0 blue:120/255.0 alpha:1.0];
                break;
            default:
                NSLog(@"erorr dates %@, %@", mile, now);
                break;
        }
    }else {
        NSDate * now = [NSDate date];
        NSDate * mile = date;
        NSComparisonResult result = [now compare:mile];
        
        NSLog(@"%@", now);
        NSLog(@"%@", mile);
        switch (result)
        {
            case NSOrderedAscending:
                
                if ([mile compare:newDate] == NSOrderedAscending) {
                    
                    viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:68/255.0 green: 138/255.0 blue:255/255.0 alpha:1.0];
                    
                    //                    viewOfColour
                } else {
                    viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:0/255.0 green: 38/255.0 blue:61/255.0 alpha:1.0];
                }
                
                break;
            case NSOrderedDescending:
                
                viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:183/255.0 green: 183/255.0 blue:183/255.0 alpha:1.0];
                
                break;
            case NSOrderedSame:
                viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:68/255.0 green: 138/255.0 blue:255/255.0 alpha:1.0];
                break;
            default:
                NSLog(@"erorr dates %@, %@", mile, now);
                break;
                
        }
    }

//    if (boolValue)
//    {
//        
//        NSDate * now = [NSDate date];
//        NSDate * mile = date;
//        NSComparisonResult result = [now compare:mile];
//        
//        NSLog(@"%@", now);
//        NSLog(@"%@", mile);
//      
//        
//
//        
//        switch (result)
//        {
//            case NSOrderedAscending:
//                
//
//                NSLog(@"%@ is in future from %@", mile, now);
//                break;
//            case NSOrderedDescending:
//
//                viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:251/255.0 green: 221/255.0 blue:161/255.0 alpha:1.0];
//
//                NSLog(@"%@ is in past from %@", mile, now);
//                break;
//            case NSOrderedSame:
//                NSLog(@"%@ is the same as %@", mile, now);
//                break;
//            default:
//                NSLog(@"erorr dates %@, %@", mile, now);
//                break;
//        }
//
//        
//    }
//    else
//    {
//        viewOfDifferentUser.backgroundColor = [UIColor colorWithRed:72/255.0 green:141/255.0 blue:251/255.0 alpha:1.0];
//    }
    
}


@end
