//
//  EventCountResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 19/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventCountResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *sessionCount;
@property (nonatomic, strong) NSString *trackCount;
@property (nonatomic, strong) NSString *speakerCount;

+(EventCountResponse *) initWithData:(NSDictionary *)dict;

@end
