//
//  SponsorModel.h
//  Ibex
//
//  Created by Sajid Saeed on 05/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SponsorModel : NSObject


@property (nonatomic, strong) NSString *sponsorName;
@property (nonatomic, strong) NSString *sponsorDesc;
@property (nonatomic, strong) NSString *sponsorID;
@property (nonatomic, strong) NSString *sponsorURL;
@property (nonatomic, strong) NSString *sponsorThumb;
@property (nonatomic, strong) NSString *sponsorImg;
@property (nonatomic, strong) NSString *sponsorIsActive;
@property (nonatomic, strong) NSString *sponsorTypeID;

+(SponsorModel *) initWithData:(NSDictionary *) dict;
@end
