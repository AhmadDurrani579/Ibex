//
//  EventListResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 03/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventListResponse.h"
#import "EventObject.h"

@implementation EventListResponse

+(EventListResponse*) initWithData:(NSDictionary *)dict{
    
    EventListResponse *obj = [[EventListResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSArray *tempArr = [[dict objectForKey:@"data"] objectForKey:@"data"];
    
    for(NSDictionary *masterObj in tempArr){
        [temptList addObject:[EventObject initWithData:masterObj]];
    }
    
    obj.eventList = [temptList mutableCopy];
    
    return obj;
    
}

@end
