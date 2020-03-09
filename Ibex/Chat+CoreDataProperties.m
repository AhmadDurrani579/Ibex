//
//  Chat+CoreDataProperties.m
//  YPOPakistan
//
//  Created by Ahmed Durrani on 27/12/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "Chat+CoreDataProperties.h"

@implementation Chat (CoreDataProperties)

+ (NSFetchRequest<Chat *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Chat"];
}

@dynamic chat_Id;
@dynamic dateOfMessage;
@dynamic from_Jabber;
@dynamic image;
@dynamic imageUrl;
@dynamic is_Mine;
@dynamic jaber_ID;
@dynamic message;
@dynamic messageStatus;
@dynamic messageType;
@dynamic sender_Image;
@dynamic sender_Name;
@dynamic senderId;
@dynamic to_Jabber;
@dynamic isMessageSend;

@end
