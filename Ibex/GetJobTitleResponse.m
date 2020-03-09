//
//  GetJobTitleResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "GetJobTitleResponse.h"
#import "JobTitleObject.h"

@implementation GetJobTitleResponse

+(GetJobTitleResponse *) initWithData:(NSDictionary *)dict{
    
    GetJobTitleResponse *obj = [[GetJobTitleResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.success = [dict objectForKey:@"status"];
 
    
    NSArray *tempList = [dict objectForKey:@"data"];
    NSMutableArray *jobList = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dictObj in tempList){
        [jobList addObject:[JobTitleObject initWithData:dictObj]];
    }
    
    obj.list = jobList.mutableCopy;
    
    return obj;
}

@end
