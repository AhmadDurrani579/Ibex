//
//  EventListResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 03/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventListResponse : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSArray *eventList;

+(EventListResponse*) initWithData:(NSDictionary *)dict;


@end
