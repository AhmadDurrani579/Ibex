//
//  YPOAdminVc.m
//  YPOPakistan
//
//  Created by Ahmed Durrani on 15/01/2018.
//  Copyright © 2018 Sajid Saeed. All rights reserved.
//

#import "YPOAdminVc.h"
#import "EventSpeakerTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "EventSpeakerModel.h"
#import "YPOChatViewController.h"
#import "AttendeeSpeakerSessionViewController.h"
@interface YPOAdminVc () <MessageBtnDelegate , UITableViewDelegate , UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbleView;

@end

@implementation YPOAdminVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1 ;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return  _organizerArrayList.count ;
//    if (section == 0) {
//        return  2 ;
//    } else {
//        return  _listOfOrganizationList.count ;
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    EventSpeakerTableViewCell *cell = (EventSpeakerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"eventspeakerCell"];
    
    if (cell == nil) {
        cell = [[EventSpeakerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eventspeakerCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EventSpeakerModel *obj = (EventSpeakerModel *)[_organizerArrayList objectAtIndex:indexPath.row];
     NSURL *imageUrlForAdmin ;
    NSString *tempString = [NSString stringWithFormat:@"%@ %@", obj.speakerFirstName  , obj.speakerLastName];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *userInfo = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
   
    NSString *speakerID = [NSString stringWithFormat:@"%@" , obj.speakerID] ;
    
    if ([speakerID isEqualToString:[NSString stringWithFormat:@"%@", userInfo.loginUserID]]) {
        [cell.btnMessage setHidden:true];
        
        
    } else {
        [cell.btnMessage setHidden:false];
        
    }

    if([[tempString lowercaseString] containsString:@"(null)"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    }
    
    if([[tempString lowercaseString] containsString:@"<null>"]){
        tempString = [tempString stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    }
    [cell.lblTitle setText:tempString];
     [cell.subHeading1 setText:obj.speakerJobTitle];
     [cell.subHeading2 setText:obj.speakerCompany];
     [cell.subHeading3 setText:obj.speakerCountry];
    cell.delegate = self ;
    cell.index = indexPath ;
  
            id  thumbnailImageOfAdmin = obj.speakerThumbImg ;
            
            if (thumbnailImageOfAdmin != [NSNull null]) {
                NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.speakerThumbImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                imageUrlForAdmin  = [NSURL URLWithString:imageURLString];
//
                [cell.ivUserPic setImageWithURL:imageUrlForAdmin placeholderImage:[UIImage imageNamed:@"ph_user_medium"]];
                [cell.ivUserPic setContentMode:UIViewContentModeScaleAspectFill];
                cell.ivUserPic.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
                cell.ivUserPic.layer.masksToBounds = YES;

                
            }else {
                [cell.ivUserPic setImage:[UIImage imageNamed:@"ph_user_medium"]];
                [cell.ivUserPic setContentMode:UIViewContentModeScaleAspectFill];
                cell.ivUserPic.layer.cornerRadius = cell.ivUserPic.frame.size.height/2;
                cell.ivUserPic.layer.masksToBounds = YES;
            }
    
    
    return  cell ;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AttendeeSpeakerSessionViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"attsessionVC"];
    EventSpeakerModel *obj  =  (EventSpeakerModel *)[_organizerArrayList objectAtIndex:indexPath.row];
    vc.selectedSpeaker = obj ;
    vc.pushTypeGoldOrYpoMember = 0 ;
    [self.navigationController pushViewController:vc animated:true];
}

-(void)btnMessage_Pressed:(EventSpeakerTableViewCell *)cell indexPathRow:(NSIndexPath *)indexPathRow {

    YPOChatViewController *chatVc = [self.storyboard instantiateViewControllerWithIdentifier:@"YPOChatViewControllers"];
    EventSpeakerModel *obj  =  (EventSpeakerModel *)[_organizerArrayList objectAtIndex:indexPathRow.row];
    chatVc.selectedSpeaker = obj ;
    chatVc.pushTypeGoldOrYpoMember = 4 ;
    
    [self.navigationController pushViewController:chatVc animated:true];

    
}
@end
