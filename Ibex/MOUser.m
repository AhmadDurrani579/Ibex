//
//  MOUser.m
//  YPOPakistan
//
//  Created by Ahmed Durrani on 08/01/2018.
//  Copyright © 2018 Sajid Saeed. All rights reserved.
//

#import "MOUser.h"
#import "UserInfo+CoreDataClass.h"

@implementation MOUser
+ (void)saveUserInfo:(NSDictionary *)userDict {
    UserInfo *user = [UserInfo fetchWithPredicate:[NSPredicate predicateWithFormat:@"loginUserName == %@",userDict[@"userName"]] sortDescriptor:nil fetchLimit:1].lastObject;

    if(!user)
    {
        user = (UserInfo *) [UserInfo create];
    }
    user.accessToken = userDict[@"access_token"];
    user.loginUserName = userDict[@"userName"];
    user.loginUserId = userDict[@"userId"];
    user.loginRoleId = userDict[@"roleId"];
    user.loginRoleName = userDict[@"roleName"];
    user.loginUserDp = userDict[@"userDP"];
    user.loginDisplayName = userDict[@"displayName"];
    user.isBoardMember = userDict[@"isBoardMember"];
    user.userType = userDict[@"access_token"];
    user.phoneNumber = userDict[@"userType"];
    [[NSUserDefaults standardUserDefaults] setValue:userDict forKey:@"currentuser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UserInfo save];
    
    
}
+ (UserInfo *)getUser
{
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentuser"];
    return  [UserInfo fetchWithPredicate:[NSPredicate predicateWithFormat:@"loginUserName == %@",user[@"userName"]] sortDescriptor:nil fetchLimit:1].lastObject;
}


@end
