//
//  JoinRequestResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "JoinRequestResponse.h"

@implementation JoinRequestResponse

+(JoinRequestResponse *) initWithData:(NSDictionary *)dict{

    JoinRequestResponse *obj = [[JoinRequestResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    return obj;
}


@end
