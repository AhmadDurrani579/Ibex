//
//  UpdateResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 16/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;

+(UpdateResponse *) initWithData:(NSDictionary *)dict;

@end
