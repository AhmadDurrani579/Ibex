//
//  GetGoldMember+CoreDataProperties.h
//  YPOPakistan
//
//  Created by Ahmed Durrani on 08/01/2018.
//  Copyright © 2018 Sajid Saeed. All rights reserved.
//
//

#import "GetGoldMember+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GetGoldMember (CoreDataProperties)

+ (NSFetchRequest<GetGoldMember *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *activated;
@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *dpName;
@property (nullable, nonatomic, copy) NSString *dpPathMain;
@property (nullable, nonatomic, copy) NSString *dpPathThumb;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *idOfGoldMember;
@property (nullable, nonatomic, copy) NSString *industryId;
@property (nullable, nonatomic, copy) NSString *isBoardMember;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *funcName;
@property (nullable, nonatomic, copy) NSString *jobtitle;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *boardDesignation;
@property (nullable, nonatomic, copy) NSString *country_name;
@property (nullable, nonatomic, copy) NSString *country_id;
@property (nullable, nonatomic, copy) NSString *function_name;
@property (nullable, nonatomic, copy) NSString *industry_id;
@property (nullable, nonatomic, copy) NSString *industry_Name;
@property (nullable, nonatomic, copy) NSString *jobTitle;
@property (nullable, nonatomic, copy) NSString *userType;

@end

NS_ASSUME_NONNULL_END
