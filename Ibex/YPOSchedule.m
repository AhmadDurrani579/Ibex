//
//  YPOSchedule.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSchedule.h"
#import "YPOScheduleObject.h"
#import "EventObject.h"

@implementation YPOSchedule


+(YPOSchedule*) initWithData:(NSDictionary *)dict{
    
    YPOSchedule *obj = [[YPOSchedule alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSArray *tempArr = [[dict objectForKey:@"data"] objectForKey:@"data"];
    
    for(NSDictionary *masterObj in tempArr){
        [temptList addObject:[EventObject initWithData:masterObj]];

//        [temptList addObject:[YPOScheduleObject initWithData:masterObj]];
    }
    obj.eventList = [temptList mutableCopy];
    
    return obj;
    
}


@end
