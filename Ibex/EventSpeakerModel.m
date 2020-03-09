//
//  EventSpeakerModel.m
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventSpeakerModel.h"
#import "EventSessionModel.h"
#import "Utility.h"

@implementation EventSpeakerModel

+(EventSpeakerModel *) initWithData:(NSDictionary *)masterDict{
    
    EventSpeakerModel *obj = [[EventSpeakerModel alloc] init];
    
    if([masterDict isEqual:[NSNull null]]){
        return obj;
    }
    
   
    NSDictionary *dict = [masterDict objectForKey:@"eventSpeaker"];
    
    if([masterDict objectForKey:@"eventSpeaker"]){
        dict = [masterDict objectForKey:@"eventSpeaker"];
    }
    else if ([masterDict objectForKey:@"organizer"]) {
        dict = [masterDict objectForKey:@"organizer"];
    } else {
        dict = masterDict ;
    }
    
    obj.speakerID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
    obj.speakerFirstName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"firstName"]];
    obj.speakerLastName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"lastName"]];
    obj.speakerFBURL = [NSString stringWithFormat:@"%@", [dict objectForKey:@"facebookURL"]];
    obj.speakerTwitterURL = [NSString stringWithFormat:@"%@", [dict objectForKey:@"twitterURL"]];
    obj.speakerLinkedinURL = [NSString stringWithFormat:@"%@", [dict objectForKey:@"linkedInURL"]];
    obj.speakerWebsite = [NSString stringWithFormat:@"%@", [dict objectForKey:@"website"]];
    obj.speakerEmailAddress = [NSString stringWithFormat:@"%@", [dict objectForKey:@"email"]];
    obj.speakerUserName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"userName"]];
    obj.speakerThumbImg = [NSString stringWithFormat:@"%@", [dict objectForKey:@"dpPathThumb"]];
    obj.speakerBigImage = [NSString stringWithFormat:@"%@", [dict objectForKey:@"dpPathMain"]];
    obj.speakerDPName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"dpName"]];
    obj.speakerBio = [NSString stringWithFormat:@"%@", [dict objectForKey:@"bio"]];
    obj.speakerBlog = [NSString stringWithFormat:@"%@", [dict objectForKey:@"blog"]];
    obj.speakerCompany = [NSString stringWithFormat:@"%@", [dict objectForKey:@"company"]];
    obj.speakerFunctionID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"functionId"]];
    obj.speakerIndustryID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"industryId"]];
    obj.speakerJobTitleID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"jobTitleId"]];
    obj.countryID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"countryId"]];
    obj.phoneNumber = [NSString stringWithFormat:@"%@", [dict objectForKey:@"phoneNumber"]];
    obj.userType = [NSString stringWithFormat:@"%@", [dict objectForKey:@"userTypeId"]] ;
    
    
    
    if([[dict objectForKey:@"industry"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerIndustry = [[dict objectForKey:@"industry"] objectForKey:@"name"];
        
    }
    else if([[dict objectForKey:@"industry"] isKindOfClass:[NSArray class]]){
            
            NSArray *tempIndustry = [dict objectForKey:@"industry"];
            
            for(NSDictionary *tempDict in tempIndustry){
                if([[dict objectForKey:@"industryId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                    obj.speakerIndustry = [tempDict objectForKey:@"name"];
                }
            }
        }
    else{
        obj.speakerIndustry = @"";
    }
    
    if([[dict objectForKey:@"function"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerFunction = [[dict objectForKey:@"function"] objectForKey:@"name"];
        
    }
    
    
    else if([[dict objectForKey:@"function"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"function"];
        
        for(NSDictionary *tempDict in tempIndustry){
            if([[dict objectForKey:@"functionId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                obj.speakerFunction = [tempDict objectForKey:@"name"];
            }
        }
    }
    else{
        obj.speakerFunction = @"";
    }
    
   
    
    if([[dict objectForKey:@"country"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerCountry = [[dict objectForKey:@"country"] objectForKey:@"name"];
        
    }
    else if([[dict objectForKey:@"country"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"country"];
        
        for(NSDictionary *tempDict in tempIndustry){
            if([[dict objectForKey:@"countryId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                obj.speakerCountry = [tempDict objectForKey:@"name"];
            }
        }
    }
    else{
        obj.speakerCountry = @"";
    }
    
    if([[dict objectForKey:@"jobTitle"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerJobTitle = [[dict objectForKey:@"jobTitle"] objectForKey:@"name"];
        
    }
    else if([[dict objectForKey:@"jobTitle"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"country"];
        
        for(NSDictionary *tempDict in tempIndustry){
            if([[dict objectForKey:@"jobTitleId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                obj.speakerJobTitle = [tempDict objectForKey:@"name"];
            }
        }
    }
    else{
        obj.speakerJobTitle = @"";
    }
    if([[dict objectForKey:@"roles"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"roles"];
        
        for(NSDictionary *tempDict in tempIndustry){
                obj.roleID = [[tempDict objectForKey:@"roleId"] stringValue];
            
        }
    }
    
//    if([[dict objectForKey:@"roles"] isKindOfClass:[NSDictionary class]] ){
//        obj.roleID = [[dict objectForKey:@"roles"] objectForKey:@"roleId"];
//
//    }


    if([[masterDict objectForKey:@"eventSession"] isKindOfClass:[NSDictionary class]] ){
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        [tempList addObject:[EventSessionModel initWithData:[masterDict objectForKey:@"eventSession"]]];
        obj.speakerSessionList = [tempList mutableCopy];
        
    }
    else if([[masterDict objectForKey:@"eventSession"] isKindOfClass:[NSArray class]]){
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        NSArray *tempEventSession = [masterDict objectForKey:@"eventSession"];
        
        for(NSDictionary *tempDict in tempEventSession){
            [tempList addObject:[EventSessionModel initWithData:tempDict]];
        }
        obj.speakerSessionList = [tempList mutableCopy];
    }
    else{
        obj.speakerSessionList = [NSArray new];
    }
    

    
    
    
    return obj;
}

+(EventSpeakerModel *) initWithDataAttendee:(NSDictionary *)masterDict{
    
    EventSpeakerModel *obj = [[EventSpeakerModel alloc] init];
    
    if([masterDict isEqual:[NSNull null]]){
        return obj;
    }
    
    NSDictionary *dict = masterDict;
    
    obj.speakerID = [dict objectForKey:@"id"];
    obj.speakerFirstName = [dict objectForKey:@"firstName"];
    obj.speakerLastName = [dict objectForKey:@"lastName"];
    obj.speakerFBURL = [dict objectForKey:@"facebookURL"];
    obj.speakerTwitterURL = [dict objectForKey:@"twitterURL"];
    obj.speakerLinkedinURL = [dict objectForKey:@"linkedInURL"];
    obj.speakerWebsite = [dict objectForKey:@"website"];
    obj.speakerEmailAddress = [dict objectForKey:@"email"];
    obj.speakerUserName = [dict objectForKey:@"userName"];
    obj.speakerThumbImg = [dict objectForKey:@"dpPathThumb"];
    obj.speakerBigImage = [dict objectForKey:@"dpPathMain"];
    obj.speakerDPName = [dict objectForKey:@"dpName"];
    obj.speakerBio = [dict objectForKey:@"bio"];
    obj.speakerBlog = [dict objectForKey:@"blog"];
    obj.speakerCompany = [dict objectForKey:@"company"];

    
    if([[dict objectForKey:@"industry"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerIndustry = [[dict objectForKey:@"industry"] objectForKey:@"name"];
        
    }
    else if([[dict objectForKey:@"industry"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"industry"];
        
        for(NSDictionary *tempDict in tempIndustry){
            if([[dict objectForKey:@"industryId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                obj.speakerIndustry = [tempDict objectForKey:@"name"];
            }
        }
    }
    else{
        obj.speakerIndustry = @"";
    }
    
    if([[dict objectForKey:@"function"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerFunction = [[dict objectForKey:@"function"] objectForKey:@"name"];
        
    }
    
    
    else if([[dict objectForKey:@"function"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"function"];
        
        for(NSDictionary *tempDict in tempIndustry){
            if([[dict objectForKey:@"functionId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                obj.speakerFunction = [tempDict objectForKey:@"name"];
            }
        }
    }
    else{
        obj.speakerFunction = @"";
    }
    
    
 
    if([[dict objectForKey:@"country"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerCountry = [[dict objectForKey:@"country"] objectForKey:@"name"];
        
    }
    else if([[dict objectForKey:@"country"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"country"];
        
        for(NSDictionary *tempDict in tempIndustry){
            if([[dict objectForKey:@"countryId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                obj.speakerCountry = [tempDict objectForKey:@"name"];
            }
        }
    }
    else{
        obj.speakerCountry = @"";
    }
    
    if([[dict objectForKey:@"jobTitle"] isKindOfClass:[NSDictionary class]] ){
        obj.speakerJobTitle = [[dict objectForKey:@"jobTitle"] objectForKey:@"name"];
        
    }
    else if([[dict objectForKey:@"jobTitle"] isKindOfClass:[NSArray class]]){
        
        NSArray *tempIndustry = [dict objectForKey:@"country"];
        
        for(NSDictionary *tempDict in tempIndustry){
            if([[dict objectForKey:@"jobTitleId"] isEqualToString:[tempDict objectForKey:@"id"]]){
                obj.speakerJobTitle = [tempDict objectForKey:@"name"];
            }
        }
    }
    else{
        obj.speakerJobTitle = @"";
    }
    

    return obj;
}
@end

