//
//  PrivacyPolicyModel.h
//  YPOPakistan
//
//  Created by Ahmed Durrani on 13/12/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivacyPolicyModel : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSArray *arrayOfNewsLetter;

+(PrivacyPolicyModel*) initWithData:(NSDictionary *)dict;

@end
