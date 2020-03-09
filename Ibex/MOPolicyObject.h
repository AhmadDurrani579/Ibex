//
//  MOPolicyObject.h
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOPolicyObject : NSObject

@property (nonatomic, strong) NSString *descriptionOfPolicy;
@property (nonatomic, strong) NSString *idOfPolicy;


+(MOPolicyObject*) initWithData:(NSDictionary*)dict;

@end
