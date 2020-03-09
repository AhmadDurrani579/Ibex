//
//  MOMessage.m
//  YPO
//
//  Created by Ahmed Durrani on 11/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "MOMessage.h"

@implementation MOMessage
@synthesize messageFromMe , text ,date ,type, thumbnail ;

- (id)init
{
    if (self = [super init]) {
        self.date = [NSDate date];
    }
    
    return self;
}

@end
