//
//  MORoom.h
//  Boai
//
//  Created by Afzal Sheikh on 11/1/16.
//  Copyright © 2016 Lead Concept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MORoom : NSObject
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString *roomJID;
@property (nonatomic, strong) NSString *roomColor;
@property (nonatomic, strong) NSString *roomDescription;
@property (nonatomic, strong) NSString *subject;

@property (nonatomic,strong) NSArray *roomMembers;
-(id)initWithDictionary:(NSDictionary *)dict;

@end
