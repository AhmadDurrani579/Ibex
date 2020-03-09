//
//  GroupChatMessageStatus+CoreDataProperties.m
//  YPO
//
//  Created by Ahmed Durrani on 11/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "GroupChatMessageStatus+CoreDataProperties.h"

@implementation GroupChatMessageStatus (CoreDataProperties)

+ (NSFetchRequest<GroupChatMessageStatus *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GroupChatMessageStatus"];
}

@dynamic messageStatus;
@dynamic jabberIdOfUser;

@end
