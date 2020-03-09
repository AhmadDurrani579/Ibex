//
//  IsJoinedResponsed.m
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "IsJoinedResponsed.h"

@implementation IsJoinedResponsed

+(IsJoinedResponsed *) initWithData:(NSDictionary *)dict{
    
    IsJoinedResponsed *obj = [[IsJoinedResponsed alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    if([[dict objectForKey:@"data"] isEqual:[NSNull null]]){
        obj.data = @"no";
    }
    else if([[dict objectForKey:@"data"] objectForKey:@"isApproved"]){
        obj.data = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"data"] objectForKey:@"isApproved"]];
    }
    else{
        obj.data =[dict objectForKey:@"data"];
    }
    
    return obj;
}

@end
