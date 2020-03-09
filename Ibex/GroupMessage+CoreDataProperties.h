//
//  GroupMessage+CoreDataProperties.h
//  YPO
//
//  Created by Ahmed Durrani on 16/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "GroupMessage+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GroupMessage (CoreDataProperties)

+ (NSFetchRequest<GroupMessage *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *dateAndTimeOfMessage;
@property (nullable, nonatomic, copy) NSString *fromJabber_Id;
@property (nullable, nonatomic, copy) NSString *group_Jabber_Id;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nonatomic) BOOL is_Mine;
@property (nullable, nonatomic, copy) NSString *messageOfGroup;
@property (nullable, nonatomic, copy) NSString *messageType;
@property (nullable, nonatomic, copy) NSString *packet_Id;
@property (nullable, nonatomic, copy) NSString *senderName;

@end

NS_ASSUME_NONNULL_END
