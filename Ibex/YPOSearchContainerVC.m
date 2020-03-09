//
//  YPOSearchContainerVC.m
//  YPO
//
//  Created by Ahmed Durrani on 24/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOSearchContainerVC.h"
#import "YPOSearchEventListVc.h"
#import "YPOSearchUserListVc.h"
#import "YPOSearchEventList.h"
#import "AppDelegate.h"
@interface YPOSearchContainerVC ()<UIPageViewControllerDelegate , UIPageViewControllerDataSource >
{
    __weak IBOutlet UIView *containerView;
    __strong UIPageViewController *pageController;
    NSArray *myViewControllers;
    AppDelegate *app ;
    //    var homeNav: UINavigationController?
    //    var favouriteNav: UINavigationController?
    //    var accountNav: UINavigationController?
    
    __weak IBOutlet UIView *viewOfEventMember;
    __weak IBOutlet UIView *viewOfUser ;
    __weak IBOutlet UIButton *btnOfEventMember;
    __weak IBOutlet UIButton *btnOfUser;
    
    UINavigationController *eventNav ;
    UINavigationController *userNav ;
    
    YPOSearchEventList *tempmasterObj;



}

@end

@implementation YPOSearchContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnOfEventMember setSelected:true];
    
    [self initializations];
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;

    // Do any additional setup after loading the view.
}

- (void)initializations
{
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                   options:nil];
    myViewControllers = @[self.eventVc, self.userVc];
    
    [pageController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    pageController.dataSource = self;
    pageController.delegate = self;
    
    
    [pageController setViewControllers:@[self.eventVc]
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:YES
                            completion:nil];
    [containerView addSubview:pageController.view];
    [containerView layoutIfNeeded];
    
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:pageController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1. constant:0.]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:pageController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1. constant:0.]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:pageController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeLeft multiplier:1. constant:0.]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:pageController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeRight multiplier:1. constant:0.]];
    [pageController.view layoutIfNeeded];
    
    for (UIGestureRecognizer *recognizer in pageController.gestureRecognizers)
    {
        recognizer.enabled = NO;
    }
    
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    //    [btnGoldMember setTitleColor:[UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    [btnOfYpoMember setTitleColor:[UIColor colorWithRed:162/255.0 green:169/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    [viewOfUser setHidden:true];
    [viewOfEventMember setHidden:false];
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UINavigationController *) eventVc
{
    
    YPOSearchEventListVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSearchEventListVc"];
    
    eventNav = [[UINavigationController alloc]initWithRootViewController:vc];
    [eventNav setNavigationBarHidden:true];
    return  eventNav ;
}


- (UINavigationController *) userVc
{
    YPOSearchUserListVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSearchUserListVc"];
    
//    vc.userList = tempmasterObj ;
    
    userNav = [[UINavigationController alloc]initWithRootViewController:vc];
    [userNav setNavigationBarHidden:true];
    return  userNav ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserList :(YPOSearchEventList *)user  {
    
    tempmasterObj = user ;
    
}
-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return myViewControllers[index];
}

- (IBAction)btnEvent_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    NSInteger index = 0;
    [btnOfEventMember setSelected:true];
    [btnOfUser setSelected:false];
    
    
    
    [viewOfUser setHidden:true];
    [viewOfEventMember setHidden:false];
    [pageController setViewControllers:@[ [self viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
     {
         
     }];
    
}

- (IBAction)btnUserBtn_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    YPOSearchUserListVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOSearchUserListVc"];
    app.userList = tempmasterObj ;
    
//    vc.userList = tempmasterObj ;

    [btnOfUser setSelected:true];
    [btnOfEventMember setSelected:false];
    
    NSInteger index = 1;
    [viewOfEventMember setHidden:true];
    [viewOfUser setHidden:false];
    
    [pageController setViewControllers:@[ [self viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
     {
         
     }];
    
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}


@end
