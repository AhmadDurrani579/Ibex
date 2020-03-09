//
//  MOGroup.h
//  YPOPakistan
//
//  Created by Ahmed Durrani on 28/12/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOGroup : NSObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *groupJabberId;
@property (nonatomic, strong) NSString *groupSubject;
@property (nonatomic, strong) NSString *subject;

@property (nonatomic,strong) NSArray *groupMember;
@property (nonatomic,strong) NSArray *ownerOfGroup;
@property (nonatomic,strong) NSMutableArray *ownerOfGroupOfMember;

-(id)initWithDictionary:(NSDictionary *)dict;


@end
