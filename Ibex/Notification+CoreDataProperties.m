//
//  Notification+CoreDataProperties.m
//  YPO
//
//  Created by Ahmed Durrani on 05/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "Notification+CoreDataProperties.h"

@implementation Notification (CoreDataProperties)

+ (NSFetchRequest<Notification *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
}

@dynamic notification_icon;
@dynamic notification_message;
@dynamic notification_Time;

@end
