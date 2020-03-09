//
//  AgendaSessionModel.h
//  Ibex
//
//  Created by Sajid Saeed on 06/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgendaSessionModel : NSObject

@property (nonatomic, strong) NSString *agendaTitle;
@property (nonatomic, strong) NSString *agendaDesc;
@property (nonatomic, strong) NSString *agendaLoc;
@property (nonatomic, strong) NSString *agendaEventID;
@property (nonatomic, strong) NSString *agendaDate;
@property (nonatomic, strong) NSString *agendaTimeFrom;
@property (nonatomic, strong) NSString *agendaTimeTo;
@property (nonatomic, strong) NSString *agendaID;
@property (nonatomic, strong) NSString *agendaEventTrack;

@property (nonatomic, strong) NSArray *agendaEventSpeakerList;

+(AgendaSessionModel *) initWithData:(NSDictionary *)dict;



@end
