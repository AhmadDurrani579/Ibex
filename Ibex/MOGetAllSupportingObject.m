//
//  MOGetAllSupportingObject.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MOGetAllSupportingObject.h"

@implementation MOGetAllSupportingObject

+(MOGetAllSupportingObject*)initWithData:(NSDictionary *)dict{
    MOGetAllSupportingObject *obj = [[MOGetAllSupportingObject alloc] init];
    
    obj.eventId = [dict objectForKey:@"id"];
    obj.fileName = [dict objectForKey:@"fileName"];
    obj.filePath = [dict objectForKey:@"filePath"];
    obj.fileType = [dict objectForKey:@"fileType"];
    obj.idOfFile = [dict objectForKey:@"idOfFile"];
    obj.isActive = [dict objectForKey:@"isActive"];
    
    if ([obj.fileType isEqualToString:@".pdf"])
    {
        [obj.pdfFileList addObject: [dict objectForKey:@"filePath"]];
        
    }
    else if ([obj.fileType isEqualToString:@".jpg"])
    {
        [obj.imagesList addObject: [dict objectForKey:@"filePath"]];

    }
    
    if([[dict objectForKey:@"event"] isKindOfClass:[NSDictionary class]]){
        obj.eventName = [NSString stringWithFormat:@"%@", [[dict objectForKey:@"event"] objectForKey:@"name"]];
    }

    
    return obj;
    
}


@end
