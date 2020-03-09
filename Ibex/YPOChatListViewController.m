//
//  YPOChatListViewController.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOChatListViewController.h"
#import "YPOChatListCell.h"

@interface YPOChatListViewController () <UITableViewDelegate , UITableViewDataSource>
{
    __weak IBOutlet UITableView *tblView;

}

@end

@implementation YPOChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableView Method-


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  5 ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOChatListCell *cell = (YPOChatListCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOChatListCell"];
    
    return cell ;
    
}


@end
