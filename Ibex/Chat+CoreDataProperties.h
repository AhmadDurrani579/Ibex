//
//  Chat+CoreDataProperties.h
//  YPOPakistan
//
//  Created by Ahmed Durrani on 27/12/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "Chat+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Chat (CoreDataProperties)

+ (NSFetchRequest<Chat *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *chat_Id;
@property (nullable, nonatomic, copy) NSString *dateOfMessage;
@property (nullable, nonatomic, copy) NSString *from_Jabber;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nonatomic) BOOL is_Mine;
@property (nullable, nonatomic, copy) NSString *jaber_ID;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *messageStatus;
@property (nullable, nonatomic, copy) NSString *messageType;
@property (nullable, nonatomic, copy) NSString *sender_Image;
@property (nullable, nonatomic, copy) NSString *sender_Name;
@property (nullable, nonatomic, copy) NSString *senderId;
@property (nullable, nonatomic, copy) NSString *to_Jabber;
@property (nullable, nonatomic, copy) NSString *isMessageSend;

@end

NS_ASSUME_NONNULL_END
