//
//  SponsorsResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SponsorsResponse.h"
#import "SponsorModel.h"

@implementation SponsorsResponse

+(SponsorsResponse *) initWithData:(NSDictionary *)dict{
    
    SponsorsResponse *obj = [[SponsorsResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    
    if([[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]){
    
        NSArray *tempSponsors = [dict objectForKey:@"data"];
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        
        for(NSDictionary *dictObj in tempSponsors){
            [tempList addObject:[SponsorModel initWithData:dictObj]];
        }
        
        obj.sponsorList = [tempList mutableCopy];
    }
    else{
        obj.sponsorList = [[NSArray alloc] init];
    }
    
    return obj;
}

@end
