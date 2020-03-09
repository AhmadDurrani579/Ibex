//
//  EventCountResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 19/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventCountResponse.h"

@implementation EventCountResponse

+(EventCountResponse *) initWithData:(NSDictionary *)dict{
    
    EventCountResponse *obj = [[EventCountResponse alloc] init];
    
    obj.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
    obj.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
    
    if([dict objectForKey:@"data"]){
        obj.sessionCount    = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"data"] objectForKey:@"sessionCount"]];
        obj.trackCount = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"data"] objectForKey:@"trackCount"]];
        obj.speakerCount = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"data"] objectForKey:@"speakerCount"]];
    }

    
    return obj;
}

@end
