//
//  EventSupportModel.h
//  Ibex
//
//  Created by Sajid Saeed on 19/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventSupportModel : NSObject

@property (nonatomic, strong) NSString *esEventID;
@property (nonatomic, strong) NSString *esFileName;
@property (nonatomic, strong) NSString *esFilePath;
@property (nonatomic, strong) NSString *esFileType;
@property (nonatomic, strong) NSString *esID;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *esIsActive;
@property (nonatomic, strong) NSString *eventRegistrationType;


+(EventSupportModel *) initWithData:(NSDictionary *)dict;

@end
