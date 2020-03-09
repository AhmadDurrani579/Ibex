//
//  FAQResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 13/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAQResponse : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *questionList;

+(FAQResponse*) initWithData:(NSDictionary *)dict;

@end
