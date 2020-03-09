//
//  MONotificationResponse.m
//  YPO
//
//  Created by Ahmed Durrani on 08/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MONotificationResponse.h"
#import "MONotificationObject.h"
@implementation MONotificationResponse

+(MONotificationResponse*) initWithData:(NSDictionary *)dict{
    
    MONotificationResponse *obj = [[MONotificationResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSArray *tempArr = [[dict objectForKey:@"data"] objectForKey:@"data"];
    
    for(NSDictionary *masterObj in tempArr){
        [temptList addObject:[MONotificationObject initWithData:masterObj]];
    }
    
    obj.notificationList = [temptList mutableCopy];
    
    return obj;
    
}
@end
