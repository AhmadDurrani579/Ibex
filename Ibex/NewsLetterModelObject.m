//
//  NewsLetterModelObject.m
//  YPO
//
//  Created by Ahmed Durrani on 03/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "NewsLetterModelObject.h"

@implementation NewsLetterModelObject

+(NewsLetterModelObject*)initWithData:(NSDictionary *)dict{
    
    NewsLetterModelObject *obj = [[NewsLetterModelObject alloc] init];
    
    obj.newsletterID = [dict objectForKey:@"id"];
    obj.newsletterFileName = [dict objectForKey:@"fileName"];
    obj.newsletterFilePath = [dict objectForKey:@"filePath"];
    obj.newsletterFileType = [dict objectForKey:@"fileType"];
    obj.newsletterIsActive = [dict objectForKey:@"isActive"];
    obj.newsletterTitle = [dict objectForKey:@"title"];
    obj.newsletterUploadedDate = [dict objectForKey:@"uploadedDate"];
    obj.eventName = [[dict valueForKey:@"event"] valueForKey:@"name"];
    
    

    return obj;
    
}
@end
