//
//  EventSessionModel.m
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSessionModel.h"

@implementation EventSessionModel

+(EventSessionModel *) initWithData:(NSDictionary *)dict{
    
    EventSessionModel *obj = [[EventSessionModel alloc] init];
    
    obj.eventTitle = [dict objectForKey:@"title"];
    obj.eventDesc = [dict objectForKey:@"description"];
    obj.eventLocation = [dict objectForKey:@"location"];
    obj.eventEventID = [dict objectForKey:@"eventId"];
    obj.eventDate = [dict objectForKey:@"date"];
    obj.eventTimeFrom = [dict objectForKey:@"timeFrom"];
    obj.eventTimeTo = [dict objectForKey:@"timeTo"];

    if([dict objectForKey:@"eventTrack"]){
        obj.eventTrackName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"eventTrack"] objectForKey:@"name"]];
    }
    
    return obj;
}

@end
