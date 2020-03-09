//
//  SignupResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignupResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;

+(SignupResponse*) initWithData:(NSDictionary*)dict;

@end
