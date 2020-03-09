//
//  UDNavigationController.m
//  Poice
//
//  Created by Uzair Danish on 13/09/2013.
//  Copyright (c) 2013 Appostrophic. All rights reserved.
//

#import "UDNavigationController.h"
#import "UIBarButtonItem+UDBarButtonItem.h"
#import "Utility.h"
//#import "Constants.h"
//#import "UINavigationBar+UINavigationBar_ExclusiveTouchOFF.h"

@interface UDNavigationController ()

@end

@implementation UDNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController withNavigationBarBackground:(NSString *)backgroundImageName withNavigationBarBackButtonImage:(NSString *)backButtonImageName {

    self = [super initWithRootViewController:rootViewController];
    
    self.navigationBar.translucent = NO;
    
    
    //[[self navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self navigationBarSetBackground:backgroundImageName];
  //  [self navigationBarSetBackButtonImage:backButtonImageName];
    self.delegate = self;
    
    return self;
}

-(void) awakeFromNib{
    //[self navigationBarSetBackButtonImage:@"iconNotif"];

    [super awakeFromNib];
    

    
    
}

- (void)navigationBarSetBackground:(NSString *)imageName{
    
    NSString *barImageName = imageName;
    if ([Utility systemVersionGreaterThanOrEqualTo:@"7.0"])
        barImageName = [NSString stringWithFormat:@"%@-568h",barImageName];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:barImageName] forBarMetrics:UIBarMetricsDefault];
}

- (void)navigationBarSetBackButtonImage:(NSString *)imageName{
    
    UIImage *backButtonImage = [UIImage imageNamed:@"iconNotif"];
    UIButton *backBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    backBTN.frame = CGRectMake(0, 0, backButtonImage.size.width+20, backButtonImage.size.height);
    [backBTN setImage:backButtonImage forState:UIControlStateNormal];
    //[backBTN addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *barbackButton = [[UIBarButtonItem alloc] initWithCustomView:backBTN];
    

}

-(void) navigationBarSetFont:(NSString*)fontName fontSize:(float)fontSize{
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:fontName size:fontSize], NSFontAttributeName,
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil];
    self.navigationController.navigationBar.titleTextAttributes = normalAttributes;
 
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
   // [self navigationBackButtonSetBackWidth];
    
}

- (void)navigationBackButtonSetBackWidth{
    /*
    UIBarButtonItem *myBarButtonItem = [[UIBarButtonItem alloc] init];
    myBarButtonItem.title = @"Back.";
    
    
    UINavigationItem *currentNavigationItem = [[self.viewControllers lastObject] navigationItem];
    
    if(currentNavigationItem.backBarButtonItem)
        [currentNavigationItem.backBarButtonItem setTitle:@"Back."];
    else
        [currentNavigationItem setBackBarButtonItem:myBarButtonItem];
     */
    
}

- (void)navigationBarSetNavigationButtonImage:(NSString *)imageName{
    /*
    UIImage *barButtonImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    */
}

- (void)navigationBarSetTitleTextAttribute:(UIFont *)textFont TextColor:(UIColor *)textColor TextShadowColor:(UIColor *)textShadowColor TextShadowOffset:(NSValue *)valueWithOffset{
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor : textShadowColor];
    [shadow setShadowOffset : [valueWithOffset CGSizeValue]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           textColor, NSForegroundColorAttributeName,
                                                           shadow,NSShadowAttributeName,
                                                           textFont, NSFontAttributeName, nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    
    
    [self.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"JosefinSans-Bold" size:22]}];
    
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:235/255.0f alpha:1.0f];
        self.navigationBar.translucent = NO;
        //self.navigationBar.barTintColor = [UIColor colorWithRed:78.0/255.0f green:75.0/255.0f blue:70.0/255.0f alpha:1.0f]; //Gray
        self.navigationBar.barTintColor = [UIColor colorWithRed:163.0/255.0f green:31.0/255.0f blue:52.0/255.0f alpha:1.0f]; //Orange
    }else{
        //self.navigationBar.tintColor = [UIColor colorWithRed:78.0/255.0f green:75.0/255.0f blue:70.0/255.0f alpha:1.0f]; //Gray
        self.navigationBar.barTintColor = [UIColor colorWithRed:163.0/255.0f green:31.0/255.0f blue:52.0/255.0f alpha:1.0f]; //Orange
    }
    
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
