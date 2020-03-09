//
//  YPOSearchEventList.m
//  YPO
//
//  Created by Ahmed Durrani on 25/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSearchEventList.h"
#import "EventObject.h"
#import "MOGoldMemberObject.h"
@implementation YPOSearchEventList

+(YPOSearchEventList*) initWithData:(NSDictionary *)dict{
    
    YPOSearchEventList *obj = [[YPOSearchEventList alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSMutableArray *userList = [[NSMutableArray alloc] init];

    NSArray *tempArr = [[dict objectForKey:@"data"] objectForKey:@"events"];
    NSArray *tempArrayForUser = [[dict objectForKey:@"data"] objectForKey:@"users"];
    
    for(NSDictionary *masterObj in tempArr){
        [temptList addObject:[EventObject initWithData:masterObj]];
    }
    for(NSDictionary *masterObj in tempArrayForUser){
        [userList addObject:[MOGoldMemberObject initWithData:masterObj]];
    }
    
    obj.eventList = [temptList mutableCopy];
    obj.searchUserList = [userList mutableCopy];
    
    return obj;
    
}

@end
