//
//  QuestionObject.h
//  Ibex
//
//  Created by Sajid Saeed on 13/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionObject : NSObject

@property (nonatomic, strong) NSString *qQuestion;
@property (nonatomic, strong) NSString *qAnswer;
@property (nonatomic, strong) NSString *qID;
@property (nonatomic, strong) NSString *qIsActive;
@property (nonatomic, strong) NSString *qEventID;
@property (nonatomic, strong) NSString *qCreateDate;
@property (nonatomic, strong) NSString *qModifiedDate;
@property (nonatomic, strong) NSString *qEventName;

    
    @property (nonatomic, strong) NSArray *events;

+(QuestionObject *) initWithData:(NSDictionary *)dict;

@end
