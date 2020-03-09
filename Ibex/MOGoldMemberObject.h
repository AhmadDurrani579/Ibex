//
//  MOGoldMemberObject.h
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOGoldMemberObject : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *activated;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *countryId;
@property (nonatomic, strong) NSString *dpName;
@property (nonatomic, strong) NSString *dpPathMain;
@property (nonatomic, strong) NSString *dpPathThumb;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *emailConfirmed;
@property (nonatomic, strong) NSString *ids;
@property (nonatomic, strong) NSString *industryId;
@property (nonatomic, strong) NSString *isBoardMember;
@property (nonatomic, strong) NSString *isActive;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumberConfirmed;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *funcName;
@property (nonatomic, strong) NSString *industryName;
@property (nonatomic, strong) NSString *jobtitle;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *boardDesig;
@property (nonatomic, strong) NSString *userType;





//@property (nonatomic, strong) NSArray *supportingContentList;

+(MOGoldMemberObject*) initWithData:(NSDictionary*)dict;


@end
