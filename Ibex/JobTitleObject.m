//
//  JobTitleObject.m
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "JobTitleObject.h"

@implementation JobTitleObject

+(JobTitleObject *) initWithData:(NSDictionary *) dict{
    
    JobTitleObject *obj = [[JobTitleObject alloc] init];
    
    obj.jobID = [dict objectForKey:@"id"];
    obj.jobTitle = [dict objectForKey:@"name"];
    obj.jobisActive = [dict objectForKey:@"isActive"];
    
    return obj;
}

@end
