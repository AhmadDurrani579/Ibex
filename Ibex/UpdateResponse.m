//
//  UpdateResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 16/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "UpdateResponse.h"

@implementation UpdateResponse

+(UpdateResponse *) initWithData:(NSDictionary *)dict{
    
    UpdateResponse *obj = [[UpdateResponse alloc] init];
    
    obj.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
    obj.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
    
    return obj;
    
}

@end
