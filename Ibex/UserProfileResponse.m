//
//  UserProfileResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 10/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "UserProfileResponse.h"

@implementation UserProfileResponse

+(UserProfileResponse *) initWithData:(NSDictionary *)dict{
    
    UserProfileResponse *obj = [[UserProfileResponse alloc] init];
    
    obj.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
    obj.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
    
    obj.user = [EventSpeakerModel initWithData:[dict objectForKey:@"data"]];
    
    return obj;
    
}

@end
