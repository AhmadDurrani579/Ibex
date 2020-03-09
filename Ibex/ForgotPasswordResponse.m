//
//  ForgotPasswordResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "ForgotPasswordResponse.h"

@implementation ForgotPasswordResponse

+(ForgotPasswordResponse *) initWithData:(NSDictionary*)dict{
    
    ForgotPasswordResponse *obj = [[ForgotPasswordResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    //obj.data = [dict objectForKey:@""];
    
    return obj;
}

@end
