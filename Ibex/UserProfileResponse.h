//
//  UserProfileResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 10/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventSpeakerModel.h"

@interface UserProfileResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) EventSpeakerModel *user;

+(UserProfileResponse *) initWithData:(NSDictionary *)dict;

@end
