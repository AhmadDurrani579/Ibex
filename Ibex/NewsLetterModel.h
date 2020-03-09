//
//  NewsLetterModel.h
//  YPO
//
//  Created by Ahmed Durrani on 03/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsLetterModel : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSArray *arrayOfNewsLetter;

+(NewsLetterModel*) initWithData:(NSDictionary *)dict;

@end
