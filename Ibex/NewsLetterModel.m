//
//  NewsLetterModel.m
//  YPO
//
//  Created by Ahmed Durrani on 03/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "NewsLetterModel.h"
#import "NewsLetterModelObject.h"
@implementation NewsLetterModel

+(NewsLetterModel*) initWithData:(NSDictionary *)dict{
    
    NewsLetterModel *obj = [[NewsLetterModel alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSArray *tempArr = [[dict objectForKey:@"data"] objectForKey:@"data"];
    
    for(NSDictionary *masterObj in tempArr){
        [temptList addObject:[NewsLetterModelObject initWithData:masterObj]];
        
    }
    
    obj.arrayOfNewsLetter = [temptList mutableCopy];
    
    return obj;
    
}

@end
