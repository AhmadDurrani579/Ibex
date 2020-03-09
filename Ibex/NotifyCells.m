//
//  NotifyCells.m
//  YPO
//
//  Created by Ahmed Durrani on 08/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "NotifyCells.h"

@implementation NotifyCells

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNotify:(MONotificationObject *)notify {
    _notify = notify ;
    NSString *mysqlDatetime = notify.sentDate ;
    
    NSString *start = [mysqlDatetime stringByReplacingOccurrencesOfString:@"T"
                                                                         withString:@"  "];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   
//    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
//    dateFormatters.dateFormat = @"yyyy/MM/dd  hh:mm:ss";
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];


//    NSDate *dateT = [dateFormatters dateFromString:start];

    NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeDiffFormattedAsTimeAgo:start];
    _messageOfUser.text = notify.body ;
    _lblTitle.text = notify.title ;
    _lblTime.text   = timeAgoFormattedDate ;
    
}


@end
