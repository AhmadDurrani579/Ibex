//
//  ChatRooms+CoreDataProperties.h
//  YPO
//
//  Created by Ahmed Durrani on 17/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "ChatRooms+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChatRooms (CoreDataProperties)

+ (NSFetchRequest<ChatRooms *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *room_Name;
@property (nullable, nonatomic, copy) NSString *roomJbID;
@property (nullable, nonatomic, copy) NSString *userJbID;
@property (nullable, nonatomic, copy) NSDate *dateOfRecentMessage;
@property (nullable, nonatomic, copy) NSString *lastMessage;

@end

NS_ASSUME_NONNULL_END
