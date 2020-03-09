//
//  YPOChatViewController.h
//  YPO
//
//  Created by Ahmed Durrani on 11/10/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roaster+CoreDataClass.h"
#import "EventSpeakerModel.h"
#import "MOGoldMemberObject.h"
#import "Chat+CoreDataClass.h"
@interface YPOChatViewController : UIViewController
@property(nonatomic , strong) Roaster *selectedUser ;
@property (strong, nonatomic) EventSpeakerModel *selectedSpeaker;
@property (strong, nonatomic) MOGoldMemberObject *selectGoldMember;
@property(nonatomic , assign) NSInteger pushTypeGoldOrYpoMember ;
@property(nonatomic , strong) Chat *userSelectedChat ;


@end
