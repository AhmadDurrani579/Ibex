//
//  YPONewsViewController.m
//  YPO
//
//  Created by Ahmed Durrani on 03/11/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPONewsViewController.h"
#import "NewsLetterModel.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "NewsLetterModel.h"
#import "DocumentCell.h"
#import "NewsLetterModelObject.h"
#import "YPODisplayDocument.h"
@interface YPONewsViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    NewsLetterModel *masterObj ;

}
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UILabel *titleOfNewsLetter;

@end

@implementation YPONewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleOfNewsLetter.text = _selectDoc ;
    
    [self getNewsLetter];
    
    // Do any additional setup after loading the view.
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Newsletters Media Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNewsLetter
{
    
    NSString *serviceType = [[NSString alloc] init];
    
        serviceType = @"api/Event/getAllSupportingContentByPage/1/1000";

    [[Webclient sharedWeatherHTTPClient] getNewsLetter:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        masterObj = (NewsLetterModel *) responseObject;
        //
        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
            _tblView.delegate = self ;
            _tblView.dataSource = self ;
            [_tblView reloadData];
            
        }
        
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = 0;
    if (masterObj.arrayOfNewsLetter.count >0)
    {
        numOfSections                = 1;
        _tblView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tblView.bounds.size.width, _tblView.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        _tblView.backgroundView = noDataLabel;
        _tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return  masterObj.arrayOfNewsLetter.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DocumentCell *cell = (DocumentCell *)[tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
    NewsLetterModelObject *obj = (NewsLetterModelObject *)[masterObj.arrayOfNewsLetter objectAtIndex:indexPath.row];
    if ([obj.newsletterFileType isEqualToString:@".pdf"]) {
        
        cell.imageOfFile.image = UIImageWithName(@"pdf") ;
        
    }
    else {
        cell.imageOfFile.image = UIImageWithName(@"doc") ;
        
    }
    
    if (_vcPushType == 1) {
        cell.eventName.text = obj.eventName ;

    } else {
        cell.eventName.text = obj.newsletterTitle ;

    }

    cell.fileNAme.text = obj.newsletterFileName ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPODisplayDocument *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPODisplayDocument"];
    NewsLetterModelObject *obj = (NewsLetterModelObject *)[masterObj.arrayOfNewsLetter objectAtIndex:indexPath.row];
    vc.detailOfNewsLetter = obj ;
    [self.navigationController pushViewController:vc animated:true];
    
}



//http://202.125.144.232:8050/api/NewsLetter/getByPage/0/100000

@end
