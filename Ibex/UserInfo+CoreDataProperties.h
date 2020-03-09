//
//  UserInfo+CoreDataProperties.h
//  YPOPakistan
//
//  Created by Ahmed Durrani on 08/01/2018.
//  Copyright © 2018 Sajid Saeed. All rights reserved.
//
//

#import "UserInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accessToken;
@property (nullable, nonatomic, copy) NSString *isBoardMember;
@property (nullable, nonatomic, copy) NSString *loginDisplayName;
@property (nullable, nonatomic, copy) NSString *loginRoleId;
@property (nullable, nonatomic, copy) NSString *loginRoleName;
@property (nullable, nonatomic, copy) NSString *loginUserDp;
@property (nullable, nonatomic, copy) NSString *loginUserId;
@property (nullable, nonatomic, copy) NSString *loginUserName;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, copy) NSString *userType;

@end

NS_ASSUME_NONNULL_END
