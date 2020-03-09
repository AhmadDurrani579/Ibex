//
//  SponsorsResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SponsorsResponse : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *sponsorList;

+(SponsorsResponse *) initWithData:(NSDictionary *)dict;

@end
