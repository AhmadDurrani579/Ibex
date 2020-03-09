//
//  PrivacyPolicyModel.m
//  YPOPakistan
//
//  Created by Ahmed Durrani on 13/12/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "PrivacyPolicyModel.h"
#import "NewsLetterModelObject.h"

@implementation PrivacyPolicyModel

+(PrivacyPolicyModel*) initWithData:(NSDictionary *)dict{
    
    PrivacyPolicyModel *obj = [[PrivacyPolicyModel alloc] init];
    
    obj.message = [dict objectForKey:@"message"];
    obj.status = [dict objectForKey:@"status"];
    
    NSMutableArray *temptList = [[NSMutableArray alloc] init];
    NSArray *tempArr = [dict objectForKey:@"data"];
    
    for(NSDictionary *masterObj in tempArr){
        [temptList addObject:[NewsLetterModelObject initWithData:masterObj]];
        
    }
    
    obj.arrayOfNewsLetter = [temptList mutableCopy];
    
    return obj;
    
}


@end
