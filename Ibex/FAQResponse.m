//
//  FAQResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 13/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "FAQResponse.h"
#import "QuestionObject.h"

@implementation FAQResponse

+(FAQResponse*) initWithData:(NSDictionary *)dict{
    
    FAQResponse *obj = [[FAQResponse alloc] init];
    
    obj.status = [NSString stringWithFormat:@"%@", [dict objectForKey:@"status"]];
    obj.message = [NSString stringWithFormat:@"%@", [dict objectForKey:@"message"]];
    
    if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *tempList = [dict objectForKey:@"data"];
        NSDictionary *arrayOfData = [tempList objectForKey:@"data"];

        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        
        for(NSDictionary *dictObj in arrayOfData){
            [tempArr addObject:[QuestionObject initWithData:dictObj]];
        }
        
        obj.questionList = tempArr.mutableCopy;
    }
    else{
        obj.questionList = [NSArray new];
    }
    
    return obj;
}

@end
