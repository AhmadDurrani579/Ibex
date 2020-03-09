//
//  MOMessage.h
//  YPO
//
//  Created by Ahmed Durrani on 11/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MOMessage : NSObject
@property(nonatomic , strong) NSString *text ;
@property(nonatomic , strong) NSDate *date ;
@property (nonatomic , strong) NSString *messageFromMe;
@property(nonatomic , strong) NSString *type ;
@property (strong, nonatomic) UIImage *thumbnail;


@end
