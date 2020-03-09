//
//  loginResponse.m
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "loginResponse.h"

@implementation loginResponse

+(loginResponse *) initWithData:(NSDictionary *)dict{
 
    loginResponse *obj = [[loginResponse alloc] init];
    obj.loginAccessToken = [dict objectForKey:@"access_token"];
    obj.loginTokenType =   [dict objectForKey:@"token_type"];
    obj.loginExpiresIn =   [dict objectForKey:@"expires_in"];
    obj.loginUserName =    [dict objectForKey:@"userName"];
    obj.loginUserID =      [dict objectForKey:@"userId"];
    obj.loginRoleID =      [dict objectForKey:@"roleId"];
    obj.loginRoleName =    [dict objectForKey:@"roleName"];
    obj.loginUserDP =      [dict objectForKey:@"userDP"];
    obj.loginDisplayName = [dict objectForKey:@"displayName"];
    obj.loginError =       [dict objectForKey:@"error"];
    obj.loginErrorDesc =   [dict objectForKey:@"error_description"];
    obj.isBoardMember =    [dict objectForKey:@"isBoardMember"];
    obj.phoneNumber =      [dict objectForKey:@"phoneNumber"];
    obj.userType =         [dict objectForKey:@"userType"];
    
    return obj;
}

@end
