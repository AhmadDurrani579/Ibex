//
//  YPOSplashForWhileVc.m
//  Ibex
//
//  Created by Ahmed Durrani on 29/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSplashForWhileVc.h"
#import "YPOMySchedule.h"
#import "AppDelegate.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "EventSelectionViewController.h"
@interface YPOSplashForWhileVc ()
{

}
@property (strong, nonatomic) IBOutlet FLAnimatedImageView *imageForAnimated;
@end

@implementation YPOSplashForWhileVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    double delayInSeconds = 4.0;
    
//    if (!self.imageForAnimated) {
//        self.imageForAnimated = [[FLAnimatedImageView alloc] init];
//    }
//    self.imageForAnimated.contentMode = UIViewContentModeScaleAspectFill;
//    self.imageForAnimated.clipsToBounds = YES;

//    [self.view addSubview:self.imageForAnimated];
//    self.imageForAnimated.frame = CGRectMake(0.0, 120.0, self.view.bounds.size.width, 447.0);
    
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"rock" withExtension:@"gif"];
//    NSURL *urls = [[NSBundle mainBundle] URLForResource:@"rock" withExtension:@"gif"];

    NSData *data1 = [NSData dataWithContentsOfURL:url1];

    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.imageForAnimated.animatedImage = animatedImage1;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self goToVcSchedule];
        });
    

//    [imageViewProfile sd_animatedGIFNamed:@""];
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Calendar Splash Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToVcSchedule {
    EventSelectionViewController *faqVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventSelectionViewController"];
    [self.navigationController pushViewController:faqVC animated:true] ;
    
//        [self.navigationController pushViewController:vc animated:true];

}


@end
