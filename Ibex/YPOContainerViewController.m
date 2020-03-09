//
//  YPOContainerViewController.m
//  Ibex
//
//  Created by Ahmed Durrani on 21/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOContainerViewController.h"
#import "YPOGoldMember.h"
#import "YPOMemberViewControoler.h"

@interface YPOContainerViewController ()<UIPageViewControllerDelegate , UIPageViewControllerDataSource>
{
    __weak IBOutlet UIView *containerView;
    __strong UIPageViewController *pageController;
    NSArray *myViewControllers;
//    var homeNav: UINavigationController?
//    var favouriteNav: UINavigationController?
//    var accountNav: UINavigationController?

    __weak IBOutlet UIView *viewOfGoldMember;
    __weak IBOutlet UIView *viewOfYPOMember;
    __weak IBOutlet UIButton *btnGoldMember;
    __weak IBOutlet UIButton *btnOfYpoMember;
    
    UINavigationController *ypoMemberNav ;
    UINavigationController *goldMemberNav ;

    __weak IBOutlet UIView *viewOfMember;
    __weak IBOutlet UIView *viewOfNavigation;
    __weak IBOutlet NSLayoutConstraint *topLapOutOfView;

}
@end

@implementation YPOContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [btnGoldMember setSelected:true];
    
    [self initializations];
    //SetupView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initializations
{
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                   options:nil];
    myViewControllers = @[self.goldMember, self.YPOMember];

    [pageController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    pageController.dataSource = self;
    pageController.delegate = self;
    
    
    [pageController setViewControllers:@[self.goldMember]
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
    [viewOfYPOMember setHidden:true];
    [viewOfGoldMember setHidden:false];
    [self addObserverForHideView];
    [self addAbbsorberForShowView];
    

}

-(void)addObserverForHideView {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBottomBar:)
                                                 name:@"hideBottomView"
                                               object:nil];
    
}

- (void)hideBottomBar:(NSNotification *) notification
{
    [viewOfMember setHidden:true];
    [viewOfNavigation setHidden:true];
    topLapOutOfView.constant = -30 ;

}

-(void)addAbbsorberForShowView {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showView:)
                                                 name:@"showView"
                                               object:nil];
    
}

- (void)showView:(NSNotification *) notification
{
    [viewOfMember setHidden:false];
    [viewOfNavigation setHidden:false];
    topLapOutOfView.constant = 0 ;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:true];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated] ;
//    topLapOutOfView.constant = 44 ;
    
    [self.navigationController setNavigationBarHidden:true];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UINavigationController *) goldMember
{
    
    YPOGoldMember *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGoldMember"];
    
    vc.valueForMember = self.valueForBoardMemberAndMember ;
    
    goldMemberNav = [[UINavigationController alloc]initWithRootViewController:vc];
    [goldMemberNav setNavigationBarHidden:true];
    return  goldMemberNav ;
}


- (UINavigationController *) YPOMember
{
    YPOMemberViewControoler *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMemberViewControoler"];
    vc.valueForMember = self.valueForBoardMemberAndMember ;
    ypoMemberNav = [[UINavigationController alloc]initWithRootViewController:vc];
    

    [ypoMemberNav setNavigationBarHidden:true];
    return  ypoMemberNav ;
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return myViewControllers[index];
}

- (IBAction)btnGoldMember_Pressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    NSInteger index = 0;
    [btnGoldMember setSelected:true];
    [btnOfYpoMember setSelected:false];
    
    
    
    [viewOfYPOMember setHidden:true];
    [viewOfGoldMember setHidden:false];

    
//    [btnGoldMember setTitleColor:[UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [btnOfYpoMember setTitleColor:[UIColor colorWithRed:162/255.0 green:169/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];

    
//    [btnGoldMember setTitleColor:[UIColor colorWithRed:162/255.0 green:169/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
  //  [btnOfYpoMember setTitleColor:[UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];

//    [btnGoldMember setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnOfYpoMember setTitleColor:[UIColor colorWithRed:164/255.0 green:172/255.0 blue:178/255.0 alpha:1.0] forState:UIControlStateNormal];

    [pageController setViewControllers:@[ [self viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
     {
         
     }];

}

- (IBAction)btnYPOMember:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    [btnOfYpoMember setSelected:true];
    [btnGoldMember setSelected:false];

    NSInteger index = 1;
    [viewOfGoldMember setHidden:true];
    [viewOfYPOMember setHidden:false];

//    [btnOfYpoMember setTitleColor:[UIColor colorWithRed:2/255.0 green:38/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [btnGoldMember setTitleColor:[UIColor colorWithRed:162/255.0 green:169/255.0 blue:174/255.0 alpha:1.0] forState:UIControlStateNormal];
    [pageController setViewControllers:@[ [self viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:^(BOOL finished)
     {
         
     }];
    
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

//let index = 1
//pageController.setViewControllers([self.viewControllerAtIndex(index: index)], direction: .reverse, animated: false, completion: {(finished: Bool) -> Void in
//})
//func homeNavVC() -> UINavigationController {
//    
//    let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "WACategorieDetailVC") as? WACategorieDetailVC
//    homeNav = UINavigationController(rootViewController: homeVC!)
//    homeVC?.allList = self.allGetCoriesList
//    
//    homeNav?.isNavigationBarHidden = true
//    return homeNav!
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
