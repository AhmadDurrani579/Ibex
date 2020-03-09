//
//  SponsorsViewController.m
//  Ibex
//
//  Created by Sajid Saeed on 29/06/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "SponsorsViewController.h"
#import "Webclient.h"
#import "DAAlertController.h"
#import "SponsorsResponse.h"
#import "SponsorsTableViewCell.h"
#import "SponsorModel.h"
#import "UIImageView+AFNetworking.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "OwnButton.h"
#import "Utility.h"

@interface SponsorsViewController (){
    SponsorsResponse *masterObj;
    NSMutableDictionary *sponsorSorting;
    NSMutableArray *dictKeys;
}

@end

@implementation SponsorsViewController
@synthesize tvSponsors;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchSponsors];
}

-(void) fetchSponsors{
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *eventID = [NSString stringWithFormat:@"%@", appDelegate.selectedEventID];
    
    sponsorSorting = [[NSMutableDictionary alloc] init];
    dictKeys = [[NSMutableArray alloc] init];
    
    [[Webclient sharedWeatherHTTPClient] getSponsors:eventID viewController:self CompletionBlock:^(NSObject *responseObject) {
        
        masterObj = (SponsorsResponse *) responseObject;
        
        if([[NSString stringWithFormat:@"%@", masterObj.status] isEqualToString:@"1"]){
            
            NSMutableArray *gold = [[NSMutableArray alloc] init];
            NSMutableArray *silver = [[NSMutableArray alloc] init];
            NSMutableArray *titanium = [[NSMutableArray alloc] init];
            NSMutableArray *platinum = [[NSMutableArray alloc] init];
            
            for(SponsorModel *sponsorObj in masterObj.sponsorList){
                if([[NSString stringWithFormat:@"%@", sponsorObj.sponsorTypeID] isEqualToString:@"1"]){
                    //GOLD
                    [gold addObject:sponsorObj];
                }
                else if([[NSString stringWithFormat:@"%@", sponsorObj.sponsorTypeID] isEqualToString:@"2"]){
                    //SILVER
                    [silver addObject:sponsorObj];
                }
                else if([[NSString stringWithFormat:@"%@", sponsorObj.sponsorTypeID] isEqualToString:@"3"]){
                    //PLATINUM
                    [platinum addObject:sponsorObj];
                }
                else{
                    //TITANIUM
                    [titanium addObject:sponsorObj];
                }
            }
            
            if(silver.count>0){
                [sponsorSorting setObject:silver forKey:@"SILVER"];
            }
            
            if(gold.count>0){
                [sponsorSorting setObject:gold forKey:@"GOLD"];
            }
            
            if(titanium.count>0){
                [sponsorSorting setObject:titanium forKey:@"TITANIUM"];
            }
            
            if(platinum.count>0){
                [sponsorSorting setObject:platinum forKey:@"PLATINUM"];
            }
            
            dictKeys = [sponsorSorting allKeys].mutableCopy;
            
            [tvSponsors reloadData];
        }
        else{
            DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:DAAlertActionStyleCancel
                                                                  handler:^{
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
            
            [DAAlertController showAlertViewInViewController:self withTitle:@"Error!" message:[NSString stringWithFormat:@"%@", masterObj.message] actions:@[dismissAction]];
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

-(int) getCountfortheKey:(NSString *)key dict:(NSMutableDictionary *)dict{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    temp = [dict objectForKey:key];
    return (int)temp.count;
}

-(int) totalCount{

    NSUInteger keyCount = [sponsorSorting count];
    return (int)keyCount;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSInteger numOfSections = 0;
    if (masterObj.sponsorList.count >0)
    {
        //tvCalender.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tvSponsors.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tvSponsors.bounds.size.width, tvSponsors.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tvSponsors.backgroundView = noDataLabel;
        tvSponsors.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self totalCount];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"sponsorCell";
    
    SponsorsTableViewCell *cell = (SponsorsTableViewCell *)[tvSponsors dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[SponsorsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.lblTitle setText:[NSString stringWithFormat:@"%@", [dictKeys objectAtIndex:indexPath.row]]];
    
    if([[[NSString stringWithFormat:@"%@", [dictKeys objectAtIndex:indexPath.row]] lowercaseString] isEqualToString:@"silver"]){
        [cell.lblTitle setBackgroundColor:[UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0]];
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [sponsorSorting objectForKey:@"SILVER"];
        UIScrollView *svPartners = cell.sv;
        
        int spacing = 10;
        int x= spacing;
        
        for(int i=0; i<list.count; i++){
            
            SponsorModel *tempObj = [list objectAtIndex:i];
            
           // UIImageView *imagetest = [[UIImageView alloc] init];
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[tempObj.sponsorThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,tempObj.sponsorThumb]];
           // [imagetest setImageWithURL:[NSURL URLWithString:tempObj.sponsorThumb]];
            
            OwnButton *btn = [[OwnButton alloc] init];
            //[btn setFrame:CGRectMake(x, 13, ()-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setTag:i];
            
            btn.url = tempObj.sponsorURL;
            
            UIImageView *ivPartnerLogo = [[UIImageView alloc] init];
            [ivPartnerLogo setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            ivPartnerLogo.contentMode = UIViewContentModeScaleAspectFit;
            [svPartners addSubview:ivPartnerLogo];
            
            
            [ivPartnerLogo setTintColor:[UIColor orangeColor]];
            
            [btn addTarget:self action:@selector(gotolink:) forControlEvents:UIControlEventTouchUpInside];
            [svPartners addSubview:btn];
            
            [ivPartnerLogo setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img_ph"]];
            
            x= ivPartnerLogo.frame.size.width + x + spacing;
            
        }
        
        svPartners.contentSize= CGSizeMake(x ,svPartners.frame.size.height);
        
    }
    else if([[[NSString stringWithFormat:@"%@", [dictKeys objectAtIndex:indexPath.row]] lowercaseString] isEqualToString:@"gold"]){
        [cell.lblTitle setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:171.0/255.0 blue:30.0/255.0 alpha:1.0]];
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [sponsorSorting objectForKey:@"GOLD"];
        UIScrollView *svPartners = cell.sv;
        
        int spacing = 10;
        int x= spacing;
        
        for(int i=0; i<list.count; i++){
            
            SponsorModel *tempObj = [list objectAtIndex:i];
            
            // UIImageView *imagetest = [[UIImageView alloc] init];
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[tempObj.sponsorThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            // [imagetest setImageWithURL:[NSURL URLWithString:tempObj.sponsorThumb]];
            
            OwnButton *btn = [[OwnButton alloc] init];
            //[btn setFrame:CGRectMake(x, 13, ()-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setTag:i];
            btn.url = tempObj.sponsorURL;
            UIImageView *ivPartnerLogo = [[UIImageView alloc] init];
            [ivPartnerLogo setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            ivPartnerLogo.contentMode = UIViewContentModeScaleAspectFit;
            [svPartners addSubview:ivPartnerLogo];
            
            
            [ivPartnerLogo setTintColor:[UIColor orangeColor]];
            
            [btn addTarget:self action:@selector(gotolink:) forControlEvents:UIControlEventTouchUpInside];
            [svPartners addSubview:btn];
            
            [ivPartnerLogo setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_ph"]];
            
            x= ivPartnerLogo.frame.size.width + x + spacing;
            
        }
        
        svPartners.contentSize= CGSizeMake(x ,svPartners.frame.size.height);
    }
    else if([[[NSString stringWithFormat:@"%@", [dictKeys objectAtIndex:indexPath.row]] lowercaseString] isEqualToString:@"platinum"]){
        [cell.lblTitle setBackgroundColor:[UIColor colorWithRed:121.0/255.0 green:121.0/255.0 blue:121.0/255.0 alpha:1.0]];
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [sponsorSorting objectForKey:@"PLATINUM"];
        UIScrollView *svPartners = cell.sv;
        
        int spacing = 10;
        int x= spacing;
        
        for(int i=0; i<list.count; i++){
            
            SponsorModel *tempObj = [list objectAtIndex:i];
            
            // UIImageView *imagetest = [[UIImageView alloc] init];
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[tempObj.sponsorThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            // [imagetest setImageWithURL:[NSURL URLWithString:tempObj.sponsorThumb]];
            
            OwnButton *btn = [[OwnButton alloc] init];
            //[btn setFrame:CGRectMake(x, 13, ()-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setTag:i];
            btn.url = tempObj.sponsorURL;
            UIImageView *ivPartnerLogo = [[UIImageView alloc] init];
            [ivPartnerLogo setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            ivPartnerLogo.contentMode = UIViewContentModeScaleAspectFit;
            [svPartners addSubview:ivPartnerLogo];
            
            
            [ivPartnerLogo setTintColor:[UIColor orangeColor]];
            
            [btn addTarget:self action:@selector(gotolink:) forControlEvents:UIControlEventTouchUpInside];
            [svPartners addSubview:btn];
            
            [ivPartnerLogo setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_ph"]];
            
            x= ivPartnerLogo.frame.size.width + x + spacing;
            
        }
        
        svPartners.contentSize= CGSizeMake(x ,svPartners.frame.size.height);
    }
    else{
        [cell.lblTitle setBackgroundColor:[UIColor colorWithRed:167.0/255.0 green:176.0/255.0 blue:181.0/255.0 alpha:1.0]];
        
        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [sponsorSorting objectForKey:@"TITANIUM"];
        UIScrollView *svPartners = cell.sv;
        
        int spacing = 10;
        int x= spacing;
        
        for(int i=0; i<list.count; i++){
            
            SponsorModel *tempObj = [list objectAtIndex:i];
            
            // UIImageView *imagetest = [[UIImageView alloc] init];
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[tempObj.sponsorThumb stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            // [imagetest setImageWithURL:[NSURL URLWithString:tempObj.sponsorThumb]];
            
            OwnButton *btn = [[OwnButton alloc] init];
            //[btn setFrame:CGRectMake(x, 13, ()-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            [btn setTag:i];
            btn.url = tempObj.sponsorURL;
            UIImageView *ivPartnerLogo = [[UIImageView alloc] init];
            [ivPartnerLogo setFrame:CGRectMake(x, 13, (svPartners.frame.size.width/3)-(spacing*1.25), svPartners.frame.size.height-26)];
            ivPartnerLogo.contentMode = UIViewContentModeScaleAspectFit;
            [svPartners addSubview:ivPartnerLogo];
            
            
            [ivPartnerLogo setTintColor:[UIColor orangeColor]];
            
            [btn addTarget:self action:@selector(gotolink:) forControlEvents:UIControlEventTouchUpInside];
            [svPartners addSubview:btn];
            
            [ivPartnerLogo setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_ph"]];
            
            x= ivPartnerLogo.frame.size.width + x + spacing;
            
        }
        
        svPartners.contentSize= CGSizeMake(x ,svPartners.frame.size.height);
    }

    
    return cell;
}

-(void) gotolink:(NSString*)sender{
    
    OwnButton *btn = (OwnButton*)sender;
    
    if(![Utility isEmptyOrNull:[NSString stringWithFormat:@"%@", btn.url]]){
        if([[btn.url lowercaseString] containsString:@"http://"] || [[btn.url lowercaseString] containsString:@"https://"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:btn.url]];
        }
        else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", btn.url]]];
        }
    }
    else{
        DAAlertAction *dismissAction = [DAAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                style:DAAlertActionStyleCancel
                                                              handler:^{
                                                                  
                                                                  
                                                              }];
        
        [DAAlertController showAlertViewInViewController:self withTitle:@"Not Found!" message:@"No data found." actions:@[dismissAction]];
        // [clickedCell.btnLinkedin setHidden:YES];
    }

   
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
