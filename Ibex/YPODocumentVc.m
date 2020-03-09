//
//  YPODocumentVc.m
//  Ibex
//
//  Created by Ahmed Durrani on 27/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPODocumentVc.h"
#import "DocumentCell.h"
#import "MOGetAllSupportingObject.h"
#import "YPODisplayDocument.h"
#import "Constant.h"
#import "EventSupportModel.h"

@interface YPODocumentVc ()
@property (weak, nonatomic) IBOutlet UITableView *documentTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleOfEvent;

@end

@implementation YPODocumentVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _listOfDocument = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrayOfFile  = [[NSMutableArray alloc] init];
    
    _titleOfEvent.text = self.supportingList.eventName ;
        for (EventSupportModel *obj in _supportingList.supportingContentList)
        {
            if ([obj.esFileType isEqualToString:@".pdf"] || [obj.esFileType isEqualToString:@".docx"] || [obj.esFileType isEqualToString:@".xlsx"])
            {
                [arrayOfFile addObject:obj];
            }
    
        }
        _listOfDocument = [arrayOfFile mutableCopy] ;
        

    
    _documentTableView.estimatedRowHeight = 50.0 ;
    _documentTableView.rowHeight = UITableViewAutomaticDimension ;
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)btnChat_Pressed:(UIButton *)sender {
    YPORecentChatVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPORecentChatVc"];
    
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btnNotification_Pressed:(UIButton *)sender {
    YPONotificationVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPONotificationVC"];
    
    [self.navigationController pushViewController:vc animated:true];
}


- (IBAction)btnSearch_Pressed:(UIButton *)sender {
    
    YPOSearchEventListVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSearchEventListVc"];
    
    [self.navigationController pushViewController:vc animated:true];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
}


#pragma mark -UITableView Method-


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if (_listOfDocument.count >0)
    {
        numOfSections                = 1;
        _documentTableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _documentTableView.bounds.size.width, _documentTableView.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        _documentTableView.backgroundView = noDataLabel;
        _documentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  self.listOfDocument.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DocumentCell *cell = (DocumentCell *)[tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
    EventSupportModel *obj = (EventSupportModel *)[self.listOfDocument objectAtIndex:indexPath.row];
    if ([obj.esFileType isEqualToString:@".pdf"]) {
        
        cell.imageOfFile.image = UIImageWithName(@"pdf") ;
        
    }
    else {
        cell.imageOfFile.image = UIImageWithName(@"doc") ;

    }
    cell.eventName.text = obj.esFileName ;
    cell.fileNAme.text = obj.esFileType ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPODisplayDocument *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPODisplayDocument"];
    EventSupportModel *obj = (EventSupportModel *)[self.listOfDocument objectAtIndex:indexPath.row];
    vc.allSupportableobj = obj ;
    [self.navigationController pushViewController:vc animated:true];
    
}




@end
