//
//  EventTableViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 30/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewController : UIViewController{
    UIRefreshControl *refreshControl;
}
@property (strong, nonatomic) IBOutlet UITableView *tvEvents;

@end
