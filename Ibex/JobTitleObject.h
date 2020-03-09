//
//  JobTitleObject.h
//  Ibex
//
//  Created by Sajid Saeed on 04/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobTitleObject : NSObject

@property (nonatomic, strong) NSString *jobID;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *jobisActive;


+(JobTitleObject *) initWithData:(NSDictionary *) dict;
@end
