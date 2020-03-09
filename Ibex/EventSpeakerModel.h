//
//  EventSpeakerModel.h
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventSpeakerModel : NSObject

@property (nonatomic, strong) NSString *speakerDPName;
@property (nonatomic, strong) NSString *speakerFirstName;
@property (nonatomic, strong) NSString *speakerLastName;
@property (nonatomic, strong) NSString *speakerFBURL;
@property (nonatomic, strong) NSString *speakerTwitterURL;
@property (nonatomic, strong) NSString *speakerLinkedinURL;
@property (nonatomic, strong) NSString *speakerEmailAddress;
@property (nonatomic, strong) NSString *speakerUserName;
@property (nonatomic, strong) NSString *speakerThumbImg;
@property (nonatomic, strong) NSString *speakerBigImage;
@property (nonatomic, strong) NSString *speakerWebsite;
@property (nonatomic, strong) NSString *speakerBio;
@property (nonatomic, strong) NSString *speakerBlog;
@property (nonatomic, strong) NSString *speakerJobTitle;
@property (nonatomic, strong) NSString *speakerIndustry;
@property (nonatomic, strong) NSString *speakerFunction;
@property (nonatomic, strong) NSString *speakerCountry;
@property (nonatomic, strong) NSString *speakerCompany;
@property (nonatomic, strong) NSString *speakerFunctionID;
@property (nonatomic, strong) NSString *speakerIndustryID;
@property (nonatomic, strong) NSString *speakerJobTitleID;
@property (nonatomic, strong) NSString *speakerID;
@property (nonatomic, strong) NSString *countryID;
@property (nonatomic, strong) NSString *roleID;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *userType;





@property (nonatomic, strong) NSArray *speakerSessionList;

+(EventSpeakerModel *) initWithDataAttendee:(NSDictionary *)masterDict;
+(EventSpeakerModel *) initWithData:(NSDictionary *)dict;


@end
