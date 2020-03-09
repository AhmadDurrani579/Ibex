//
//  YPOSearchEventList.h
//  YPO
//
//  Created by Ahmed Durrani on 25/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPOSearchEventList : NSObject
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSArray *eventList;
@property (nonatomic, strong) NSArray *searchUserList;


+(YPOSearchEventList *) initWithData:(NSDictionary *)dict;

@end
