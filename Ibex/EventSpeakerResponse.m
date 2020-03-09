//
//  EventSpeakerResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSpeakerResponse.h"
#import "EventSpeakerModel.h"

@implementation EventSpeakerResponse

+(EventSpeakerResponse *) initWithData:(NSDictionary *)dict{
    
    EventSpeakerResponse *obj = [[EventSpeakerResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    if([[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]){
        
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        NSArray *dataArray = [dict objectForKey:@"data"];
        
        for(NSDictionary *tempDict in dataArray){
            [tempList addObject:[EventSpeakerModel initWithData:tempDict]];
        }
        
        obj.speakerList = tempList.mutableCopy;
        
    }
    else{
        obj.speakerList = [NSArray new];
    }
    
    
    return obj;
}

@end
