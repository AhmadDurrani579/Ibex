//
//  SponsorModel.m
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SponsorModel.h"

@implementation SponsorModel

+(SponsorModel *) initWithData:(NSDictionary *) dict{

    
    SponsorModel *obj = [[SponsorModel alloc] init];
    
    obj.sponsorName = [dict objectForKey:@"name"];
    obj.sponsorDesc = [dict objectForKey:@"description"];
    obj.sponsorURL = [dict objectForKey:@"companyURL"];
    obj.sponsorID = [dict objectForKey:@"id"];
    obj.sponsorThumb = [dict objectForKey:@"logoPathThumb"];
    obj.sponsorImg = [dict objectForKey:@"logoPathMain"];
    obj.sponsorIsActive = [dict objectForKey:@"isActive"];
    obj.sponsorTypeID = [dict objectForKey:@"sponserTypeId"];
    
    return obj;
}


@end
