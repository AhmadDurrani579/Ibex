//
//  ForgotPasswordResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForgotPasswordResponse : NSObject

@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;

+(ForgotPasswordResponse *) initWithData:(NSDictionary*)dict;

@end
