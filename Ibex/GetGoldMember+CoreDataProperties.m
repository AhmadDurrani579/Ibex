//
//  GetGoldMember+CoreDataProperties.m
//  YPOPakistan
//
//  Created by Ahmed Durrani on 08/01/2018.
//  Copyright © 2018 Sajid Saeed. All rights reserved.
//
//

#import "GetGoldMember+CoreDataProperties.h"

@implementation GetGoldMember (CoreDataProperties)

+ (NSFetchRequest<GetGoldMember *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GetGoldMember"];
}

@dynamic firstName;
@dynamic activated;
@dynamic company;
@dynamic dpName;
@dynamic dpPathMain;
@dynamic dpPathThumb;
@dynamic email;
@dynamic idOfGoldMember;
@dynamic industryId;
@dynamic isBoardMember;
@dynamic phoneNumber;
@dynamic lastName;
@dynamic funcName;
@dynamic jobtitle;
@dynamic userName;
@dynamic boardDesignation;
@dynamic country_name;
@dynamic country_id;
@dynamic function_name;
@dynamic industry_id;
@dynamic industry_Name;
@dynamic jobTitle;
@dynamic userType;

@end
