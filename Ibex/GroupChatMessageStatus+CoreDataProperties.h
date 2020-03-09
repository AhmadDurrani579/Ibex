//
//  GroupChatMessageStatus+CoreDataProperties.h
//  YPO
//
//  Created by Ahmed Durrani on 11/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "GroupChatMessageStatus+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GroupChatMessageStatus (CoreDataProperties)

+ (NSFetchRequest<GroupChatMessageStatus *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *messageStatus;
@property (nullable, nonatomic, copy) NSString *jabberIdOfUser;

@end

NS_ASSUME_NONNULL_END
