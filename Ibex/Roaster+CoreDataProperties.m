//
//  Roaster+CoreDataProperties.m
//  YPO
//
//  Created by Ahmed Durrani on 17/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "Roaster+CoreDataProperties.h"

@implementation Roaster (CoreDataProperties)

+ (NSFetchRequest<Roaster *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Roaster"];
}

@dynamic dateOfRecentMessage;
@dynamic jaber_ID;
@dynamic message_Type;
@dynamic sender_ID;
@dynamic sender_Image;
@dynamic sender_Name;
@dynamic lastMessage;

@end
