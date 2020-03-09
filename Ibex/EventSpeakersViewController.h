//
//  EventSpeakersViewController.h
//  Ibex
//
//  Created by Sajid Saeed on 29/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendedViewController.h"
#import "EventSpeakerResponse.h"

@interface EventSpeakersViewController : ExtendedViewController<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) IBOutlet UITableView *tvEventSpeaker;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topAlignmentConstraint;

@property (nonatomic, strong) UISearchController *searchController;

//for the results to be shown with two table delegates
@property (nonatomic, strong) UITableViewController *searchResultsController;

@property(nonatomic , strong) EventSpeakerResponse *masterObj;


@end
