//
//  MONotificationObject.m
//  YPO
//
//  Created by Ahmed Durrani on 08/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MONotificationObject.h"

@implementation MONotificationObject

+(MONotificationObject*)initWithData:(NSDictionary *)dict{
    MONotificationObject *obj = [[MONotificationObject alloc] init];
    
    obj.text = [dict objectForKey:@"text"];
    obj.title = [dict objectForKey:@"title"];
    
    obj.sentDate = [dict objectForKey:@"sentDate"];
    obj.body = [dict objectForKey:@"body"];
    if([[dict objectForKey:@"reciever"] isKindOfClass:[NSDictionary class]]){
        obj.name = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"reciever"] objectForKey:@"firstName"]];
    }
    if([[dict objectForKey:@"reciever"] isKindOfClass:[NSDictionary class]]){
        obj.lastName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"reciever"] objectForKey:@"lastName"]];
    }
    if([[dict objectForKey:@"reciever"] isKindOfClass:[NSDictionary class]]){
        obj.company = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"reciever"] objectForKey:@"company"]];
    }
    return obj;
    
}
@end
