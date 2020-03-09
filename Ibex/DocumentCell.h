//
//  DocumentCell.h
//  Ibex
//
//  Created by Ahmed Durrani on 27/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNAme;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIImageView *imageOfFile;


@end
