//
//  MOGroup.m
//  YPOPakistan
//
//  Created by Ahmed Durrani on 28/12/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MOGroup.h"
#import <objc/runtime.h>

@implementation MOGroup


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
        
        if (![[dict objectForKey:@"chatRooms"] isKindOfClass:[NSNull class]]) {
            
            
            if ([[dict objectForKey:@"chatRoom"] isKindOfClass:[NSDictionary class]]) {
                self.ownerOfGroup = [[NSArray alloc] initWithObjects:[dict objectForKey:@"chatRoom"], nil];
            }
            else if ([[dict objectForKey:@"chatRoom"] isKindOfClass:[NSArray class]]) {
                self.ownerOfGroup = [[NSArray alloc] initWithArray:[dict objectForKey:@"chatRoom"]];
            }

            
//            if ([[[dict objectForKey:@"members"] objectForKey:@"member"] isKindOfClass:[NSString class]]) {
//
//
//
//                self.groupMember = [[NSArray alloc] initWithObjects:[[dict objectForKey:@"members"]objectForKey:@"member"], nil];
//            }
//            else{
//
////                NSMutableArray *searchArray = [[NSMutableArray alloc] init];
////                for (NSDictionary *dictionary in [dict objectForKey:@"chatRoom"])
////                {
////                    NSArray *member = [dictionary objectForKey:@"members"];
////                    NSString *array = [dictionary objectForKey:@"fullName"];
////                    [self.ownerOfGroupOfMember addObject:array];
////
////                }
//
//
//                NSArray *array =  [NSArray arrayWithObject:[dict objectForKey:@"chatRoom"]];
////                NSMutableArray *arrayOfUser = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"chatRoom"], nil];
////                NSArray *arr = [arrayOfUser objectAtIndex:0] ;
//                if (array.count == 1) {
//                    self.ownerOfGroup = [[NSArray alloc] initWithObjects:[dict objectForKey:@"chatRoom"], nil] ;
//
//                } else {
//                    self.ownerOfGroup = [[NSArray alloc] initWithArray:[dict objectForKey:@"chatRoom"]];
//
//                }
//                if (arr.count == 1) {
//
//                    self.ownerOfGroup = [[NSArray alloc] initWithObjects:[dict objectForKey:@"chatRoom"], nil] ;
//                } else {
//                    self.ownerOfGroup = [[NSArray alloc] initWithArray:[dict objectForKey:@"chatRoom"]];
//
//                }
                
                
//                self.groupMember = [[NSArray alloc] initWithArray:[[dict objectForKey:@"chatRoom"]objectForKey:@"members"]];
            }
            
            
            NSLog(@"%@",self.groupMember);
            
        }
        
    
    
    
    
    return self;
    
    
}
@end
