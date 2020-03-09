//
//  YPOMediaPublication.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOMediaPublication.h"
#import "MOGetAllSupporting.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "YPOMediaDetailVc.h"
#import "MOGetAllSupportingObject.h"
#import "AppDelegate.h"
#import "YPOVideoDetailVc.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "YPODocumentVc.h"
#import "EventListResponse.h"
#import "YPOEventListVC.h"
#import "YPORecentChatVc.h"
#import "YPONotificationVC.h"
#import "YPOSearchEventListVc.h"
#import "YPONewsViewController.h"
#import "YPOSupportNewVc.h"
@interface YPOMediaPublication ()
{
    EventListResponse *tempmasterObj;
    IBOutlet UIButton *btnChat;

}
@property (weak, nonatomic) IBOutlet UIView *viewOfImages;
@property (weak, nonatomic) IBOutlet UIView *viewOfVideos;
@property (weak, nonatomic) IBOutlet UIView *viewOFDocuments;
@property (weak, nonatomic) IBOutlet UIView *viewOfNewsLetter;

@end

@implementation YPOMediaPublication

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShadow:_viewOfImages];
    [self setShadow:_viewOfVideos];
    [self setShadow:_viewOFDocuments];
    [self setShadow:_viewOfNewsLetter];
    [self getAllSupportingFile];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.viewOfImages addGestureRecognizer:singleFingerTap];

    
    UITapGestureRecognizer *tapOnDocuments =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDocumentTap:)];
    
    [self.viewOfNewsLetter addGestureRecognizer:tapOnDocuments];
    
    UITapGestureRecognizer *tapOnVideos =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleVideoTap:)];
    
    [self.viewOfVideos addGestureRecognizer:tapOnVideos];
    
    [NotifCentre addObserver:self selector:@selector(notifiationReceiveced:)  name:kChatNotificationReceived object:nil];
    [NotifCentre addObserver:self selector:@selector(notifiationRemoved:)  name:kChatNotificationRemoved object:nil];

    
    
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Media Categories Listing Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}


- (IBAction)btnEventName_Pressed:(UIButton *)sender {
    
    YPOEventListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOEventListVC"];
    vc.pushType = 1 ;
    vc.titleOfView = @"IMAGES" ;
    vc.event = tempmasterObj ;
    [self.navigationController pushViewController:vc animated:true];

}

- (IBAction)btnViedeos_Pressed:(UIButton *)sender {
    
    YPOEventListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOEventListVC"];
    vc.event = tempmasterObj ;
    vc.titleOfView = @"VIDEOS" ;
    vc.pushType = 2 ;
    [self.navigationController pushViewController:vc animated:true];

}
- (IBAction)btnDocuments_Pressed:(UIButton *)sender {
    YPONewsViewController *vc = (YPONewsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"YPONewsViewController"];
    vc.selectDoc = @"DOCUMENTS";
    vc.vcPushType  = 1 ;
    
    [self.navigationController pushViewController:vc animated:true];

    
    
//    YPOEventListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOEventListVC"];
//    vc.event = tempmasterObj ;
//    vc.titleOfView = @"DOCUMENTS" ;
//    vc.pushType = 3 ;
//    [self.navigationController pushViewController:vc animated:true];

}
- (IBAction)btnNewsLetter_Pressed:(UIButton *)sender {
    YPOSupportNewVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSupportNewVc"];
//    vc.event = tempmasterObj ;
//    vc.titleOfView = @"NEWS LETTER" ;
//    vc.pushType = 4 ;
//    vc.selectDoc = @"NEWS LETTER";

//    vc.event = tempmasterObj ;
    [self.navigationController pushViewController:vc animated:true];

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


//The event handling method
- (void)handleVideoTap:(UITapGestureRecognizer *)recognizer
{
    
    
    
//    NSMutableArray *arrayOfFile  = [[NSMutableArray alloc] init];
//    
//    
//    for (MOGetAllSupportingObject *obj in tempmasterObj.eventList)
//    {
//        if ([obj.fileType isEqualToString:@".mp4"])
//        {
//            [arrayOfFile addObject:obj];
//
//        }
//        
//    }
//    vc.listOfVideo = [arrayOfFile mutableCopy] ;
    
    
    //    arrayOfFile
    
    
}


//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{


    YPOMediaDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMediaDetailVc"];
    
//    vc.valueChange = 0 ;
//
//    NSMutableArray *arrayOfFile  = [[NSMutableArray alloc] init];
//    
//    
//     for (MOGetAllSupportingObject *obj in tempmasterObj.eventList)
//     {
//         if ([obj.fileType isEqualToString:@".jpg"] || [obj.fileType isEqualToString:@".png"])
//         {
//             [arrayOfFile addObject:obj];
//         }
//     }
//    vc.images = [arrayOfFile mutableCopy] ;
    
    
//    arrayOfFile
    [self.navigationController pushViewController:vc animated:true];

    
}


//The event handling method
- (void)handleDocumentTap:(UITapGestureRecognizer *)recognizer
{
    
    
    YPODocumentVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPODocumentVc"];
    
    //    arrayOfFile
    [self.navigationController pushViewController:vc animated:true];
    
    
}




-(void)setShadow:(UIView *)view
{
    view.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
    [view.layer setCornerRadius:5.0f];
    [view.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [view.layer setBorderWidth:0.5f];
    [view.layer setShadowColor:[UIColor colorWithRed:225.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0].CGColor];
    [view.layer setShadowOpacity:1.0];
    [view.layer setShadowRadius:5.0];
    [view.layer setShadowOffset:CGSizeMake(5.0f, 5.0f)];
 
}

-(void)getAllSupportingFile
{
    NSString *serviceType = [[NSString alloc] init];
    serviceType = @"api/Event/getAllByPage/-1/1/10000";

    [[Webclient sharedWeatherHTTPClient] getAllSupportingFile:serviceType viewController:self CompletionBlock:^(NSObject *responseObject) {
        tempmasterObj = (EventListResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", tempmasterObj.status] isEqualToString:@"1"]){
            //[tvEvents reloadData];
            
        }
        
        
    } FailureBlock:^(NSError *error) {
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                            }];
        [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:@"Internet Connection Error." actions:@[dismissAction]];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
