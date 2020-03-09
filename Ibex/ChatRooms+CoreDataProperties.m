//
//  ChatRooms+CoreDataProperties.m
//  YPO
//
//  Created by Ahmed Durrani on 17/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "ChatRooms+CoreDataProperties.h"

@implementation ChatRooms (CoreDataProperties)

+ (NSFetchRequest<ChatRooms *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChatRooms"];
}

@dynamic room_Name;
@dynamic roomJbID;
@dynamic userJbID;
@dynamic dateOfRecentMessage;
@dynamic lastMessage;

@end
