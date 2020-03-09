//
//  YPOSearchUserListVc.m
//  YPO
//
//  Created by Ahmed Durrani on 24/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSearchUserListVc.h"
#import "YPOSearchUserCell.h"
#import "EventObject.h"
#import "MOGoldMemberObject.h"
#import "Constant.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "AppDelegate.h"

@interface YPOSearchUserListVc () <UITableViewDataSource , UITableViewDelegate>
{
    AppDelegate *app ;
    
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UISearchBar     *searchContacts;

}
@end

@implementation YPOSearchUserListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;

    searchContacts.placeholder = @"Search the User" ;

//    [tblView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numOfSections = 0;
    if (app.userList.searchUserList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tblView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tblView.bounds.size.width, tblView.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tblView.backgroundView = noDataLabel;
        tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  app.userList.searchUserList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YPOSearchUserCell *cell = (YPOSearchUserCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOSearchUserCell" forIndexPath:indexPath];
        
    return  cell ;
    
    
}


@end
