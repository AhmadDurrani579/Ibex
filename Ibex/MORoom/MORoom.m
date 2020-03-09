//
//  MORoom.m
//  Boai
//
//  Created by Afzal Sheikh on 11/1/16.
//  Copyright © 2016 Lead Concept. All rights reserved.
//

#import "MORoom.h"
#import <objc/runtime.h>

@implementation MORoom

@synthesize roomName = _roomName;
@synthesize subject = _subject;


-(id)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    unsigned int numberOfProperties = 0;
    
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *key = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        id child = [dict valueForKey:key];
        
        if (child){
            [self setValue:child forKey:key];
        }
        else{
            if (![dict objectForKey:@"id"]){
                
                [self setValue:nil forKey:key];
            }
            if (![dict objectForKey:@"members"]){
                
                [self setValue:nil forKey:key];
            }
            
            
            
        }
        
        if (![[dict objectForKey:@"members"] isKindOfClass:[NSNull class]]) {
            
            
            if ([[[dict objectForKey:@"members"] objectForKey:@"member"] isKindOfClass:[NSString class]]) {
                
                
                self.roomMembers = [[NSArray alloc] initWithObjects:[[dict objectForKey:@"members"]objectForKey:@"member"], nil];
            }
            else{
              self.roomMembers = [[NSArray alloc] initWithArray:[[dict objectForKey:@"members"]objectForKey:@"member"]];
            }
            
            
            NSLog(@"%@",self.roomMembers);
            
        }

    }
    
   
    
    return self;
    
    
}


@end
