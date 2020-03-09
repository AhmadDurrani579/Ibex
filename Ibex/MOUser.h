//
//  MOUser.h
//  YPOPakistan
//
//  Created by Ahmed Durrani on 08/01/2018.
//  Copyright © 2018 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo+CoreDataClass.h"
@interface MOUser : NSObject
+ (void)saveUserInfo:(NSDictionary *)userDict;
+ (UserInfo *)getUser ;
@end
