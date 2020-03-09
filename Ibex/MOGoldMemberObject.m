//
//  MOGoldMemberObject.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MOGoldMemberObject.h"
#import "GetGoldMember+CoreDataClass.h"

@implementation MOGoldMemberObject

+(MOGoldMemberObject*)initWithData:(NSDictionary *)dict{
    
    MOGoldMemberObject *obj = [[MOGoldMemberObject alloc] init];
    GetGoldMember *goldMember = [GetGoldMember fetchWithPredicate:[NSPredicate predicateWithFormat:@"idOfGoldMember == %@",dict[@"id"]] sortDescriptor:nil fetchLimit:1].lastObject;
   
    if(!goldMember)
    {
        goldMember = (GetGoldMember *) [GetGoldMember create];
    }


    obj.firstName = [dict objectForKey:@"firstName"];
    obj.activated = [[dict objectForKey:@"activated"] stringValue];
    obj.company = [dict objectForKey:@"company"];
    obj.dpName = [dict objectForKey:@"dpName"];
    obj.dpPathMain = [dict objectForKey:@"dpPathMain"];
    obj.dpPathThumb = [dict objectForKey:@"dpPathThumb"];
    obj.email = [dict objectForKey:@"email"];
    
    goldMember.firstName = [dict objectForKey:@"firstName"];
    goldMember.activated = [[dict objectForKey:@"activated"] stringValue];
    id  companyName = [dict objectForKey:@"company"] ;
    if (companyName != [NSNull null]) {
        goldMember.company = companyName;
    } else {
        goldMember.company = @" ";
        
    }
//    goldMember.company = [dict objectForKey:@"company"];
    id  dpPathMain = [dict objectForKey:@"dpPathMain"] ;
    id  dpPathThumb = [dict objectForKey:@"dpPathThumb"] ;

    id  dpOfName = [dict objectForKey:@"dpName"] ;

    if (dpPathMain != [NSNull null]) {
        goldMember.dpPathMain = dpPathMain;
    } else {
        goldMember.dpPathMain = @" ";

    }
    if (dpPathThumb != [NSNull null]) {
        goldMember.dpPathThumb = dpPathThumb;
    } else {
        goldMember.dpPathThumb = @" ";
        
    }
    
    if (dpOfName != [NSNull null]) {
        goldMember.dpName = dpOfName;
    } else {
        goldMember.dpName = @" ";
        
    }
//    goldMember.dpName = [dict objectForKey:@"dpName"];
//    goldMember.dpPathMain = [dict objectForKey:@"dpPathMain"];
//    goldMember.dpPathThumb = [dict objectForKey:@"dpPathThumb"];
    goldMember.email = [dict objectForKey:@"email"];
    goldMember.idOfGoldMember = [[dict objectForKey:@"id"] stringValue];
    goldMember.industryId = [[dict objectForKey:@"industryId"] stringValue];

    
    
    obj.ids = [[dict objectForKey:@"id"] stringValue];
    obj.emailConfirmed = [dict objectForKey:@"emailConfirmed"];
    obj.industryId = [dict objectForKey:@"industryId"];
    obj.isBoardMember = [dict objectForKey:@"isBoardMember"];
    goldMember.isBoardMember = [[dict objectForKey:@"isBoardMember"] stringValue];

    obj.isActive = [dict objectForKey:@"isActive"];
    
    
    obj.phoneNumber = [dict objectForKey:@"phoneNumber"];
    
    id  phoneNum = [dict objectForKey:@"phoneNumber"] ;
    
    if (phoneNum != [NSNull null]) {
        goldMember.phoneNumber = phoneNum;
    } else {
        goldMember.phoneNumber = @" ";
        
    }

//    goldMember.phoneNumber = [[dict objectForKey:@"phoneNumber"] stringValue];

    obj.lastName = [dict objectForKey:@"lastName"];
    goldMember.lastName = [dict objectForKey:@"lastName"];

    obj.phoneNumberConfirmed = [dict objectForKey:@"phoneNumberConfirmed"];
    obj.funcName = [dict objectForKey:@"funcName"];
    goldMember.funcName = [dict objectForKey:@"funcName"];

    
    obj.industryName = [dict objectForKey:@"industryName"];
    obj.jobtitle = [dict objectForKey:@"jobtitle"];
    goldMember.jobtitle = [dict objectForKey:@"jobtitle"];

    obj.userName = [dict objectForKey:@"userName"];
    goldMember.userName = [dict objectForKey:@"userName"];

    obj.boardDesig = [dict objectForKey:@"boardDesignation"];
    goldMember.boardDesignation = [dict objectForKey:@"boardDesig"];


    
    if([[dict objectForKey:@"country"] isKindOfClass:[NSDictionary class]]){
        obj.countryName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"country"] objectForKey:@"name"]];
        goldMember.country_name = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"country"] objectForKey:@"name"]];

        obj.countryId   = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"country"] objectForKey:@"id"]];
        goldMember.country_id = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"country"] objectForKey:@"id"]];

    }
    
    if([[dict objectForKey:@"function"] isKindOfClass:[NSDictionary class]]){
        obj.funcName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"function"] objectForKey:@"name"]];
        goldMember.funcName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"function"] objectForKey:@"name"]];

    }
    
    if([[dict objectForKey:@"industry"] isKindOfClass:[NSDictionary class]]){
        obj.industryName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"industry"] objectForKey:@"name"]];
        goldMember.industry_Name = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"industry"] objectForKey:@"name"]];

        obj.industryId = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"industry"] objectForKey:@"id"]];
        goldMember.industryId = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"industry"] objectForKey:@"id"]];


    }
  
    if([[dict objectForKey:@"jobTitle"] isKindOfClass:[NSDictionary class]]){
        obj.jobtitle = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"jobTitle"] objectForKey:@"name"]];
        goldMember.jobtitle = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"jobTitle"] objectForKey:@"name"]];

    }
    if([[dict objectForKey:@"userType"] isKindOfClass:[NSDictionary class]]){
        obj.userType = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"userType"] objectForKey:@"name"]];

        goldMember.userType = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"userType"] objectForKey:@"name"]];
        
    }
    
    [GetGoldMember save];
    

    
    return obj;
    
}



@end
