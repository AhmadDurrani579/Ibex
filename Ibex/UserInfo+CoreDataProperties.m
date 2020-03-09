//
//  UserInfo+CoreDataProperties.m
//  YPOPakistan
//
//  Created by Ahmed Durrani on 08/01/2018.
//  Copyright © 2018 Sajid Saeed. All rights reserved.
//
//

#import "UserInfo+CoreDataProperties.h"

@implementation UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
}

@dynamic accessToken;
@dynamic isBoardMember;
@dynamic loginDisplayName;
@dynamic loginRoleId;
@dynamic loginRoleName;
@dynamic loginUserDp;
@dynamic loginUserId;
@dynamic loginUserName;
@dynamic phoneNumber;
@dynamic userType;

@end
