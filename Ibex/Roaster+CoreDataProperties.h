//
//  Roaster+CoreDataProperties.h
//  YPO
//
//  Created by Ahmed Durrani on 17/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "Roaster+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Roaster (CoreDataProperties)

+ (NSFetchRequest<Roaster *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *dateOfRecentMessage;
@property (nullable, nonatomic, copy) NSString *jaber_ID;
@property (nullable, nonatomic, copy) NSString *message_Type;
@property (nullable, nonatomic, copy) NSString *sender_ID;
@property (nullable, nonatomic, copy) NSString *sender_Image;
@property (nullable, nonatomic, copy) NSString *sender_Name;
@property (nullable, nonatomic, copy) NSString *lastMessage;

@end

NS_ASSUME_NONNULL_END
