//
//  IsJoinedResponsed.h
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsJoinedResponsed : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *data;

+(IsJoinedResponsed *) initWithData:(NSDictionary *)dict;



@end
