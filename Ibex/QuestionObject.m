//
//  QuestionObject.m
//  Ibex
//
//  Created by Sajid Saeed on 13/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "QuestionObject.h"
#import "EventObject.h"
@implementation QuestionObject

+(QuestionObject *) initWithData:(NSDictionary *)dict{
    
    QuestionObject *obj = [[QuestionObject alloc] init];
    
    obj.qQuestion = [NSString stringWithFormat:@"%@", [dict objectForKey:@"question"]];
    obj.qAnswer = [NSString stringWithFormat:@"%@", [dict objectForKey:@"answer"]];
    obj.qEventID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"eventId"]];
    obj.qID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
    obj.qIsActive = [NSString stringWithFormat:@"%@", [dict objectForKey:@"isActive"]];
    obj.qCreateDate = [NSString stringWithFormat:@"%@", [dict objectForKey:@"createdDate"]];
    obj.qModifiedDate = [NSString stringWithFormat:@"%@", [dict objectForKey:@"modifiedDate"]];
    
    if([[dict objectForKey:@"event"] isKindOfClass:[NSDictionary class]]){
        obj.qEventName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"event"] objectForKey:@"name"]];
    }

    
    return obj;
}

@end
