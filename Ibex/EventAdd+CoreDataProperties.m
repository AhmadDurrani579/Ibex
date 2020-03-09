//
//  EventAdd+CoreDataProperties.m
//  Ibex
//
//  Created by Ahmed Durrani on 04/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventAdd+CoreDataProperties.h"

@implementation EventAdd (CoreDataProperties)

+ (NSFetchRequest<EventAdd *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventAdd"];
}

@dynamic endDate;
@dynamic endTime;
@dynamic isAdded;
@dynamic name;
@dynamic scheduleAddress;
@dynamic scheduleDescription;
@dynamic scheduleId;
@dynamic startDate;
@dynamic startTime;
@dynamic eventIdentifier;

@end
