//
//  AgendaSessionModel.m
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "AgendaSessionModel.h"
#import "EventSpeakerModel.h"

@implementation AgendaSessionModel

+(AgendaSessionModel *) initWithData:(NSDictionary *)dict{
    
    AgendaSessionModel *obj = [[AgendaSessionModel alloc] init];
    
    obj.agendaTitle = [dict objectForKey:@"title"];
    obj.agendaDesc = [dict objectForKey:@"description"];
    obj.agendaLoc = [dict objectForKey:@"location"];
    obj.agendaEventID = [dict objectForKey:@"eventId"];
    obj.agendaDate = [dict objectForKey:@"date"];
    obj.agendaTimeFrom = [dict objectForKey:@"timeFrom"];
    obj.agendaTimeTo = [dict objectForKey:@"timeTo"];
    obj.agendaID = [dict objectForKey:@"id"];
    
    if([dict objectForKey:@"eventTrack"]){
        obj.agendaEventTrack = [[dict objectForKey:@"eventTrack"] objectForKey:@"name"];
    }
    
    if([[dict objectForKey:@"eventSessionSpeakers"] isKindOfClass:[NSArray class]]){
        
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        NSArray *dataArray = [dict objectForKey:@"eventSessionSpeakers"];
        
        for(NSDictionary *tempDict in dataArray){
            [tempList addObject:[EventSpeakerModel initWithData:tempDict]];
        }
        
        obj.agendaEventSpeakerList = tempList.mutableCopy;
        
    }
    else{
        obj.agendaEventSpeakerList = [NSArray new];
    }
    
    return obj;
    
}

@end
