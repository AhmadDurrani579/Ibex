//
//  ChangePasswordResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "ChangePasswordResponse.h"

@implementation ChangePasswordResponse

+(ChangePasswordResponse *) initWithData:(NSDictionary *)dict{
    
    ChangePasswordResponse *obj = [[ChangePasswordResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];

    return obj;
}


@end
