//
//  DBChatManager.h
//  Tellmo
//
//  Created by Waris Shams on 04/03/2015.
//  Copyright (c) 2015 Devbatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import <CoreData/CoreData.h>
//#import "CAContactManager.h"
//#import "RMPhoneFormat.h"
#import "DDTTYLogger.h"
//#import "ChatManager.h"
#import "NSDate-Key.h"
#import "DDLog.h"

// XMPP Classes
#import "XMPP.h"
#import "XMPPPing.h"
#import "XMPPLogging.h"
#import "XMPPReconnect.h"
#import "GCDAsyncSocket.h"
#import "TWMessageBarManager.h"
#import "XMPPMessageArchiving.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPMessageDeliveryReceipts.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRoom.h"
#import "EventAdd+CoreDataClass.h"
#import "MOMessage.h"
#import "Chat+CoreDataClass.h"
#import "Roaster+CoreDataClass.h"
#import "XMPPDigestMD5Authentication.h"
#import "EventSpeakerModel.h"
#import "MOGoldMemberObject.h"
#import "AppDelegate.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPMUC.h"
#import "EventSpeakerModel.h"
#import "ChatRooms+CoreDataClass.h"
#import "GroupMessage+CoreDataClass.h"
#import "XMPPAutoPing.h"
#import "XMPPStreamManagement.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPLastActivity.h"

#define SharedDBChatManager [DBChatManager shareInstance]


@interface DBChatManager : NSObject <XMPPRosterDelegate, TWMessageBarStyleSheet , XMPPMUCDelegate> {
    XMPPStream                      *xmppStream;
    XMPPReconnect                   *xmppReconnect;
    XMPPRoster                      *xmppRoster;
    XMPPRosterCoreDataStorage       *xmppRosterStorage;
    XMPPvCardCoreDataStorage        *xmppvCardStorage;
    XMPPvCardTempModule             *xmppvCardTempModule;
    XMPPvCardAvatarModule           *xmppvCardAvatarModule;
    XMPPCapabilities                *xmppCapabilities;
    XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPPing                        *xmppPing;
    XMPPMUC                         *xmppMUC;
    XMPPRoom                        *xmppRoom ;
    XMPPStreamManagement            *xmppStreamManagement ;
    XMPPMessageArchivingCoreDataStorage    *xmppStorage ;
    XMPPMessageArchiving                *xmppMessageArchivingModule ;
    GCDAsyncSocket                      *socketsConnect ;
    XMPPLastActivity                *xmppLastActivity ;
    
    
    AppDelegate                     *appDelegate ;
    NSString *myJid;

    NSString *password;
    NSMutableArray *arrayOfRoaster ;
    NSMutableArray *arrayOfGroupList ;

    NSMutableArray *arrayOfChat ;

    BOOL customCertEvaluation;
    NSMutableArray *arrayOfGroupMessages ;
    
    BOOL isXmppConnected;
    BOOL isContained ;
    BOOL isRegister  ;
    BOOL isPhotoOrMessageText  ;
    NSString *from  ;
    NSString *receiverId  ;



    
}

#pragma mark - Properties

@property (nonatomic, strong, readonly) XMPPStream                      *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect                   *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster                      *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage       *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule             *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule           *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities                *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong, readonly) XMPPMessageDeliveryReceipts     *xmppMessageDeliveryRecipts;
@property (nonatomic, strong, readonly) XMPPPing                        *xmppPing;
@property (nonatomic, strong, readonly) XMPPRoom                        *xmppRoom;
@property (nonatomic, strong, readonly) XMPPMUC                         *xmppMUC;
@property (nonatomic, strong, readonly) XMPPLastActivity                *xmppLastActivity;
@property (nonatomic, strong, readonly) XMPPAutoPing                          *xmppAutoPing;
@property (nonatomic, strong, readonly) XMPPStreamManagement                          *xmppStreamManagement;
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage                          *xmppStorage;
@property (nonatomic, strong, readonly) XMPPMessageArchiving                          *xmppMessageArchivingModule;
@property (nonatomic, strong, readonly) GCDAsyncSocket                          *socketsConnect;









@property (nonatomic,strong)            Roaster     *recentList;
@property (nonatomic,strong)            ChatRooms   *roomChat;
@property (nonatomic,strong)            GroupMessage   *groupMessage;




//@property (nonatomic, strong) RMPhoneFormat                             *phoneFormat;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic,strong) Chat *userChat;


#pragma mark - Action Methods

// Singleton Method
+(DBChatManager *)shareInstance;

//- (NSManagedObjectContext *)managedObjectContext_roster;
//- (NSManagedObjectContext *)managedObjectContext_capabilities;

//** Create Connection + Setup Stream

-(void)makeConnectionWithChatServer;

- (void)teardownStream;
- (void)setupStream ;
- (BOOL)connect  ;
- (void)goOffline ;
- (void)disconnectXMPP ;
-(void)setupConnection ;
-(void)lastSeen:(NSString *) jib ;

//** Send message to XMPP server and Save it to Local Database


-(void)sendAndSaveMeesage : (id)message andMessageType:(NSString *)messageType attendese:(EventSpeakerModel *)attendese modelType:(MOGoldMemberObject *)model roasterLoadUser :(Roaster *)roasterLoadUser  ofThread:(Chat *)thread  withCompletionHandler:(void (^)(Chat *soMessage, BOOL success))handler ;

//- (void)sendAndSaveMessage:(id)message andMessageType:(NSString *)messageType ofThread:(Thread *)thread withCompletionHandler:(void (^)(Message *soMessage, BOOL success))handler;

- (void)getPresenceForJid:(NSString *)jid;

@end
