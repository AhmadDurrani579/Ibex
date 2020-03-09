//
//  NewsLetterModelObject.h
//  YPO
//
//  Created by Ahmed Durrani on 03/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsLetterModelObject : NSObject
@property (nonatomic, strong) NSString *newsletterID;
@property (nonatomic, strong) NSString *newsletterFileName;
@property (nonatomic, strong) NSString *newsletterFilePath;
@property (nonatomic, strong) NSString *newsletterFileType;
@property (nonatomic, strong) NSString *newsletterIsActive;
@property (nonatomic, strong) NSString *newsletterTitle;
@property (nonatomic, strong) NSString *newsletterUploadedDate;
@property (nonatomic, strong) NSString *eventName;




+(NewsLetterModelObject *) initWithData:(NSDictionary *)dict;


@end
