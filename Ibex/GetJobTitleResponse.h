//
//  GetJobTitleResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetJobTitleResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *success;
@property (nonatomic, strong) NSArray *list;

+(GetJobTitleResponse *) initWithData:(NSDictionary *)dict;

@end
