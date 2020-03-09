//
//  YPOEventListVC.m
//  YPO
//
//  Created by Ahmed Durrani on 24/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOEventListVC.h"
#import "YPOEventCell.h"
#import "EventObject.h"
#import "YPOMediaDetailVc.h"
#import "YPOVideoDetailVc.h"
#import "YPODocumentVc.h"
#import "Utility.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "YPORecentChatVc.h"
#import "YPONotificationVC.h"
#import "YPOSearchEventListVc.h"
#import "EventSupportModel.h"
#import "YPONewsViewController.h"
@interface YPOEventListVC ()<UITableViewDelegate , UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblTitileOfSelectedOption;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property(strong , nonatomic) NSMutableArray *eventList ;
@end

@implementation YPOEventListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _eventList = [[NSMutableArray alloc] init];
    
    
    if (_pushType == 1) {
        
    
    for (EventObject *obj in _event.eventList) {
        for (EventSupportModel *support in obj.supportingContentList){
             if ([support.esFileType isEqualToString: @".jpeg"] || [support.esFileType isEqualToString:@".png"] ||[support.esFileType isEqualToString:@".PNG"] ){
                 if ([_eventList containsObject:obj])
                 {
                     NSLog(@"Already Containt");
                 }
                 else {
                     [_eventList addObject:obj];
                 }

             }
         }
        
    }
    } else if (_pushType == 2){
        for (EventObject *obj in _event.eventList) {
            for (EventSupportModel *support in obj.supportingContentList){
                if ([support.esFileType isEqualToString: @".mp4"]) {
                    if ([_eventList containsObject:obj])
                    {
                        NSLog(@"Already Containt");
                    }
                    else {
                        [_eventList addObject:obj];
                    }
                    
                }
            }
            
        }
    
    }
    _tblView.dataSource = self ;
    _tblView.delegate = self ;
    [_tblView reloadData];
    
    
//    for (EventObject *obj in _event.eventList) {
//        for (EventSupportModel *support in obj.supportingContentList) {
//
//            for(NSDictionary *masterObj in tempArr){
//
//                if  ([[masterObj objectForKey:@"eventSupportingContents"] isKindOfClass:[NSArray class]]) {
//                    NSArray *tempList = [masterObj objectForKey:@"eventSupportingContents"];
//                    NSLog(@"print it %@", tempList) ;
//                    NSMutableArray *imageContentList = [[NSMutableArray alloc] init];
//
//                    for(NSDictionary *objDict in tempList){
//                        NSString *typeOFFile = [objDict valueForKey:@"fileType"];;
//                        if ([typeOFFile isEqualToString: @".jpeg"] || [typeOFFile isEqualToString:@".png"]){
//                            [imageContentList addObject:[EventSupportModel initWithData:objDict]] ;
//                        }
//                        //
//                    }
//
//
//                }
//                [temptList addObject:[EventObject initWithData:masterObj]];
//            }
//
//
//
//        }
//
//    }
    
    
    
    
    
    if([Utility connectedToNetwork]){
        _lblTitileOfSelectedOption.text = _titleOfView ;
      } else {
        [self showAlertViewWithTitle:@"Error" message:@"Internet Connection Error."];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Media Categories Listing Screen"];
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

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numOfSections = 0;
    if (self.eventList.count >0)
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
    return  _eventList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    YPOEventCell *cell = (YPOEventCell *)[tableView dequeueReusableCellWithIdentifier:@"YPOEventCell" forIndexPath:indexPath];
    EventObject *obj = (EventObject *)[_eventList objectAtIndex:indexPath.row];
    
    cell.lbleventName.text = obj.eventName ;
    NSURL *imageURL ;
    id  thumbnailImage = obj.eventThumbImg ;
    
    if (thumbnailImage != [NSNull null]) {
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        imageURL = [NSURL URLWithString:imageURLString];
        
    }else {

        
    }
    
    [cell.imageOfEvent setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
//    [cell.imageOfEvent setContentMode:UIViewContentModeScaleAspectFit];

    
    return  cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YPOMediaDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMediaDetailVc"];
    YPOVideoDetailVc *videoVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOVideoDetailVc"];
    YPODocumentVc *doc  = [self.storyboard instantiateViewControllerWithIdentifier:@"YPODocumentVc"];

    if (_pushType == 1){
        EventObject *obj = (EventObject *)[_eventList objectAtIndex:indexPath.row];
        
        vc.supportingList = obj ;
        [self.navigationController pushViewController:vc animated:true];

    } else if (_pushType == 2) {
        EventObject *obj = (EventObject *)[_eventList objectAtIndex:indexPath.row];
        
        videoVc.supportingList = obj ;
        [self.navigationController pushViewController:videoVc animated:true];

    } else if (_pushType == 3) {
        EventObject *obj = (EventObject *)[_eventList objectAtIndex:indexPath.row];
        doc.supportingList = obj ;
        [self.navigationController pushViewController:doc animated:true];
        
    }
    else if (_pushType == 4) {
        
        YPONewsViewController *vc = (YPONewsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"YPONewsViewController"];
        vc.vcPushType  = 1 ;
        
        [self.navigationController pushViewController:vc animated:true];

//        EventObject *obj = (EventObject *)[self.event.eventList objectAtIndex:indexPath.row];
//        doc.supportingList = obj ;
//        [self.navigationController pushViewController:doc animated:true];
        
    }

//
//    YPOMediaDetailVc
    
    

}


@end
