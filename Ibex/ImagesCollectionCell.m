//
//  ImagesCollectionCell.m
//  Ibex
//
//  Created by Ahmed Durrani on 27/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "ImagesCollectionCell.h"

@implementation ImagesCollectionCell


- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageOfCollection.image =  nil;
    _eventName.text  = @"" ;
}

@end
