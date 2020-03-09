//
//  loginResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loginResponse : NSObject

@property (nonatomic, strong) NSString *loginAccessToken;
@property (nonatomic, strong) NSString *loginTokenType;
@property (nonatomic, strong) NSString *loginExpiresIn;
@property (nonatomic, strong) NSString *loginUserName;
@property (nonatomic, strong) NSString *loginUserID;
@property (nonatomic, strong) NSString *loginRoleID;
@property (nonatomic, strong) NSString *loginRoleName;
@property (nonatomic, strong) NSString *loginUserDP;
@property (nonatomic, strong) NSString *loginDisplayName;
@property (nonatomic, strong) NSString *loginError;
@property (nonatomic, strong) NSString *loginErrorDesc;
@property (nonatomic, strong) NSString *phoneNumber;

@property (nonatomic, strong) NSString *isBoardMember;
@property (nonatomic, strong) NSString *userType;


+(loginResponse *) initWithData:(NSDictionary *)dict;

@end
