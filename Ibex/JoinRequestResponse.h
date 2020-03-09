//
//  JoinRequestResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinRequestResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;

+(JoinRequestResponse *) initWithData:(NSDictionary *)dict;

@end
