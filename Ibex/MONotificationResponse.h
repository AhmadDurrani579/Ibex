//
//  MONotificationResponse.h
//  YPO
//
//  Created by Ahmed Durrani on 08/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MONotificationResponse : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSArray *notificationList;

+(MONotificationResponse*) initWithData:(NSDictionary *)dict;

@end
