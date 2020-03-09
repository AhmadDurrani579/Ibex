//
//  MONotificationObject.h
//  YPO
//
//  Created by Ahmed Durrani on 08/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MONotificationObject : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *sentDate;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, assign) NSInteger *idOfNotify;




+(MONotificationObject*) initWithData:(NSDictionary*)dict;


@end
