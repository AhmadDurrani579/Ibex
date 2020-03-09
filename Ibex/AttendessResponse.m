//
//  AttendessResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "AttendessResponse.h"
#import "EventSpeakerModel.h"

@implementation AttendessResponse

+(AttendessResponse *) initWithData:(NSDictionary *)dict{
    
    AttendessResponse *obj = [[AttendessResponse alloc] init];
    
    obj.status = [dict objectForKey:@"status"];
    obj.message = [dict objectForKey:@"message"];
    
    if([[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]){
        
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        NSArray *dataArray = [dict objectForKey:@"data"];
        
        for(NSDictionary *tempDict in dataArray){
            [tempList addObject:[EventSpeakerModel initWithDataAttendee:tempDict]];
        }
        
        obj.attendeesList = tempList.mutableCopy;
        
    }
    else{
        obj.attendeesList = [NSArray new];
    }
    
    return obj;
}

@end
