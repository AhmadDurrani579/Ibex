//
//  EventObject.h
//  Ibex
//
//  Created by Sajid Saeed on 03/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObject : NSObject

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *eventVenueName;
@property (nonatomic, strong) NSString *eventVenueAddress;
@property (nonatomic, strong) NSString *eventVenueLat;
@property (nonatomic, strong) NSString *eventVenueLong;
@property (nonatomic, strong) NSString *eventStartDate;
@property (nonatomic, strong) NSString *eventEndDate;
@property (nonatomic, strong) NSString *eventStartTime;
@property (nonatomic, strong) NSString *eventEndTime;
@property (nonatomic, strong) NSString *eventEventID;
@property (nonatomic, strong) NSString *eventThumbImg;
@property (nonatomic, strong) NSString *eventBigImg;
@property (nonatomic, strong) NSString *eventRegistrationType;
@property (nonatomic, strong) NSString *eventTopic;
@property (nonatomic, strong) NSString *eventType;
@property (nonatomic, strong) NSString *isFeatured;
@property (nonatomic, strong) NSString *isEventGoldOrYPO;
@property (nonatomic, strong) NSString *organizerList;

@property (nonatomic, strong) NSArray *supportingContentList;
@property (nonatomic, strong) NSArray *organizerArray;

@property (nonatomic, strong) NSDictionary *organizer;
@property (nonatomic, strong) NSDictionary *admin;



+(EventObject*) initWithData:(NSDictionary*)dict;

@end
