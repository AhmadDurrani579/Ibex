//
//  MOGetAllSupporting.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MOGetAllSupporting.h"
#import "MOGetAllSupportingObject.h"
@implementation MOGetAllSupporting

+(MOGetAllSupporting*) initWithData:(NSDictionary *)dict {
    
    MOGetAllSupporting *obj = [[MOGetAllSupporting alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSArray *tempArr = [[dict objectForKey:@"data"] objectForKey:@"data"];
    
    for(NSDictionary *masterObj in tempArr){
        [temptList addObject:[MOGetAllSupportingObject initWithData:masterObj]];
    }
    obj.eventList = [temptList mutableCopy];
    
    return obj;
    
}

@end
