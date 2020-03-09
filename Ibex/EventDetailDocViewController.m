//
//  EventDetailDocViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 19/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "EventDetailDocViewController.h"
#import "SupportTableViewCell.h"
#import "EventObject.h"
#import "AppDelegate.h"
#import "EventSupportModel.h"
#import "Constant.h"
#import "Utility.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "EventCountResponse.h"
#import "UIImageView+AFNetworking.h"


@interface EventDetailDocViewController (){
    EventObject *masterObj;
    EventCountResponse *countObj;
    UIDocumentInteractionController *documentController;
}

@end

@implementation EventDetailDocViewController
@synthesize tvSupport,lblEventLoc,lblEventDate,lblEventTime,lblEventTitle,tvEventDesc,ivEventImage,lblTrackCount,lblSessionCount,lblSpeakerCount,lblEventType,lblEventTopic,lblRegistrationType;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appdelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    masterObj = appdelegate.eventObj;

    [self restoreData];
    [self fetchData];
}

-(void) restoreCounts{
    [lblSpeakerCount setText:countObj.speakerCount];
    [lblSessionCount setText:countObj.sessionCount];
    [lblTrackCount setText:countObj.trackCount];
}

-(void) fetchData{
    
    NSString *eventID = [NSString stringWithFormat:@"%@", masterObj.eventEventID];
    
    [[Webclient sharedWeatherHTTPClient] getEventCounts:eventID viewController:self CompletionBlock:^(NSObject *responseObject) {
        countObj = (EventCountResponse*) responseObject;
        
        if([[NSString stringWithFormat:@"%@", countObj.status] isEqualToString:@"1"]){
            [self restoreCounts];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", countObj.message] actions:@[dismissAction]];
        }
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}



-(void) restoreData{
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[masterObj.eventThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    //    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,eventObj.eventThumbImg]];
    [ivEventImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
//    [ivEventImage setContentMode:UIViewContentModeScaleAspectFit];
//    [ivEventImage setClipsToBounds:YES];
    
    [lblEventTitle setText:[NSString stringWithFormat:@"%@", masterObj.eventName]];

    
    [lblEventDate setText:[NSString stringWithFormat:@"%@ - %@", [self dateFromStringFormatter:masterObj.eventStartDate], [self dateFromStringFormatter:masterObj.eventEndDate]]];
    [lblEventTime setText:[NSString stringWithFormat:@"%@ - %@", masterObj.eventStartTime,masterObj.eventEndTime]];
    [lblEventLoc setText:[NSString stringWithFormat:@"%@", masterObj.eventVenueAddress]];
    [tvEventDesc setText:[NSString stringWithFormat:@"%@", masterObj.eventDescription]];
    
    [tvEventDesc scrollRangeToVisible:NSMakeRange(0, 1)];
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.eventRegistrationType]]){
        [lblRegistrationType setText:[NSString stringWithFormat:@"%@", masterObj.eventRegistrationType]];
    }
    else{
        [lblRegistrationType setText:@""];
    }
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", masterObj.eventTopic]]){
        [lblEventTopic setText:[NSString stringWithFormat:@"%@", masterObj.eventTopic]];
    }
    else{
        [lblEventTopic setText:@""];
    }
    
}

-(NSString*) timeFromStringFormatter:(NSString*)timeString{
    if([Utility isEmptyOrNull:timeString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    NSDate *yourDate = [dateFormatter dateFromString:timeString];
    dateFormatter.dateFormat = @"hh:mm aa";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}

-(NSString*) dateFromStringFormatter:(NSString*)dateString{
    if([Utility isEmptyOrNull:dateString]){
        return @"---";
    }
    //    NSString *myString = @"2012-11-22 10:19:04";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = @"EEEE MMM dd";
    NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
    return [dateFormatter stringFromDate:yourDate];
}



//TableViewCell 'supportTC'

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if (masterObj.supportingContentList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvSupport.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvSupport.bounds.size.width, tvSupport.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvSupport.backgroundView = noDataLabel;
        tvSupport.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return masterObj.supportingContentList.count;
}

- (void)previewDocument:(id)sender {
    
    UIButton *btn = (UIButton *) sender;
    EventSupportModel *supportObj = [masterObj.supportingContentList objectAtIndex:btn.tag];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[supportObj.esFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];
    //NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:imageURL cachePolicy: timeoutInterval:15.0];
   
    
    NSProgress *progress = nil;
    
    [[Webclient sharedWeatherHTTPClient] showProgressAlertTitle:nil message:@"Downloading..." view:self.view];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                           inDomain:NSUserDomainMask
                                                                  appropriateForURL:nil
                                                                             create:NO error:nil];
        return [documentsDirectory URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [[Webclient sharedWeatherHTTPClient] hideProgressAlert];
        [self displayDocument:filePath];
    }];
    
    
    [downloadTask resume];
}

- (void)displayDocument:(NSURL*)document {
    if(document){
        documentController = [UIDocumentInteractionController interactionControllerWithURL:document];
        documentController.delegate = self;
        [documentController presentPreviewAnimated:YES];
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Please try again." actions:@[dismissAction]];
    }
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // EventSupportModel *supportObj = [masterObj.supportingContentList objectAtIndex:indexPath.row];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"supportTC";
    
    SupportTableViewCell *cell = (SupportTableViewCell *)[tvSupport dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SupportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EventSupportModel *supportObj = [masterObj.supportingContentList objectAtIndex:indexPath.row];
    
    [cell.lblTitle setText:supportObj.esFileName];
    [cell.ivIcon setImage:[UIImage imageNamed:@"icon_document"]];
    [cell.overlayBtn addTarget:self action:@selector(previewDocument:) forControlEvents:UIControlEventTouchUpInside];
    [cell.overlayBtn setTag:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
