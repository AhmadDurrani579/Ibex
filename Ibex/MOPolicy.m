//
//  MOPolicy.m
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MOPolicy.h"
#import "MOPolicyObject.h"
@implementation MOPolicy

+(MOPolicy*) initWithData:(NSDictionary *)dict {
    
    MOPolicy *obj = [[MOPolicy alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSArray *tempArr = [dict objectForKey:@"data"];
    
    obj.eventList = [tempArr mutableCopy];
    
//    for(NSDictionary *masterObj in tempArr){
//        [temptList addObject:[MOPolicyObject initWithData:masterObj]];
//    }
//    obj.eventList = [temptList mutableCopy];
    
    return obj;
    
}



@end
