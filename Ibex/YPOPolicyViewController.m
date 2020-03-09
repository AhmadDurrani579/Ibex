//
//  YPOPolicyViewController.m
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOPolicyViewController.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "MOPolicy.h"
#import "MOPolicyObject.h"
#import "NewsLetterModel.h"
#import "DocumentCell.h"
#import "NewsLetterModelObject.h"
#import "YPODisplayDocument.h"

@interface YPOPolicyViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    MOPolicy *masterObj ;
    IBOutlet UIButton *btnChat;
    NewsLetterModel *masterObjss ;

    IBOutlet UIButton *btnBack;
    
    
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITableView *tblView;



@end

@implementation YPOPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewsLetter];
    
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];

    // Do any additional setup after loading the view.
}
- (void)notifiationRemoved:(NSNotification*)notif
{
    btnChat.badgeValue = @"" ;
}
- (void)notifiationReceiveced:(NSNotification*)notif
{
    NSString *myString ;
    int myInt = [btnChat.badgeValue intValue];// I assume you need it as an integer.
    myString= [NSString stringWithFormat:@"%d",++myInt];
    btnChat.badgeValue = myString ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"YPO Policy Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
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

-(void)getNewsLetter
{
    
    NSString *serviceType = [[NSString alloc] init];
    
    
    serviceType = @"api/privacypolicy/get";
    [[Webclient sharedWeatherHTTPClient] getPrivacyPolicy:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        masterObjss = (NewsLetterModel *) responseObject;
        //
        if([[NSString stringWithFormat:@"%@", masterObjss.status] isEqualToString:@"1"]){
            _tblView.delegate   = self ;
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
    if (masterObjss.arrayOfNewsLetter.count >0)
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
    return  masterObjss.arrayOfNewsLetter.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DocumentCell *cell = (DocumentCell *)[tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
    NewsLetterModelObject *obj = (NewsLetterModelObject *)[masterObjss.arrayOfNewsLetter objectAtIndex:indexPath.row];
    if ([obj.newsletterFileType isEqualToString:@".pdf"]) {
        
        cell.imageOfFile.image = UIImageWithName(@"pdf") ;
        
    }
    else {
        cell.imageOfFile.image = UIImageWithName(@"doc") ;
        
    }
    cell.eventName.text = obj.newsletterFileName ;
    cell.fileNAme.text  = obj.newsletterTitle ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPODisplayDocument *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPODisplayDocument"];
    NewsLetterModelObject *obj = (NewsLetterModelObject *)[masterObjss.arrayOfNewsLetter objectAtIndex:indexPath.row];
    vc.detailOfNewsLetter = obj ;
    [self.navigationController pushViewController:vc animated:true];
    
}



- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

@end
