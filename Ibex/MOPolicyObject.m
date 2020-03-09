//
//  MOPolicyObject.m
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MOPolicyObject.h"

@implementation MOPolicyObject

+(MOPolicyObject*)initWithData:(NSDictionary *)dict{
    MOPolicyObject *obj = [[MOPolicyObject alloc] init];

    obj.descriptionOfPolicy = [dict objectForKey:@"description"];

    return obj;

}
    

@end
