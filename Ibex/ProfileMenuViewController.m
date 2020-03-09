//
//  ProfileMenuViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 07/07/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "ProfileMenuViewController.h"

@interface ProfileMenuViewController ()

@end

@implementation ProfileMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logoutButtonPressed:(id)sender {
    [self.delegate logoutButtonPressed:sender];
}

- (IBAction)editProfileButtonPressed:(id)sender {
    [self.delegate editProfileButtonPressed:sender];
}

- (IBAction)settingsButtonPressed:(id)sender {
    [self.delegate settingsButtonPressed:sender];
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
