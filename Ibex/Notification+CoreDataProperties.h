//
//  Notification+CoreDataProperties.h
//  YPO
//
//  Created by Ahmed Durrani on 05/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//
//

#import "Notification+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Notification (CoreDataProperties)

+ (NSFetchRequest<Notification *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *notification_icon;
@property (nullable, nonatomic, copy) NSString *notification_message;
@property (nullable, nonatomic, copy) NSString *notification_Time;

@end

NS_ASSUME_NONNULL_END
