//
//  YPOVideoDetailVc.m
//  Ibex
//
//  Created by Ahmed Durrani on 26/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOVideoDetailVc.h"
#import "VideoCell.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MOGetAllSupportingObject.h"
#import "EventSupportModel.h"

@interface YPOVideoDetailVc () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, strong) AVPlayer *moviePlayer;
@property (strong, nonatomic) IBOutlet UITableView *tblView;


@end

@implementation YPOVideoDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listOfVideo = [[NSMutableArray alloc] init] ;
    
    NSMutableArray *arrayOfFile  = [[NSMutableArray alloc] init];
    for (EventSupportModel *obj in self.supportingList.supportingContentList)
    {
        if ([obj.esFileType isEqualToString:@".mp4"])
        {
            [arrayOfFile addObject:obj];
        }
    }
    _listOfVideo = [arrayOfFile mutableCopy] ;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Videos Media Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}
#pragma mark -UITableView Method-


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numOfSections = 0;
    if (_listOfVideo.count >0)
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
    return  self.listOfVideo.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    EventSupportModel *obj = (EventSupportModel *)[self.listOfVideo objectAtIndex:indexPath.row];
    NSString *PathOfVideo  = [NSString stringWithFormat:WEBSERVICE_DOMAIN_URL@"%@", [obj.esFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];

    NSURL *imageURL = [NSURL URLWithString:PathOfVideo];
    cell.nameOfEvent.text = self.supportingList.eventName ;
    cell.videoTitle.text = obj.esFileName ;
    
     [cell.activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: imageURL options:nil];
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        NSError *error = NULL;
        CMTime time = CMTimeMake(0.2, 65);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];

        UIImage *frameImage= [[UIImage alloc] initWithCGImage:refImg];

        dispatch_async(dispatch_get_main_queue(), ^(void){
        cell.imageOfVideo.image = frameImage ;

        [cell.activityIndicator stopAnimating];

        });
    });
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EventSupportModel *obj = (EventSupportModel *)[self.listOfVideo objectAtIndex:indexPath.row];

//    NSString *imagePath = [self.listOfVideo objectAtIndex:indexPath.row] ;
    
    NSString *pathOfVideo  = [NSString stringWithFormat:WEBSERVICE_DOMAIN_URL@"%@", [obj.esFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];

    NSURL *imageURL = [NSURL URLWithString:pathOfVideo];
    AVPlayer *player = [AVPlayer playerWithURL: imageURL];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    controller.player = player;
    [player play];

    // create a player view controller
    

    
    
}

//-(void)playVideo(NSString *)url
//{
//    self.moviePlayer =
//    
//}

//func playVideo(_ urlString:String) -> Void{
//    let videoURL = URL(string: urlString)
//    let player = AVPlayer(url: videoURL!)
//    let playerViewController = AVPlayerViewController()
//    playerViewController.player = player
//    
//    self.present(playerViewController, animated: true) {
//        
//        playerViewController.player!.play()
//    }
//    //        moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
//}


@end
