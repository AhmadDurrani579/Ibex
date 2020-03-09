//
//  EventObject.m
//  Ibex
//
//  Created by Sajid Saeed on 03/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventObject.h"
#import "EventSupportModel.h"
#import "EventSpeakerModel.h"
@implementation EventObject

+(EventObject*)initWithData:(NSDictionary *)dict{
    
    EventObject *obj = [[EventObject alloc] init];
    
    obj.eventName         = [dict objectForKey:@"name"];
    obj.eventDescription  = [dict objectForKey:@"description"];
    obj.eventVenueName    = [dict objectForKey:@"venueName"];
    obj.eventVenueAddress = [dict objectForKey:@"venueAddress"];
    obj.eventVenueLat     = [dict objectForKey:@"venueLat"];
    obj.eventVenueLong    = [dict objectForKey:@"venueLng"];
    obj.eventStartDate    = [dict objectForKey:@"startDate"];
    obj.eventEndDate      = [dict objectForKey:@"endDate"];
    
    obj.eventStartTime    = [dict objectForKey:@"startTime"];
    obj.eventEndTime      = [dict objectForKey:@"endTime"];
    obj.eventEventID      = [dict objectForKey:@"id"];
    obj.eventThumbImg     = [dict objectForKey:@"logoPathThumb"];
    obj.eventBigImg       = [dict objectForKey:@"logoPathMain"];
    obj.isFeatured        = [dict objectForKey:@"isFeatured"];
//    obj.organizerList     = [dict objectForKey:@"orgnaizers"] ;
    
    
    if([[dict objectForKey:@"topic"] isKindOfClass:[NSDictionary class]]){
        obj.eventTopic = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"topic"] objectForKey:@"name"]];
    }
    
    if([[dict objectForKey:@"eventType"] isKindOfClass:[NSDictionary class]]){
        obj.isEventGoldOrYPO =  [[dict objectForKey:@"eventType"]objectForKey:@"name"];
    }
    if([[dict objectForKey:@"orgnaizer"] isKindOfClass:[NSDictionary class]]){
        obj.organizer = [dict objectForKey:@"orgnaizer"];
        
    }
    if([[dict objectForKey:@"admin"] isKindOfClass:[NSDictionary class]]){
        obj.admin = [dict objectForKey:@"admin"];
    }

    
    
    if([[dict objectForKey:@"registrationType"] isKindOfClass:[NSDictionary class]]){
        obj.eventRegistrationType = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"registrationType"] objectForKey:@"name"]];
    }
    
    if([[dict objectForKey:@"eventSupportingContents"] isKindOfClass:[NSArray class]]){
        NSArray *tempList = [dict objectForKey:@"eventSupportingContents"];
        NSMutableArray *newList = [[NSMutableArray alloc] init];
       
        for(NSDictionary *objDict in tempList){
            [newList addObject:[EventSupportModel initWithData:objDict]];
        }
        
        obj.supportingContentList = [newList mutableCopy];
        
    }
    else{
        obj.supportingContentList = [NSArray new];
    }
    
    if([[dict objectForKey:@"organizers"] isKindOfClass:[NSArray class]]){
        NSArray *tempList = [dict objectForKey:@"organizers"];
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        
        for(NSDictionary *objDict in tempList){
            [newList addObject:[EventSpeakerModel initWithData:objDict]];
        }
        
        obj.organizerArray = [newList mutableCopy];
        
    }
    else{
        obj.organizerArray = [NSArray new];
    }
    
    
    return obj;
    
}

@end
