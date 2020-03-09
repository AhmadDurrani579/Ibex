//
//  EventSupportModel.m
//  Ibex
//
//  Created by Sajid Saeed on 19/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSupportModel.h"

@implementation EventSupportModel

+(EventSupportModel *) initWithData:(NSDictionary *)dict{

    EventSupportModel *obj = [[EventSupportModel alloc] init];
    
    obj.esEventID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"eventId"]];
    obj.esFileName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"fileName"]];
    obj.esFilePath = [NSString stringWithFormat:@"%@", [dict objectForKey:@"filePath"]];
    obj.esFileType = [NSString stringWithFormat:@"%@", [dict objectForKey:@"fileType"]];
    obj.esID        = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
    obj.esIsActive = [NSString stringWithFormat:@"%@", [dict objectForKey:@"isActive"]];
    
    if([[dict objectForKey:@"event"] isKindOfClass:[NSDictionary class]]){
        obj.eventRegistrationType = [NSString stringWithFormat:@"%@", [[[dict objectForKey:@"event"] objectForKey:@"eventType"] objectForKey:@"name"]];
    }
    return obj;

}


@end
