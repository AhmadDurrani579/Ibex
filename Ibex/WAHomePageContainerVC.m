//
//  WAHomePageContainerVC.m
//  Ibex
//
//  Created by Ahmed Durrani on 26/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "WAHomePageContainerVC.h"
#import "YPOGoldMember.h"
#import "YPOMemberViewControoler.h"
#import "Constant.h"
@interface WAHomePageContainerVC () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    UIViewController *previousVC ;
    int showIndex  ;
    UIPageViewController *pageVc ;
    __weak IBOutlet UIView *viewBottom;
}


@end

@implementation WAHomePageContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    showIndex  = 0 ;
    
    self.automaticallyAdjustsScrollViewInsets = false ;
    [self setPager];
    
    
    [self.view bringSubviewToFront:viewBottom];
    
    
//    self.automaticallyAdjustsScrollViewInsets = false
//    setPager()
//    
//    self.view.bringSubview(toFront: viewBottom)

    // Do any additional setup after loading the view.
}

//MARK: custom methods

-(void)setPager
{
    pageVc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    pageVc.delegate = self ;
    pageVc.dataSource = self ;
    UIViewController *startVC = [self viewControllerAtIndex:0];
    
    [pageVc setViewControllers:@[startVC] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    pageVc.view.frame =  CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
    
    [self addChildViewController:pageVc];
    [self.view addSubview:pageVc.view];
    [pageVc didMoveToParentViewController:self];
}


-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
   if (index == 0)
   {
       YPOGoldMember *ypoGoldMember = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGoldMember"];
       return  ypoGoldMember ;
   }
    else
    {
        YPOMemberViewControoler *ypoMemberVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMemberViewControoler"];
        return  ypoMemberVc ;

    }
 

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    int currIndex =  -1 ;
    
    YPOMemberViewControoler *ypoMemberVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMemberViewControoler"];
    YPOGoldMember *goldMember = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGoldMember"];

    if (viewController == ypoMemberVc)
    {
        currIndex =  ypoMemberVc.index ;
        
    }
    else
    {
        currIndex = goldMember.index ;
        
    }
    
    if (currIndex == NSNotFound)
    {
        return nil ;
    }
    
    currIndex = currIndex + 1 ;
    
    if (currIndex == 2)
    {
        return  nil ;
    }
    
    UIViewController *vc = [self viewControllerAtIndex:currIndex];
    return vc ;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    int currIndex =  -1 ;
    
    YPOMemberViewControoler *ypoMemberVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOMemberViewControoler"];
    YPOGoldMember *goldMember = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOGoldMember"];
    
    if (viewController == ypoMemberVc)
    {
        currIndex =  ypoMemberVc.index ;
        
    }
    else
    {
        currIndex = goldMember.index ;
        
    }
    
    if (currIndex == 0  || currIndex == NSNotFound )
    {
        return nil ;
    }
    
    currIndex = currIndex - 1 ;

    return [self viewControllerAtIndex:currIndex] ;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed == true){
        previousVC = previousViewControllers.firstObject ;
//        if (showIndex == 0 ){
//            if (pageViewController.viewControllers != nil && (pageViewController.viewControllers.count)! > 0 && pageViewController.viewControllers.firstObject)
//        }
    }
    
    
//    {
//        previousVC = previousViewControllers.first
//        if showingIndex == 0 {
//            if pageViewController.viewControllers != nil && (pageViewController.viewControllers?.count)! > 0 && pageViewController.viewControllers?.first is WAProfileVC {
//                showingIndex = 1
//                
//                lblAccount.textColor = UIColor(red: 145/255, green: 38/255, blue: 143/255, alpha: 1.0)
//                lblBuisess.textColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1.0)
//                lblAccount.font = UIFont(name: "Gotham-Bold", size: 15.0)
//                lblBuisess.font = UIFont(name: "Gotham-Medium", size: 15.0)
//                imageOfBottomDashBoard.isHidden = (showingIndex == 1)
//                imageOfBottomAccount.isHidden = (showingIndex == 0)
//            }
//        }else {
//            if pageViewController.viewControllers != nil && (pageViewController.viewControllers?.count)! > 0 && pageViewController.viewControllers?.first is WAHomeVC {
//                showingIndex = 0
//                
//                //                    lblAccount.textColor = UIColor.black
//                
//                
//                lblBuisess.textColor = UIColor(red: 145/255, green: 38/255, blue: 143/255, alpha: 1.0)
//                lblAccount.textColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1.0)
//                lblBuisess.font = UIFont(name: "Gotham-Bold", size: 15.0)
//                lblAccount.font = UIFont(name: "Gotham-Medium", size: 15.0)
//                
//                imageOfBottomDashBoard.isHidden = (showingIndex == 1)
//                imageOfBottomAccount.isHidden = (showingIndex == 0)
//            }
//        }
//    }
}


@end
