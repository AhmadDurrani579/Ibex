//
//  SignupResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SignupResponse.h"

@implementation SignupResponse

+(SignupResponse*) initWithData:(NSDictionary*)dict{
    
    SignupResponse *obj = [[SignupResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    return obj;
}

@end
