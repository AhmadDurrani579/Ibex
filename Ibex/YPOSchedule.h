//
//  YPOSchedule.h
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPOSchedule : NSObject
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSArray *eventList;

+(YPOSchedule*) initWithData:(NSDictionary *)dict;

@end
