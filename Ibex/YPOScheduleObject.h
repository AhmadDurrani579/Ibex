//
//  YPOScheduleObject.h
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPOScheduleObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionOfEvent;
@property (nonatomic, strong) NSString *contactEmail;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *idOfEvent;
@property (nonatomic, strong) NSString *isActive;
@property (nonatomic, strong)  NSString *isFeatured;
@property (nonatomic, strong) NSString *isPublished;
@property (nonatomic, strong) NSString *logoPathMain;
@property (nonatomic, strong) NSString *logoPathThumb;
@property (nonatomic, strong) NSString *orgnaizerId;
@property (nonatomic, strong) NSString *registrationGoal;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *eventRegistrationType;
@property (nonatomic, strong) NSString *eventTopic;
@property (nonatomic, strong) NSString *venueLat;
@property (nonatomic, strong) NSString *venueLng;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSArray *supportingContentList;






+(YPOScheduleObject*) initWithData:(NSDictionary*)dict;


@end
