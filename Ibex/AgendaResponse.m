//
//  AgendaResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "AgendaResponse.h"
#import "AgendaSessionModel.h"

@implementation AgendaResponse

+(AgendaResponse *) initWithData:(NSDictionary *)dict{
    
    AgendaResponse *obj = [[AgendaResponse alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    if([[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]){
        
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        NSArray *dataArray = [dict objectForKey:@"data"];
        
        for(NSDictionary *tempDict in dataArray){
            [tempList addObject:[AgendaSessionModel initWithData:tempDict]];
        }
        
        obj.agendaList = tempList.mutableCopy;
        
    }
    else{
        obj.agendaList = [NSArray new];
    }
    
    return obj;
}

@end
