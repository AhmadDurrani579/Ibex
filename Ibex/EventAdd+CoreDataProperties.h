//
//  EventAdd+CoreDataProperties.h
//  Ibex
//
//  Created by Ahmed Durrani on 04/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventAdd+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventAdd (CoreDataProperties)

+ (NSFetchRequest<EventAdd *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *endDate;
@property (nullable, nonatomic, copy) NSString *endTime;
@property (nonatomic) BOOL isAdded;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *scheduleAddress;
@property (nullable, nonatomic, copy) NSString *scheduleDescription;
@property (nullable, nonatomic, copy) NSString *scheduleId;
@property (nullable, nonatomic, copy) NSString *startDate;
@property (nullable, nonatomic, copy) NSString *startTime;
@property (nullable, nonatomic, copy) NSString *eventIdentifier;

@end

NS_ASSUME_NONNULL_END
