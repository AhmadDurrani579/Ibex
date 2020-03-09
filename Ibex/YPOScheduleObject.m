//
//  YPOScheduleObject.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOScheduleObject.h"
#import "EventSupportModel.h"
@implementation YPOScheduleObject

+(YPOScheduleObject*)initWithData:(NSDictionary *)dict{
    YPOScheduleObject *obj = [[YPOScheduleObject alloc] init];
    
    obj.name = [dict objectForKey:@"name"];
    obj.venueAddress = [dict objectForKey:@"venueAddress"];

    obj.descriptionOfEvent = [dict objectForKey:@"description"];
    obj.contactEmail = [dict objectForKey:@"contactEmail"];
    obj.createdDate = [dict objectForKey:@"createdDate"];
    obj.endDate = [dict objectForKey:@"endDate"];
    obj.endTime = [dict objectForKey:@"endTime"];
    obj.idOfEvent = [dict objectForKey:@"id"];
    
    obj.isActive = [dict objectForKey:@"isActive"];
    obj.venueLat = [dict objectForKey:@"venueLat"];
    obj.venueLng = [dict objectForKey:@"venueLng"];

    
    
    obj.isFeatured = [dict objectForKey:@"isFeatured"];
    obj.isPublished = [dict objectForKey:@"isPublished"];
    obj.logoPathMain = [dict objectForKey:@"logoPathMain"];
    obj.logoPathThumb = [dict objectForKey:@"logoPathThumb"];
    
    
    obj.orgnaizerId = [dict objectForKey:@"orgnaizerId"];
    obj.registrationGoal = [dict objectForKey:@"registrationGoal"];
    obj.startDate = [dict objectForKey:@"startDate"];
    obj.startTime = [dict objectForKey:@"startTime"];

    
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

//    if([[dict objectForKey:@"eventSupportingContents"] isKindOfClass:[NSDictionary class]]){
//        obj.eventType = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"eventSupportingContents"] objectForKey:@"eventType"]];
//    }

    if([[dict objectForKey:@"topic"] isKindOfClass:[NSDictionary class]]){
        obj.eventTopic = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"topic"] objectForKey:@"name"]];
    }

    
    
      return obj;
    
}


@end
