//
//  MOGetAllSupportingObject.h
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOGetAllSupportingObject : NSObject

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileType;
@property (nonatomic, strong) NSString *idOfFile;
@property (nonatomic, strong) NSString *isActive;
@property (nonatomic, strong) NSString *eventName;

@property (nonatomic, strong) NSMutableArray *imagesList;
@property (nonatomic, strong) NSMutableArray *pdfFileList;

+(MOGetAllSupportingObject*) initWithData:(NSDictionary*)dict;

@end
