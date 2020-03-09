//
//  AgendaResponse.h
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgendaResponse : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSArray *agendaList;

+(AgendaResponse *) initWithData:(NSDictionary *)dict;

@end
