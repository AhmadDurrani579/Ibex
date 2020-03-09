//
//  EventSessionModel.h
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventSessionModel : NSObject

@property (nonatomic, strong) NSString *eventTitle;
@property (nonatomic, strong) NSString *eventDesc;
@property (nonatomic, strong) NSString *eventLocation;
@property (nonatomic, strong) NSString *eventEventID;
@property (nonatomic, strong) NSString *eventDate;
@property (nonatomic, strong) NSString *eventTimeFrom;
@property (nonatomic, strong) NSString *eventTimeTo;
@property (nonatomic, strong) NSString *eventTrackName;

+(EventSessionModel *) initWithData:(NSDictionary *)dict;

@end
