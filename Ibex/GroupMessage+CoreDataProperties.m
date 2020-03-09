//
//  GroupMessage+CoreDataProperties.m
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "GroupMessage+CoreDataProperties.h"

@implementation GroupMessage (CoreDataProperties)

+ (NSFetchRequest<GroupMessage *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GroupMessage"];
}

@dynamic dateAndTimeOfMessage;
@dynamic fromJabber_Id;
@dynamic group_Jabber_Id;
@dynamic image;
@dynamic imageUrl;
@dynamic is_Mine;
@dynamic messageOfGroup;
@dynamic messageType;
@dynamic packet_Id;
@dynamic senderName;

@end
