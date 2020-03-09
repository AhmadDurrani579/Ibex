 //
//  DBChatManager.m
//  YPO
//
//  Created Ahmad on 04/03/2015.
//  Copyright (c) 2015 Devbatch. All rights reserved.
//

//#import "SDWebImageDownloader.h"
#import "XMPPSASLAuthentication.h"
//#import "UIImage+ImageCompress.h"
#import "XMPPvCardTempBase.h"
#import "DBChatManager.h"
#import "XMPPvCardTemp.h"
#import "loginResponse.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "Utility.h"
#import "DDLog.h"
#import "Message.h"
#import "MOMessage.h"
#import "Utility.h"
#import "Constant.h"
#import "Chat+CoreDataClass.h"
#import "Roaster+CoreDataClass.h"
#import "UIViewController+Helper.h"
#import "PAStorageHelper.h"
#import "SDWebImageDownloader.h"
#import "UIImage+ImageCompress.h"
#import "XMPPRoomCoreDataStorage.h"
#import "Webclient.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking/AFNetworking.h"
#import "NSDate+NVTimeAgo.h"
#import "SVHTTPRequest.h"



// Log levels: off, error, warn, info, verbose
#if DEBUG
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
//static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation DBChatManager


@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize xmppMessageDeliveryRecipts;
@synthesize xmppPing;
@synthesize xmppRoom ;
@synthesize xmppMUC ;
@synthesize xmppMessageArchivingModule ;


#pragma mark Class Initialization Methods

// Singleton Method
+(DBChatManager *)shareInstance {
    static DBChatManager *shared = nil;
    static dispatch_once_t  once_t;
    dispatch_once(&once_t, ^{
        shared = [[DBChatManager alloc] init];
    });

    return shared;
}

-(id)init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Custom Methdos


-(NSDate *)getDateFromString:(NSString *)stringDate{
    
    stringDate          = [stringDate  stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    stringDate          = [stringDate  stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    stringDate          = [[stringDate componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *convertedDate         = [myDateFormatter dateFromString:stringDate];
    return convertedDate;
}

#pragma mark - CHAT DATABASE METHODS

#pragma mark Send & Save Message in local Database




-(void)sendAndSaveMeesage : (id)message andMessageType:(NSString *)messageType attendese:(EventSpeakerModel *)attendese modelType:(MOGoldMemberObject *)model roasterLoadUser :(Roaster *)roasterLoadUser  ofThread:(Chat *)thread  withCompletionHandler:(void (^)(Chat *soMessage, BOOL success))handler 
{
    
    
    NSString *urlOfSender ;
    __block NSXMLElement *fileOfSender ;
    NSString *imageSEndUrl ;

    arrayOfRoaster = [[NSMutableArray alloc] init];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    
    NSString *myJID ;
    
    
    if (model){
        myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", model.ids];
        receiverId = model.ids ;
    } else if (attendese){
        myJID =  [NSString stringWithFormat:@"%@@ibexglobal.com", attendese.speakerID];
        receiverId = attendese.speakerID ;

    }
    else {
        myJID = [NSString stringWithFormat:@"%@@ibexglobal.com", roasterLoadUser.jaber_ID];
        receiverId = roasterLoadUser.jaber_ID ;

    }
    XMPPJID *jid = [XMPPJID  jidWithString:myJID];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    NSXMLElement *messageToSend = [NSXMLElement elementWithName:@"message"];
    NSXMLElement *attachment = [NSXMLElement elementWithName:@"msg_extras" xmlns:@"org.ypo"];
    NSXMLElement *senderName ;
    NSXMLElement *senderID ;
    NSXMLElement *senderImage ;
    NSXMLElement *messageTypePhotoOrText ;
    NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
    
    senderName  =   [NSXMLElement elementWithName:@"sender_name" stringValue: obj.loginDisplayName];
    
    NSString *idOfUsers = [NSString stringWithFormat:@"%@", obj.loginUserID];
    senderID    =   [NSXMLElement elementWithName:@"sender_id" stringValue:idOfUsers];
    
    
    if (model){
        id  thumbnailImage = model.dpPathThumb ;
        if (thumbnailImage != [NSNull null]) {
            senderImage =   [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
        } else {
            senderImage =   [NSXMLElement elementWithName:@"sender_image" stringValue: @" "];
        }
        
    } else if (attendese){
        
        id  thumbnailImage = attendese.speakerThumbImg ;
        if (thumbnailImage != [NSNull null]) {
            senderImage =   [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
        } else {
            senderImage =   [NSXMLElement elementWithName:@"sender_image" stringValue: @" "];
        }
    }else {
        id  thumbnailImage = _recentList.sender_Image ;
        if (thumbnailImage != [NSNull null]) {
            senderImage =   [NSXMLElement elementWithName:@"sender_image" stringValue: obj.loginUserDP];
        } else {
            senderImage =   [NSXMLElement elementWithName:@"sender_image" stringValue: @" "];
        }
    }
   
    if ([messageType isEqualToString: MessageTypeText]){
        messageTypePhotoOrText  = [NSXMLElement elementWithName:@"msg_type" stringValue:TEXT_MESSAGE] ;
    }else {
        messageTypePhotoOrText  = [NSXMLElement elementWithName:@"msg_type" stringValue:IMAGE_MESSAGE] ;
    
    }
    
    if ([messageType isEqualToString: MessageTypeText]){
        fileOfSender  = [NSXMLElement elementWithName:@"file" stringValue:@"/Content/file_url"] ;
    }
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    NSDate *date = [outputFormatter dateFromString:dateTime];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

//    [outputFormatter setDateFormat:@"HH:mm"];
    NSDate * now = [NSDate date];

    NSString *newDateString = [outputFormatter stringFromDate:now];
    
    
    
     NSString *myString = [defaults stringForKey:@"jID"];
     if ([messageType isEqualToString:MessageTypeText]) {
         
         NSDateFormatter *outputFormatterss = [[NSDateFormatter alloc] init];
         //    NSDate *date = [outputFormatter dateFromString:dateTime];
         [outputFormatterss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         
         //    [outputFormatter setDateFormat:@"HH:mm"];
         NSDate * nowDATE = [NSDate date];
         
         [attachment addChild:senderName];
         [attachment addChild:senderID];
         [attachment addChild:senderImage];
         [attachment addChild:messageTypePhotoOrText];
         [messageToSend addAttributeWithName:@"type" stringValue:@"chat"];
         [messageToSend addAttributeWithName:@"id" stringValue:xmppStream.generateUUID];
         [messageToSend addAttributeWithName:@"to" stringValue:[jid full]];
         [body setStringValue:message];
         [messageToSend addChild:presence];
         [messageToSend addChild:body];
         [messageToSend addChild:attachment];
         [xmppStream sendElement:messageToSend];
         [self sendPushNotificatin:message receiver:receiverId];
         thread = (Chat *)[Chat create];
         thread.chat_Id = xmppStream.generateUUID ;
         thread.from_Jabber = jid.user ;
         thread.to_Jabber = myString ;
         thread.message = message ;
         thread.messageType = MessageTypeText ;
         thread.is_Mine = true ;
         thread.dateOfMessage = newDateString ;
         thread.imageUrl = @"" ;
         thread.isMessageSend = @"YES" ;
         [Chat save];

    }
    else {
        
        UIImage *compressedImage = [UIImage compressImage:message compressRatio:0.9f];
        NSString *filePath = [self getLocalFilePath:compressedImage];

        NSData *imageDatass = UIImageJPEGRepresentation(compressedImage, 1.0);
        NSDictionary *params = @{@"user_id"  : @"32",
                                 @"msg_id"   : @"134"
                                 };
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setTimeoutInterval:100];

        
        [manager POST:WEBSERVICE_UPLOAD_PICTURE parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageDatass name:@"file_image" fileName:[filePath lastPathComponent] mimeType:@"image/jpeg"];
            
            for (int i = 0; i < params.allKeys.count; ++i)  {
                
                NSString *key =   [[params allKeys] objectAtIndex:i];
                NSString *value = [params valueForKey:key];
                [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
              

            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableDictionary *dic = (NSMutableDictionary *)responseObject;
            NSDictionary *dict  =  [dic valueForKey:@"attachment_data"];
            fileOfSender = [NSXMLElement elementWithName:@"file" stringValue:[dict valueForKey:@"main_url"]];
            
            [attachment addChild:senderName];
            [attachment addChild:senderID];
            [attachment addChild:senderImage];
            [attachment addChild:fileOfSender] ;
            [attachment addChild:messageTypePhotoOrText];
            [messageToSend addAttributeWithName:@"type" stringValue:@"chat"];
            [messageToSend addAttributeWithName:@"id" stringValue:xmppStream.generateUUID];
//            NSDate * now = [NSDate date];
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH:mm"];
//            NSString *newDateString = [outputFormatter stringFromDate:now];
            
            [messageToSend addAttributeWithName:@"to" stringValue:[jid full]];
            
//            [body setStringValue:message];
            [messageToSend addChild:body];
            [messageToSend addChild:attachment];
            [xmppStream sendElement:messageToSend];
            
            [self sendPushNotificatin:@"Image" receiver:receiverId];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        NSDateFormatter *outputFormatterss = [[NSDateFormatter alloc] init];
        //    NSDate *date = [outputFormatter dateFromString:dateTime];
        [outputFormatterss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //    [outputFormatter setDateFormat:@"HH:mm"];
//        NSDate * nowDATE = [NSDate date];

            thread = (Chat *)[Chat create];
            thread.chat_Id = xmppStream.generateUUID ;
            thread.from_Jabber = jid.user ;
            thread.to_Jabber = myString ;
            thread.messageType = MessageTypeImage ;
            thread.is_Mine = true ;
            UIImage *saveCompresImage = [UIImage compressImage:message compressRatio:0.9f];
            thread.image             = UIImageJPEGRepresentation(saveCompresImage, 1.0);
            thread.message = @"Image";
            thread.dateOfMessage = newDateString ;
            thread.senderId = idOfUsers ;
            thread.sender_Image = obj.loginUserDP ;
            thread.sender_Name = obj.loginDisplayName ;
            thread.jaber_ID = jid.user ;
            [Chat save];
    }
    
    arrayOfRoaster = [Roaster fetchAll].mutableCopy ;
    NSPredicate *pNewsCard = [NSPredicate predicateWithFormat:@"jaber_ID == %@",jid.user];
    NSArray *filteredNewsCard = [arrayOfRoaster filteredArrayUsingPredicate:pNewsCard];
    _recentList = [Roaster fetchWithPredicate:[NSPredicate predicateWithFormat:@"jaber_ID == %@", _recentList.jaber_ID] sortDescriptor:nil fetchLimit:0].lastObject;
    

    if (filteredNewsCard.count > 0 ) {
        Roaster *objOfRecent = (Roaster *)[filteredNewsCard objectAtIndex:0];

        isContained = true ;
        if ([messageType isEqualToString:MessageTypeText]){
            objOfRecent.dateOfRecentMessage = now  ;
            objOfRecent.lastMessage = message ;
            [Roaster save];

        }else {
            objOfRecent.dateOfRecentMessage = now  ;
            objOfRecent.lastMessage = @"Image" ;
            [Roaster save];

        }

    }
    else {
        isContained = false ;
        
//        if(!_recentList)
//        {
            _recentList = (Roaster *) [Roaster create];
//        }
        
        
        _recentList.jaber_ID = jid.user ;
        _recentList.dateOfRecentMessage = now ;
        _recentList.lastMessage = message ;
        
        
        if (model){
            id  thumbnailImage = model.dpPathThumb ;

//            _recentList.sender_Name = model.firstName ;
            _recentList.sender_ID =  idOfUsers ;
            if ([messageType isEqualToString: MessageTypeText]){
                _recentList.message_Type = TEXT_MESSAGE ;
                
            }else {
                _recentList.message_Type = IMAGE_MESSAGE ;
                
            }
            
            if (thumbnailImage != [NSNull null]) {
                _recentList.sender_Image =  model.dpPathThumb ;
            } else {
                _recentList.sender_Image =  @" " ;
            }
            _recentList.jaber_ID = jid.user ;
            _recentList.sender_Name = [NSString stringWithFormat:@"%@ %@",model.firstName , model.lastName];

            
        } else if (attendese){
            
            id  thumbnailImages = attendese.speakerThumbImg ;

            _recentList.sender_ID =  idOfUsers ;
            if ([messageType isEqualToString: MessageTypeText]){
                _recentList.message_Type = TEXT_MESSAGE ;
                
            }else {
                _recentList.message_Type = IMAGE_MESSAGE ;
                
            }
            
            if (thumbnailImages != [NSNull null]) {
                _recentList.sender_Image =  attendese.speakerThumbImg ;
            } else {
                _recentList.sender_Image =  @" " ;
            }
            _recentList.jaber_ID = jid.user ;
            _recentList.sender_Name = [NSString stringWithFormat:@"%@ %@",attendese.speakerFirstName , attendese.speakerLastName];
            
        } else {
            _recentList.sender_ID =  idOfUsers ;
            id  thumbnailImage = _recentList.sender_Image ;

            if ([messageType isEqualToString: MessageTypeText]){
                _recentList.message_Type = TEXT_MESSAGE ;
                
            }else {
                _recentList.message_Type = IMAGE_MESSAGE ;
                
            }
            
            if (thumbnailImage != [NSNull null]) {
                _recentList.sender_Image =  _recentList.sender_Image ;
            } else {
                _recentList.sender_Image =  @" " ;
            }
            _recentList.jaber_ID = jid.user ;
            _recentList.sender_Name = _recentList.sender_Name ;

        }
      
        [Roaster save];
    }
        handler(thread , true);
}


-(void)sendPushNotificatin:(NSString*)message receiver:(NSString *)receiver{
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSDictionary *params = nil;
    params =        @{@"SenderId"                :     obj.loginUserID,
                      @"SenderName"              :     obj.loginDisplayName,
                      @"RecieverId"              :     receiver ,
                      @"Message"                 :     message ,
                      @"SentDate"                :     @"" ,
                      @"IsChat"                  :     @"true"
                      };
    [SVHTTPRequest POST:KBaseUrlForNotification parameters:params completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary*)response;
//            NSLog(@"what's here %@",dict);
            }
        else{
            
            NSLog(@"what's here %@",error.description);
            
            
        }
        
    }];
 
}


-(NSString*)getCurrentTime
{
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    [dateFormatter setDateFormat:@"MMddyyyyHHmmss"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
//    NSString *md5 = [dateInStringFormated MD5String];
    
    
    return dateInStringFormated;
    
    
}

-(NSString*)getLocalFilePath:(UIImage*)image{
    
    NSData *webData = UIImageJPEGRepresentation(image, 0.9);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",[self getCurrentTime]]];
    [webData writeToFile:localFilePath atomically:YES];
    
    return localFilePath;
}
#pragma mark- AlertDelegate

- (UIColor *)backgroundColorForMessageType:(TWMessageBarMessageType)type{
//    return [UIColor colorWithRed:0.0 green:0.482 blue:1.0 alpha:0.96]; //[UIColor colorWithRed:(52/255.0) green:133/255.0 blue:204/255.0 alpha:1.0];
    return  [UIColor colorWithRed:13/255.0 green:62/255.0 blue:91/255.0 alpha:1.0];
}

- (UIColor *)strokeColorForMessageType:(TWMessageBarMessageType)type{
    return  [UIColor blackColor];

//    return [UIColor colorWithRed:0.0f green:0.415f blue:0.803f alpha:1.0f];
}

- (UIImage *)iconImageForMessageType:(TWMessageBarMessageType)type{
    return self.image?:[UIImage imageNamed:@"ph_user_medium"];
}


#pragma mark- Establishing Connection

-(void)makeConnectionWithChatServer {
    
    // Setup the XMPP stream
    [self setupStream];
    [self setupConnection];
}

- (void)disconnectXMPP{
    [xmppStream removeDelegate:self];
    [xmppReconnect         deactivate];
    [xmppStream disconnect];
//    AppUtility.isOnlineForChat  = NO;

     xmppStream = nil;
}





#pragma mark - 
#pragma mark -
#pragma mark - XMPP Methods

-(void)setupConnection{
    if (![self connect]) {
        NSLog(@"Connection Failed");
    }
}

- (void)setupStream {
    if (!xmppStream) {
        NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");  
    }
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
//    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    xmppRosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
//    xmppStorage = [XMPPMessageArchivingCoreDataStorage   sharedInstance];
//    NSManagedObjectContext *moc = [xmppStorage mainThreadManagedObjectContext];
//
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject"
//                                                         inManagedObjectContext:moc];
//
//    xmppStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
//    _xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppStorage];
//    [_xmppMessageArchivingModule activate:xmppStream];
//    [_xmppMessageArchivingModule  addDelegate:self delegateQueue:dispatch_get_main_queue()];
//
//    NSFetchRequest *readrequest = [[NSFetchRequest alloc]init];
//    [readrequest setEntity:entityDescription];

    
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
//    xmppvCardAvatarModule   = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];
    
    xmppPing = [[XMPPPing alloc] init];
    _xmppAutoPing = [[XMPPAutoPing alloc] init];
    
//    _xmppAutoPing.respondsToQueries = true ;
//    _xmppAutoPing.pingInterval = 2.0 ;
//    _xmppAutoPing.pingTimeout = 4.0 ;
    
    
    //    xmppPing.activate(xmppStream)
    //
    //    xmppAutoPing = XMPPAutoPing()
    //    xmppAutoPing.pingInterval = 2 * 60
//       _xmppAutoPing.pingTimeout = 5.0 ;
    //    xmppAutoPing.activate(xmppStream)
    
//    xmppAutoPing =  [[XMPPAutoPing alloc] init];

    
    
    xmppMUC = [[XMPPMUC alloc] initWithDispatchQueue:dispatch_get_main_queue()] ;
    
    
    xmppLastActivity = [[XMPPLastActivity alloc] initWithDispatchQueue:dispatch_get_main_queue()];

    
    // Setup capabilities
    //
    // The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
    // Basically, when other clients broadcast their presence on the network
    // they include information about what capabilities their client supports (audio, video, file transfer, etc).
    // But as you can imagine, this list starts to get pretty big.
    // This is where the hashing stuff comes into play.
    // Most people running the same version of the same client are going to have the same list of capabilities.
    // So the protocol defines a standardized way to hash the list of capabilities.
    // Clients then broadcast the tiny hash instead of the big list.
    // The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
    // and also persistently storing the hashes so lookups aren't needed in the future.
    //
    // Similarly to the roster, the storage of the module is abstracted.
    // You are strongly encouraged to persist caps information across sessions.
    //
    
//    xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
//    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];
//
//    xmppCapabilities.autoFetchHashedCapabilities = YES;
//    xmppCapabilities.autoFetchNonHashedCapabilities = NO;
//    xmppPing.respondsToQueries = YES;
    
    
    
//    xmppPing = XMPPPing()
//
    
//    self.xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    
//    self.xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    self.xmppAutoPing.pingInterval = 5.f; // default is 60
    self.xmppAutoPing.pingTimeout = 5.f; // default is 10

    
//    xmppAutoPing.pingInterval = 10.0 ;

    
//    self.xmppPing.pin = 25.f; // default is 60
//    self.xmppPing.pingTimeout = 10.f; // default is 10
    
    
    // Activate xmpp modules
    
    [xmppReconnect          activate:xmppStream];
    [xmppRoster             activate:xmppStream];
    [xmppvCardTempModule    activate:xmppStream];
    [xmppvCardAvatarModule  activate:xmppStream];
    [xmppCapabilities       activate:xmppStream];
    [xmppPing               activate:xmppStream];
    [xmppRoom               activate:xmppStream];
    [_xmppAutoPing          activate:xmppStream];
    [xmppStreamManagement   activate:xmppStream];
    [self.xmppMUC           activate:xmppStream];
    [xmppLastActivity       activate:xmppStream];


    
//    [xmppRoom joinRoomUsingNickname:@"keithoys" history:nil];

    
    
    // Add ourself as a delegate to anything we may be interested in
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppMUC addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppStreamManagement addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppLastActivity addDelegate:self delegateQueue:dispatch_get_main_queue()];

    
    
    //    xmppStreamManagement = XMPPStreamManagement(storage: XMPPStreamManagementMemoryStorage(), dispatchQueue: dispatch_get_main_queue())
    //    xmppStreamManagement.autoResume = true
    //    xmppStreamManagement.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    //    xmppStreamManagement.activate(xmppStream)

    

    
    [xmppStream setHostName:@"132.148.144.24"];
    [xmppStream setHostPort:5222];
    
//    [xmppStream setHostName:@"202.125.144.234"];
//    [xmppStream setHostPort:8080];

    
    // Optional:
    //
    // Replace me with the proper domain and port.
    // The example below is setup for a typical google talk account.
    //
    // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
    // For example, if you supply a JID like 'user@quack.com/rsrc'
    // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
    // 
    // If you don't specify a hostPort, then the default (5222) will be used.
    
    
    // You may need to alter these settings depending on the server eyou're connecting to
    

    
    
//    XMPPMessageDeliveryReceipts* xmppMessageDeliveryRecipts = [[XMPPMessageDeliveryReceipts alloc] initWithDispatchQueue:dispatch_get_main_queue()];
//    xmppMessageDeliveryRecipts.autoSendMessageDeliveryReceipts = YES;
//    xmppMessageDeliveryRecipts.autoSendMessageDeliveryRequests = YES;
//    [xmppMessageDeliveryRecipts activate:xmppStream];

}

- (void)teardownStream {

    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppReconnect          deactivate];
    [xmppRoster             deactivate];
    [xmppvCardTempModule    deactivate];
    [xmppvCardAvatarModule  deactivate];
    [xmppCapabilities       deactivate];
    [xmppPing               deactivate];
    [xmppMUC           deactivate];
    
    [xmppStream disconnect];
    
    xmppStream                 = nil;
    xmppReconnect              = nil;
    xmppRoster                 = nil;
    xmppRosterStorage          = nil;
    xmppvCardStorage           = nil;
    xmppvCardTempModule        = nil;
    xmppvCardAvatarModule      = nil;
    xmppCapabilities           = nil;
    xmppCapabilitiesStorage    = nil;
    xmppPing                   = nil;
    xmppMUC                    = nil;
    AppUtility.isOnlineForChat = NO  ;
    
}


- (BOOL)connect {
    if (![xmppStream isDisconnected]) {
        return YES;
    }

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    NSString *myString = [defaults stringForKey:@"UserPass"];
    NSString *myJID         = [NSString stringWithFormat:@"%@@opchat.ibexglobal.com", obj.loginUserID]; // live pass
//    NSString *myJID           = [NSString stringWithFormat:@"%@@ibexglobal.com", obj.loginUserID]; // local pass

    NSString *kPassword     = myJID;
    if (myJID == nil || kPassword == nil) {
        return NO;
    }
    password   = kPassword ;
    NSError *error = nil;
    NSString *resource = [[UIDevice currentDevice] name];
    XMPPJID *jid = [XMPPJID jidWithString:myJID resource:nil];
    [xmppStream setMyJID:jid];
//    password   = md5Password;
    error  = nil;
    
    
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"Error connecting: %@", error);
        return NO;
    }
    return YES;
}
- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];// type="available" is implicit
    NSXMLElement *element =  [NSXMLElement elementWithName:@"priority" numberValue:@(24)];
    [presence addChild:element];
    NSXMLElement *nextText = [NSXMLElement elementWithName:@"text" numberValue:@(4)];
    [presence addChild:nextText];
    [[self xmppStream] sendElement:presence];
    AppUtility.isOnlineForChat  = YES;
}





- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    AppUtility.isOnlineForChat  = NO;
}

- (void)getPresenceForJid:(NSString *)jidStr{
//    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    XMPPPresence *presence =  [XMPPPresence presenceWithType:@"available"];// type="available" is implicit
//    NSXMLElement *element = [NSXMLElement elementWithName:@"priority" xmlns:@"24"];
//    [presence addChild:element];
    [[self xmppStream] sendElement:presence];
}

/////////////////////////////////////////////////////////////
#pragma mark - XMPPRoom Delegate 
////////////////////////////////////////////////////////////

- (void)ConfigureNewRoom
{
    NSLog(@"The Room is Configure After 5 Secs");
    [xmppRoom fetchConfigurationForm];
    [xmppRoom configureRoomUsingOptions:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket { //1
    

}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    
    
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"print it");
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    //    NSDate *date = [outputFormatter dateFromString:dateTime];
//    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//    //    [outputFormatter setDateFormat:@"HH:mm"];
//    NSDate * now = [NSDate date];
//
//    NSString *newDateString = [outputFormatter stringFromDate:now];
//
//    NSString *myString = [defaults stringForKey:@"jID"];
//
//    _chatThread = (Chat *)[Chat create];
//    _chatThread.chat_Id = xmppStream.generateUUID ;
//    _chatThread.from_Jabber = jabberIDOfUser ;
//    _chatThread.to_Jabber = myString ;
//    _chatThread.message = messageText ;
//    _chatThread.messageType = MessageTypeText ;
//    _chatThread.is_Mine = true ;
//    _chatThread.dateOfMessage = newDateString ;
//    _chatThread.imageUrl = @"" ;
//    self.chatThread.isMessageSend = @"YES" ;
//    [Chat save];

//    [Chat save];
//    if ([message hasReceiptRequest]) {
//        NSLog(@"Send it ");
//    } else {
//        NSLog(@"Not send ");
//    }
    
    
}
//
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    

}
//
//- (void)xmppStream:(XMPPStream *)sender socketWillConnect:(GCDAsyncSocket *)socket
//{
//    // Tell the socket to stay around if the app goes to the background (only works on apps with the VoIP background flag set)
//    [socket performBlock:^{
//        [socket enableBackgroundingOnSocket];
//    }];
//}



- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"Registration with XMPP Successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    isRegister = true ;
    [alert show];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
    DDXMLElement *errorXML = [error elementForName:@"error"];
    NSString *errorCode  = [[errorXML attributeForName:@"code"] stringValue];
    
    NSString *regError = [NSString stringWithFormat:@"ERROR :- %@",error.description];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration with XMPP   Failed!" message:regError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    if([errorCode isEqualToString:@"409"]){
        
        [alert setMessage:@"Username Already Exists!"];
        
    }
    [alert show];
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *expectedCertName = [xmppStream.myJID domain];
    if (expectedCertName)
    {
        settings[(NSString *) kCFStreamSSLPeerName] = expectedCertName;
    }
    
    if (customCertEvaluation)
    {
        settings[GCDAsyncSocketManuallyEvaluateTrust] = @(YES);
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler {
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    dispatch_queue_t bgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(bgQueue, ^{
        
        SecTrustResultType result = kSecTrustResultDeny;
        OSStatus status = SecTrustEvaluate(trust, &result);
        
        if (status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)) {
            completionHandler(YES);
        }
        else {
            completionHandler(NO);
        }
    });
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender {
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}



- (void)xmppStreamDidConnect:(XMPPStream *)sender { //2
        isXmppConnected         = YES;
        NSError *authenticateError = nil;
    if (![[self xmppStream] authenticateWithPassword:password error:&authenticateError]) {
         NSLog(@"Authentication error: %@", authenticateError.localizedDescription);
        //        DDLogError(@"Error authenticating: %@", error);
   
    
    }
    
}

-(void)lastSeen:(NSString *) jib {
    
    
//    -(void)getlasttimeActivity:(NSString*)userId
//    {
    
    
    
//       XMPPJID *touse = [XMPPJID  jidWithString:@"20@ibexglobal.com/djxw1lfkg"];
//
////        XMPPJID *touse= [XMPPJID jidWithString:jib];
//        XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:touse];
//        [iq addAttributeWithName:@"id" stringValue:@"last"];
//        //[iq addAttributeWithName:@"from" stringValue:@"sumeet@app.kinkey.com.au"];
//        [iq addAttributeWithName:@"from" stringValue:@"20@ibexglobal.com/djxw1lfkg"];
//        [iq addAttributeWithName:@"to" stringValue:@"14@ibexglobal.com"];
//
//        NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
//        [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:last"];
//        [iq addChild:query];
//        NSLog(@"checking IQ==%@",iq);
//        [xmppStream sendElement:iq];
//        [xmppLastActivity sendLastActivityQueryToJID:touse withTimeout:3.0];

//        [xmppLastActivity sendLastActivityQueryToJID:touse] ;
}

//- (void)xmppLastActivity:(XMPPLastActivity *)sender didReceiveResponse:(XMPPIQ *)response {
//
//    NSLog(@"last activity: %lu", (unsigned long)[response lastActivitySeconds]);
//    NSLog(@"response: %@", response);
//
//}
//
//- (NSUInteger)numberOfIdleTimeSecondsForXMPPLastActivity:(XMPPLastActivity *)sender queryIQ:(XMPPIQ *)iq currentIdleTimeSeconds:(NSUInteger)idleSeconds {
//        return 1.0 ;
//
//}

- (void)xmppLastActivity:(XMPPLastActivity *)sender didNotReceiveResponse:(NSString *)queryID dueToTimeout:(NSTimeInterval)timeout {
    NSLog(@"Print its time");
}


    
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender { //3
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

    [self goOnline];
    

}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid{
    NSLog(@"JId : %@", [jid full]);
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:[jid full] forKey:@"jID"];

    NSLog(@"Vcard Name : %@", [vCardTemp name]);
    NSLog(@"Vcard Nick : %@", [vCardTemp nickname]);
//    UIImage *image = [UIImage imageWithData:[vCardTemp photo]];
//    [NOTIFICATION_CENTER postNotificationName:@"VcardReceived" object:jid userInfo:@{@"vcard":vCardTemp}];
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    NSLog(@"xmppvCardTempModuleDidUpdateMyvCard");
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error{
    NSLog(@"failedToUpdateMyvCard");
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

    [xmppStream registerWithPassword:password error:nil];
    NSError * err = nil;
    
    if(![[self xmppStream] registerWithPassword:password error:&err])
    {
        NSLog(@"Error registering: %@", err);
    }

    
    if(![[self xmppStream] registerWithPassword:password error:&err])
    {
        NSLog(@"Error registering: %@", err);
    }
    

    dispatch_async(dispatch_get_main_queue(), ^{
        [self teardownStream];
        [self setupConnection];
    });
}



- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    id element                      = [message elementForName:@"delay"];
    NSString *delayed               = nil;
    if ([element isKindOfClass:[NSXMLElement class]]) {
        delayed                     = [[message elementForName:@"delay"] stringValue];
    }else{
        delayed                     = (NSString *)element;
    }

    if ([message hasReceiptRequest]) {

    
    }
    
//    NSLog(@"print it %@", message.body);
    
    DDXMLElement *messageExtra = [message elementForName:@"msg_extras"];
    arrayOfChat = [[NSMutableArray alloc] init];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSData *data;
    if ([[message type] isEqualToString:@"groupchat"]) {    // chat should not deal with groupchat
        NSDateFormatter *outputFormatterss = [[NSDateFormatter alloc] init];
        //    NSDate *date = [outputFormatter dateFromString:dateTime];
        [outputFormatterss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //    [outputFormatter setDateFormat:@"HH:mm"];
        NSDate * now = [NSDate date];

        
        NSString *meessageID         =  [[messageExtra elementForName:@"id"] stringValue] ;
        NSString *senderNameOfUser   =  [[messageExtra elementForName:@"sender_name"] stringValue] ;
        NSString *receiverImage      =  [[messageExtra elementForName:@"sender_image"] stringValue] ;
        NSString *messageType        =  [[messageExtra elementForName:@"msg_type"] stringValue] ;
        NSString *fileContent        =  [[messageExtra elementForName:@"file"] stringValue] ;
        
        if ([messageType isEqualToString:@"2"]){
            
            arrayOfGroupMessages = [GroupMessage fetchAll].mutableCopy ;
            NSPredicate *pNewsCard = [NSPredicate predicateWithFormat:@"packet_Id == %@",meessageID];
            NSArray *filteredNewsCard = [arrayOfGroupMessages filteredArrayUsingPredicate:pNewsCard];
            
            NSString *groupText         =        [[message elementForName:@"body"] stringValue];
            NSString *fromJbID          =        [[message attributeForName:@"from"] stringValue];
            NSArray *arr                =        [fromJbID componentsSeparatedByString:@"/"];
            NSString *groupJabberID     =        [arr objectAtIndex:0];
            NSString *myUserID          =        [arr objectAtIndex:1];
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            arrayOfChat = [ChatRooms fetchAll].mutableCopy ;

            [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *currentTime = [outputFormatter stringFromDate:[NSDate date]];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            NSPredicate *pNewsCardsss = [NSPredicate predicateWithFormat:@"roomJbID == %@",groupJabberID];
            NSArray *filteredNewsCardss = [arrayOfChat filteredArrayUsingPredicate:pNewsCardsss];
            _roomChat = [ChatRooms fetchWithPredicate:[NSPredicate predicateWithFormat:@"roomJbID == %@", groupJabberID] sortDescriptor:nil fetchLimit:1].lastObject;

            if (filteredNewsCard.count > 0){
                
            } else {
                ChatRooms *objOfRecent = (ChatRooms *)[filteredNewsCardss objectAtIndex:0];
                objOfRecent.dateOfRecentMessage = now  ;
                objOfRecent.lastMessage = @"Image" ;
                [ChatRooms save];

                _groupMessage = (GroupMessage *)[GroupMessage create];
                _groupMessage.packet_Id               = meessageID ;
                _groupMessage.messageOfGroup          =  @"Image";
                _groupMessage.group_Jabber_Id         = groupJabberID ;
                _groupMessage.dateAndTimeOfMessage    = currentTime ;
                _groupMessage.fromJabber_Id           = myUserID   ;
                _groupMessage.imageUrl                = fileContent ;
                _groupMessage.messageType             = @"2" ;
                _groupMessage.image                   =  receiverImage ;
                
                if ([obj.loginUserID isEqualToString:myUserID]){
                    
                    _groupMessage.is_Mine = true ;
                    _groupMessage.senderName =  senderNameOfUser ;
                    
                } else {
                    _groupMessage.is_Mine = false  ;
                    _groupMessage.senderName =  senderNameOfUser ;
                    //                            [TWMessageBarManager sharedInstance].styleSheet = self;
                    //                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                    //                            [[TWMessageBarManager sharedInstance] showMessageWithTitle:senderNameOfUser description:groupText type:TWMessageBarMessageTypeSuccess statusBarStyle:UIStatusBarStyleDefault callback:^{
                    //
                    //                            }];
                    //                        });
                    
                    
                    
                }
                
                [GroupMessage save];
                [NotifCentre postNotificationName:kGroupChatMessageReceived object:_groupMessage];


                
        }
        }
            else if ([messageType isEqualToString:@"1"]) {
            arrayOfGroupMessages = [GroupMessage fetchAll].mutableCopy ;
            NSPredicate *pNewsCard = [NSPredicate predicateWithFormat:@"packet_Id == %@",meessageID];
            NSArray *filteredNewsCard = [arrayOfGroupMessages filteredArrayUsingPredicate:pNewsCard];
            
            NSString *groupText         =       [[message elementForName:@"body"] stringValue];
            NSString *fromJbID          =       [[message attributeForName:@"from"] stringValue];
            NSArray *arr =                      [fromJbID componentsSeparatedByString:@"/"];
            NSString *groupJabberID     =       [arr objectAtIndex:0];
            NSString *myUserID          =       [arr objectAtIndex:1];
            //        if ([arr objectAtIndex:1 == nil]){
            //            myUserID = @"";
            //        } else {
            //
            //
            //        }
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *currentTime = [outputFormatter stringFromDate:[NSDate date]];
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
            arrayOfChat = [ChatRooms fetchAll].mutableCopy ;
             NSPredicate *pNewsCardsss = [NSPredicate predicateWithFormat:@"roomJbID == %@",groupJabberID];
             NSArray *filteredNewsCardss = [arrayOfChat filteredArrayUsingPredicate:pNewsCardsss];
              _roomChat = [ChatRooms fetchWithPredicate:[NSPredicate predicateWithFormat:@"roomJbID == %@", groupJabberID] sortDescriptor:nil fetchLimit:1].lastObject;
                
//                if (filteredNewsCardss.count > 0) {
//                    ChatRooms *objOfRecent = (ChatRooms *)[filteredNewsCardss objectAtIndex:0];
////                    isContained = true ;
//                    objOfRecent.dateOfRecentMessage = now  ;
//                    objOfRecent.lastMessage = groupText ;
//                    [ChatRooms save];
//                }
//                [NotifCentre postNotificationName:kGroupChatUIUpdate object:nil];


                if (groupText == nil){
                
                } else {
                    if (filteredNewsCard.count > 0){

                        
                        
                    } else {
                       
                        
                        ChatRooms *objOfRecent = (ChatRooms *)[filteredNewsCardss objectAtIndex:0];
                        objOfRecent.dateOfRecentMessage = now  ;
                        objOfRecent.lastMessage = groupText ;
                        [ChatRooms save];

                        if(groupText.length == 0){
                            
                        
                        } else {
                            _groupMessage = (GroupMessage *)[GroupMessage create];
                            
                        }
                        _groupMessage.packet_Id               = meessageID ;
                        _groupMessage.messageOfGroup          = groupText;
                        _groupMessage.group_Jabber_Id         = groupJabberID ;
                        _groupMessage.dateAndTimeOfMessage    = currentTime ;
                        _groupMessage.fromJabber_Id           = myUserID   ;
                        _groupMessage.image                   = receiverImage ;

                        _groupMessage.messageType    = @"1" ;
                        
                        if ([obj.loginUserID isEqualToString:myUserID]){
                            
                            _groupMessage.is_Mine = true ;
                            _groupMessage.senderName =  senderNameOfUser ;
                            
                        } else {
                            _groupMessage.is_Mine = false  ;
                            _groupMessage.senderName =  senderNameOfUser ;
                            //                            [TWMessageBarManager sharedInstance].styleSheet = self;
                            //                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            //                            [[TWMessageBarManager sharedInstance] showMessageWithTitle:senderNameOfUser description:groupText type:TWMessageBarMessageTypeSuccess statusBarStyle:UIStatusBarStyleDefault callback:^{
                            //
                            //                            }];
                            //                        });
                            
                            
                            
                        }
                        
                        [GroupMessage save];
                        if(groupText.length == 0){
                            
                        }else {
                            [NotifCentre postNotificationName:kGroupChatMessageReceived object:_groupMessage];
                            
                        }
                        
                    }
                }
           
            

            }
            else if ([messageType isEqualToString:@"3"]) {
                arrayOfGroupMessages = [GroupMessage fetchAll].mutableCopy ;
                NSPredicate *pNewsCard = [NSPredicate predicateWithFormat:@"packet_Id == %@",meessageID];
                NSArray *filteredNewsCard = [arrayOfGroupMessages filteredArrayUsingPredicate:pNewsCard];
                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];

                NSString *groupText  ;

                NSString *isUserJoin        =  [[messageExtra elementForName:@"action_id"] stringValue] ;
                NSString *userId            =  [[messageExtra elementForName:@"actioned_user_id"] stringValue] ;

                
                NSString *fromJbID          =       [[message attributeForName:@"from"] stringValue];
                NSArray *arr                =       [fromJbID componentsSeparatedByString:@"/"];
                NSString *groupJabberID     =       [arr objectAtIndex:0];
                NSString *myUserID          =       [arr objectAtIndex:1];
                
                if ([isUserJoin isEqualToString:@"5"]) {
                    if ([userId isEqualToString:[NSString stringWithFormat:@"%@", obj.loginUserID]]) {
                        groupText = @"You Created the group" ;
                    } else {
                        groupText   =       [[message elementForName:@"body"] stringValue];
                    }

                }
                if ([isUserJoin isEqualToString:@"2"]) {
                    if ([userId isEqualToString:[NSString stringWithFormat:@"%@", obj.loginUserID]]) {
                        groupText = @"You  left this group" ;
                    } else {
                        groupText   =       [[message elementForName:@"body"] stringValue];
                    }
                    
                }
                if ([isUserJoin isEqualToString:@"3"]) {
                    if ([userId isEqualToString:[NSString stringWithFormat:@"%@", obj.loginUserID]]) {
                              groupText = @"You have been block by group admin" ;
                    } else {
                        groupText   =       [[message elementForName:@"body"] stringValue];
                    }
                }
                if ([isUserJoin isEqualToString:@"1"]) {
                    if ([userId isEqualToString:[NSString stringWithFormat:@"%@", obj.loginUserID]]) {
                        groupText = @"You have been added in this group" ;
                    } else {
                        groupText   =       [[message elementForName:@"body"] stringValue];
                    }
                    
                }
                if ([isUserJoin isEqualToString:@"0"]) {
//
                    NSMutableArray *array = [[userId componentsSeparatedByString:@","] mutableCopy];
                    
                    if ([array containsObject:obj.loginDisplayName]) {
                        NSString *member = [userId stringByReplacingOccurrencesOfString: obj.loginDisplayName
                                                                                          withString:@"You"];
                        
                        groupText = [NSString stringWithFormat:@"%@ %@", member , @"added in this group"];
                    } else {
                        groupText   =       [[message elementForName:@"body"] stringValue];

                    }
//                    if ([userId isEqualToString:[NSString stringWithFormat:@"%@", obj.loginUserID]]) {
//                        groupText = @"you have been block by group admin" ;
//                    } else {
//                        groupText   =       [[message elementForName:@"body"] stringValue];
//                    }
                    
                }
                
                //        if ([arr objectAtIndex:1 == nil]){
                //            myUserID = @"";
                //        } else {
                //
                //
                //        }
                
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *currentTime = [outputFormatter stringFromDate:[NSDate date]];
//                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//                loginResponse *obj = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
                arrayOfChat = [ChatRooms fetchAll].mutableCopy ;
                NSPredicate *pNewsCardsss = [NSPredicate predicateWithFormat:@"roomJbID == %@",groupJabberID];
                NSArray *filteredNewsCardss = [arrayOfChat filteredArrayUsingPredicate:pNewsCardsss];
                _roomChat = [ChatRooms fetchWithPredicate:[NSPredicate predicateWithFormat:@"roomJbID == %@", groupJabberID] sortDescriptor:nil fetchLimit:1].lastObject;
                
                //                if (filteredNewsCardss.count > 0) {
                //                    ChatRooms *objOfRecent = (ChatRooms *)[filteredNewsCardss objectAtIndex:0];
                ////                    isContained = true ;
                //                    objOfRecent.dateOfRecentMessage = now  ;
                //                    objOfRecent.lastMessage = groupText ;
                //                    [ChatRooms save];
                //                }
                //                [NotifCentre postNotificationName:kGroupChatUIUpdate object:nil];
                
                
                if (groupText == nil){
                    
                } else {
                    if (filteredNewsCard.count > 0){
                        
                        
                        
                    } else {
                        ChatRooms *objOfRecent = (ChatRooms *)[filteredNewsCardss objectAtIndex:0];
                        objOfRecent.dateOfRecentMessage = now  ;
                        objOfRecent.lastMessage = groupText ;
                        [ChatRooms save];
                        
                        if(groupText.length == 0){
                            
                            
                        } else {
                            _groupMessage = (GroupMessage *)[GroupMessage create];
                            
                        }
                        _groupMessage.packet_Id               = meessageID ;
                        _groupMessage.messageOfGroup          = groupText;
                        _groupMessage.group_Jabber_Id         = groupJabberID ;
                        _groupMessage.dateAndTimeOfMessage    = currentTime ;
                        _groupMessage.fromJabber_Id           = myUserID   ;
                        _groupMessage.image                   = receiverImage ;
                        
                        _groupMessage.messageType    = @"3" ;
                        
                        if ([obj.loginUserID isEqualToString:myUserID]){
                            
                            _groupMessage.is_Mine = true ;
                            _groupMessage.senderName =  senderNameOfUser ;
                            
                        } else {
                            _groupMessage.is_Mine = false  ;
                            _groupMessage.senderName =  senderNameOfUser ;
                            //                            [TWMessageBarManager sharedInstance].styleSheet = self;
                            //                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            //                            [[TWMessageBarManager sharedInstance] showMessageWithTitle:senderNameOfUser description:groupText type:TWMessageBarMessageTypeSuccess statusBarStyle:UIStatusBarStyleDefault callback:^{
                            //
                            //                            }];
                            //                        });
                            
                            
                            
                        }
                        
                        [GroupMessage save];
                        if(groupText.length == 0){
                            
                        }else {
                            [NotifCentre postNotificationName:kGroupChatMessageReceived object:_groupMessage];
                            
                        }
                        
                    }
                }
                
            
            }

        if ([[message elementForName:@"newfile"] stringValue].length <= 0 &&
            [[message elementForName:@"subject"] stringValue].length > 0)
            

        {
//
            
            
//            [xmppStream Rece]
//            [xmppcon updateRoomSubjectWithData:message];
        }
        
//        [xmppcon ReciveMessage:sender didReceiveMessage:message];
        
        return;
        
    }
  else if ([[message type] isEqualToString:@"chat"])   {
  
      NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
      //    NSDate *date = [outputFormatter dateFromString:dateTime];
      [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
      
      //    [outputFormatter setDateFormat:@"HH:mm"];
      NSDate * now = [NSDate date];
      
      NSString *newDateString = [outputFormatter stringFromDate:now];

      
//    if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
//        data = [[NSData alloc] initWithBase64EncodedString:message.body options:kNilOptions];  // iOS 7+
//    } else {
//        data = [[NSData alloc] initWithBase64Encoding:message.body];                           // pre iOS7
//    }
    
    
    arrayOfRoaster = [[NSMutableArray alloc] init];
    
    for (Chat *obj in message.accessibilityElements) {
        NSLog(@"print it %@", obj.message);
        
        
    }
    NSString *delayed               = nil;
    if ([element isKindOfClass:[NSXMLElement class]]) {
        delayed                     = [[message elementForName:@"delay"] stringValue];
    }else{
        delayed                     = (NSString *)element;
    }
    BOOL flag = true;
    if ([delayed isEqualToString:@"Offline Storage"]) { // [delayed isEqualToString:@"Offline Storage"] || delayed == nil , [delayed intValue] < 2
        flag = false;
    }

    if([delayed intValue] < 2){
        if (![message.type isEqualToString:@"error"]) {
            NSString *messageText        =  [[message elementForName:@"body"] stringValue];
            NSString *receiverName       =  [[messageExtra elementForName:@"sender_name"] stringValue] ;
            NSString *senderID           =  [[messageExtra elementForName:@"sender_id"] stringValue] ;
            NSString *receiverImage      =  [[messageExtra elementForName:@"sender_image"] stringValue] ;
            NSString *messageType        =  [[messageExtra elementForName:@"msg_type"] stringValue] ;
            NSString *fileContent        =  [[messageExtra elementForName:@"file"] stringValue] ;
            
            MOMessage *soMessage             = [[MOMessage alloc] init];
            soMessage.messageFromMe          = @"NO";
            soMessage.text                   = messageText  ;
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];

//            NSString *dateTime      = [[message elementForName:@"date"] stringValue];
//            NSDate *date = [outputFormatter dateFromString:dateTime];
//            [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

//            NSDate *today = [NSDate date];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
//            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//            NSString *currentTime = [outputFormatter stringFromDate:today];
            
//            NSString *currentTime = [outputFormatter stringFromDate:[NSDate date]];
//
////            NSLog(@"User's current time in their preference format:%@",currentTime);
//
//            NSString *newDateString = [outputFormatter stringFromDate:date];
            soMessage.type              = @"text";
            soMessage.text              = messageText;
            NSString *fromUserJID ;
            NSString *toJId ;
            if ([messageType isEqualToString:@"1"]){
                _userChat = (Chat *)[Chat create];
                _userChat.chat_Id = xmppStream.generateUUID ;
                 fromUserJID = message.from.user ;
                 toJId         =  message.to.user;
                _userChat.from_Jabber = fromUserJID ;
                _userChat.to_Jabber   =   toJId ;
                _userChat.message     = messageText ;
                _userChat.dateOfMessage = newDateString ;
                _userChat.messageType = MessageTypeText ;
                _userChat.is_Mine = false ;
                _userChat.imageUrl = @" ";
//                _userChat.senderId = senderID ;
//                _userChat.sender_Image = receiverImage ;
//                _userChat.sender_Name = receiverName  ;
//                _userChat.jaber_ID = fromUserJID ;

                
                NSLog(@"print it ");
            }
            else {

                UIImage *image = [UIImage imageWithData:data];

                _userChat = (Chat *)[Chat create];
                _userChat.chat_Id = xmppStream.generateUUID ;
                 fromUserJID = message.from.user ;
                 toJId       =  message.to.user;

                _userChat.from_Jabber   = fromUserJID ;
                _userChat.to_Jabber     =   toJId ;
                _userChat.message       = @"Image";
                _userChat.messageType   = MessageTypeImage ;
                _userChat.is_Mine = false ;
                _userChat.imageUrl      = fileContent ;
                _userChat.dateOfMessage = newDateString ;
//                _userChat.senderId = senderID ;
//                _userChat.sender_Image = receiverImage ;
//                _userChat.sender_Name = receiverName  ;
//                _userChat.jaber_ID = fromUserJID ;


            }

            if (appDelegate.isViewVisible == true) {
                _userChat.messageStatus = @"Unread";
                
                [TWMessageBarManager sharedInstance].styleSheet = self;
                [NotifCentre postNotificationName:kChatNotificationReceived object:nil];
//                appDelegate.badgeValueCount
//                int myInt = 0 ;
//                appDelegate.badgeValueCount = [NSString stringWithFormat:@"%d",++myInt];
                if ([messageType isEqualToString: @"1"]){
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
//                        - (void)showMessageWithTitle:(NSString *)title description:(NSString *)description type:(TWMessageBarMessageType)type duration:(CGFloat)duration callback:(void (^)())callback
                        
                        
                        [[TWMessageBarManager sharedInstance] showMessageWithTitle:receiverName description:messageText type:TWMessageBarMessageTypeSuccess statusBarStyle:UIStatusBarStyleDefault callback:^{
                            
                            
                        }];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [[TWMessageBarManager sharedInstance] showMessageWithTitle:receiverName description:@"Image" type:TWMessageBarMessageTypeSuccess statusBarStyle:UIStatusBarStyleDefault callback:^{
                            
                            
                        }];
                    });
                }
               
//                if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
//                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//                    [localNotification setUserInfo:@{@"message": messageText,
//                                                     @"did":  @"HEllo",
//                                                     @"contactName": @"Speaker",
//                                                     @"contactRecordId": @"1"}];
//                    localNotification.alertAction = @"Ok";
//                    localNotification.alertBody = [NSString stringWithFormat:@"%@ : %@",@"Hello", messageText];
//
//                    localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
//                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//
//                }
              
            }
            else {
                _userChat.messageStatus = @"read";
                
            }
            
            [Chat save];

            
            NSDateFormatter *outputFormatterss = [[NSDateFormatter alloc] init];
            //    NSDate *date = [outputFormatter dateFromString:dateTime];
            [outputFormatterss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            //    [outputFormatter setDateFormat:@"HH:mm"];
            NSDate * now = [NSDate date];
            
            NSString *currentDateAndTime = [outputFormatter stringFromDate:now];

            arrayOfRoaster = [Roaster fetchAll].mutableCopy ;
            NSPredicate *pNewsCard = [NSPredicate predicateWithFormat:@"jaber_ID == %@",fromUserJID];
            NSArray *filteredNewsCard = [arrayOfRoaster filteredArrayUsingPredicate:pNewsCard];
            _recentList = [Roaster fetchWithPredicate:[NSPredicate predicateWithFormat:@"jaber_ID == %@", _recentList.jaber_ID] sortDescriptor:nil fetchLimit:1].lastObject;

            if (filteredNewsCard.count > 0 ) {
                Roaster *objOfRecent = (Roaster *)[filteredNewsCard objectAtIndex:0];
                isContained = true ;
                
                if ([messageType isEqualToString:@"1"]) {
                    objOfRecent.lastMessage = messageText ;

                } else {
                    objOfRecent.lastMessage = @"Image" ;

                }
                objOfRecent.dateOfRecentMessage = now  ;
                [Roaster save];
            }
            
//            if (filteredNewsCard.count > 0) {
//                isContained = true ;
////                _recentList = [Roaster fetchAll] ;
//
//                _recentList.dateOfRecentMessage = now  ;
//                _recentList.lastMessage = messageText ;
//                [Roaster save];
//
//
//            }
            else
            {
                isContained = false ;
                _recentList = (Roaster *) [Roaster create];
                _recentList.jaber_ID = fromUserJID ;
                _recentList.sender_Name =  receiverName ;
                _recentList.sender_ID =  senderID ;
                _recentList.dateOfRecentMessage = now  ;
                _recentList.lastMessage = messageText ;
            
                if ([messageType isEqualToString: MessageTypeText]){
                    _recentList.message_Type = TEXT_MESSAGE ;

                }else {
                    _recentList.message_Type = IMAGE_MESSAGE ;

                }

//                id  thumbnailImage = receiverImage ;

                if ([receiverImage isEqual: [NSNull null] ]) {
                    _recentList.sender_Image =  receiverImage ;
                } else {
                    _recentList.sender_Image =  @" " ;
                }
//                _recentList.jaber_ID = fromUserJID;
//                _recentList.sender_Name    =  senderName ;
                [Roaster save];
            }
            
            if ([appDelegate.fromJabberId isEqualToString:fromUserJID]){
                [NotifCentre postNotificationName:kChatMessageReceived object:_userChat];

            }
                [NotifCentre postNotificationName:KUpdateUIOfMessage object:_recentList];

            
                
                
//                if (messageText) {
//
//                 [self saveIncomingMessage:message soMessage:soMessage messageSender:messageSender showLocalNotification:true];
                }
        }
        }
    }


-(void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message
{
    arrayOfGroupList = [[NSMutableArray alloc] init];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    loginResponse *objOfUser = (loginResponse *) [defaults rm_customObjectForKey:@"UserData"];
    

    
    NSXMLElement * x = [message elementForName:@"x" xmlns:XMPPMUCUserNamespace];
    NSXMLElement * invite  = [x elementForName:@"invite"];
    NSXMLElement * invite1  = [invite elementForName:@"reason"];

    if (invite1.stringValue!=nil || ![invite1.stringValue isEqualToString:@""])
    {
//        if ([string containsString:@"bla"]) {
//            NSLog(@"string contains bla!");
//        } else {
//            NSLog(@"string does not contain bla");
//        }
        
//        NSData *data = [invite1.stringValue dataUsingEncoding:NSUTF8StringEncoding];
//        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//            NSLog(@"%@",json);

//        NSString *name = @"Tómas";
//        cell.text = [name uppercaseStringWithLocale:[NSLocale currentLocale]];
//
//        NSString *name = [invite1.stringValue containsString:@"sendName"];
//
//        NSString *userName = [invite1 elementsForName:@"reason"];
//        NSDictionary *dict = (NSDictionary *)invite1.stringValue;
//        { groupName = rhgegd; sendName = "Bushra Pervaizss"; }
//        [[message attributeForName:@"from"] stringValue]
//        for (NSDictionary *value in dict) {
//            NSLog(@"print it");
//        }

//        NSData *data = [invite1.stringValue dataUsingEncoding:NSUTF8StringEncoding];
//        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSString *userCheck = invite1.stringValue ;
//        NSData *data = [userCheck dataUsingEncoding:NSUTF8StringEncoding];
//
//        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

//        NSDictionary *dict = (NSDictionary *)invite1.stringValue ;
        NSString * conferenceRoomJID = [[message attributeForName:@"from"] stringValue];

        NSString *stringWithoutSpaces = [conferenceRoomJID
                                         stringByReplacingOccurrencesOfString:@"@conference.ibexglobal.com" withString:@""];
        
        NSString *finlaNameOfRoom = [[stringWithoutSpaces componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
        [history addAttributeWithName:@"maxstanzas" stringValue:@"10000"];
        
        [xmppRoom joinRoomUsingNickname:xmppStream.myJID.user history:history];

//        [xmppRoom joinRoomUsingNickname:xmppStream.myJID.user history:@"10000"];

//        [TWMessageBarManager sharedInstance].styleSheet = self;
//              dispatch_async(dispatch_get_main_queue(), ^(void) {
//                    [[TWMessageBarManager sharedInstance] showMessageWithTitle:invite1.stringValue description:@"You are Invite for this Group" type:TWMessageBarMessageTypeSuccess statusBarStyle:UIStatusBarStyleDefault callback:^{
//
//                    }];
//        });
        
        
        
        arrayOfGroupList = [ChatRooms fetchAll].mutableCopy ;
        NSPredicate *pNewsCard = [NSPredicate predicateWithFormat:@"roomJbID == %@",conferenceRoomJID];
        NSArray *filteredNewsCard = [arrayOfGroupList filteredArrayUsingPredicate:pNewsCard];
//        _recentList = [Roaster fetchWithPredicate:[NSPredicate predicateWithFormat:@"jaber_ID == %@", _recentList.jaber_ID] sortDescriptor:nil fetchLimit:0].lastObject;
        
        if (filteredNewsCard.count > 0) {
            
        } else {
        
        
        
//        if(!_roomChat) {
            _roomChat = (ChatRooms *)[ChatRooms create];
//        }
        _roomChat.room_Name = invite1.stringValue ;
        _roomChat.roomJbID = [NSString stringWithFormat:@"%@",conferenceRoomJID] ;
        _roomChat.userJbID = objOfUser.loginUserID ;
        _roomChat.dateOfRecentMessage = [NSDate date];
        _roomChat.lastMessage = @" " ;
        [ChatRooms save];
        
        
    }
    }
}

- (void) joinMultiUserChatRoom:(NSString *) newRoomName withSubject:(NSString*)subject withDescription:(NSString*)discription withBackgroundColor:(NSString*)color
{
    
    XMPPJID *roomJID = [XMPPJID jidWithString:newRoomName];
    XMPPRoomCoreDataStorage *roomMemoryStorage = [[XMPPRoomCoreDataStorage alloc] init];
    xmppRoom = [[XMPPRoom alloc]
                          initWithRoomStorage:roomMemoryStorage
                          jid:roomJID
                          dispatchQueue:dispatch_get_main_queue()];
    [xmppRoom activate:[self xmppStream]];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
    [history addAttributeWithName:@"maxstanzas" stringValue:@"10000"];

    [xmppRoom joinRoomUsingNickname:xmppStream.myJID.user history:history];
    
//    if(discription==nil){
//
//        discription = @"";
//    }
//    if(color==nil){
//
//        color = @"";
//    }
    
//    ChatRooms *room = [ChatRooms createEntity];
//    room.subject = subject;
//    room.roomJid = [NSString stringWithFormat:@"%@",roomJID];
//    room.jid = [NSString stringWithFormat:@"%@",[ApplicationDelegate xmppStream].myJID];
//    room.isPrivate = NO;
//    room.roomDescription = discription;
//    room.roomColor = color;
    
    //Device Changed Implementation
    // Save Managed Object Context
//    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onlineStatus" object:nil];
    
//    [self createGroupOnServer:subject withRoom:[NSString stringWithFormat:@"%@",roomJID] withDescription:discription andWithColor:color];
    
    
}


- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message { //Remove this member from the group, In our application we will accept it and never decline
    
    
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    return false;
}





- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence { //5
    
    NSString *presenceType = [presence type];
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];

    if ([myUsername isEqualToString:presenceFromUser]) {
        if  ([presenceType isEqualToString:@"available"]){
            
            // User is online
            [NotifCentre postNotificationName:kPresenceUserOnline object:presence];
        }
        else if ([presenceType isEqualToString:@"unavailable"]){
            // user is offline
//            [NotifCentre postNotificationName:kPresenceOffline object:presence];
        }
        else if ([presenceType isEqualToString:@"subscribe"]){
            [xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
//            NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
//            [presence addAttributeWithName:@"type" stringValue:@"subscribed"];
//            [presence addAttributeWithName:@"to" stringValue:presenceFromUser];
//            [presence addAttributeWithName:@"from" stringValue:[[sender myJID] user]];
//            NSXMLElement *element = [NSXMLElement elementWithName:@"priority" xmlns:@"24"];
//            [presence addChild:element];
//            [[self xmppStream] sendElement:presence];
        }
        else if ([presenceType isEqualToString:@"unsubscribe"]){
            [xmppRoster removeUser:[presence from]];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error {
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender xwithError:(NSError *)error {
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    if (!isXmppConnected) {
        NSLog(@"Unable to connect to server. Check xmppStream.hostName");
    }
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark- XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence {
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *jidStrBare    = [presence fromStr];
    
//    xmppRosterStorage.userForJID(presence.from(), xmppStream: OneChat.sharedInstance.xmppStream, managedObjectContext: managedObjectContext_roster())
    
    [xmppRosterStorage userForJID:presence.from xmppStream:xmppStream managedObjectContext:xmppRosterStorage.mainThreadManagedObjectContext];
    
    NSLog(@"Buddy request from %@",jidStrBare);
}

- (void)dealloc {
//    [self teardownStream];
}

#pragma mark - XMPPPingDelegate -

- (void)xmppPing:(XMPPPing *)sender didReceivePong:(XMPPIQ *)pong withRTT:(NSTimeInterval)rtt{
//    DDLogVerbose(@"didReceivePong: %@", pong);
    
    
}

- (void)xmppPing:(XMPPPing *)sender didNotReceivePong:(NSString *)pingID dueToTimeout:(NSTimeInterval)timeout{
//    DDLogVerbose(@"didNotReceivePong: %@", pingID);
}

#pragma mark- XMPPIncomingFileTransfer Delegate -
/*
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
                didFailWithError:(NSError *)error
{
    DDLogVerbose(@"%@: Incoming file transfer failed with error: %@", THIS_FILE, error);
}

- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
               didReceiveSIOffer:(XMPPIQ *)offer
{
    DDLogVerbose(@"%@: Incoming file transfer did receive SI offer. Accepting...", THIS_FILE);
    [sender acceptSIOffer:offer];
}

- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
              didSucceedWithData:(NSData *)data
                           named:(NSString *)name
{
    DDLogVerbose(@"%@: Incoming file transfer did succeed.", THIS_FILE);
//    UIImage *image = [UIImage imageWithData:data];
//    Message *soMessage          = [[Message alloc] init];
//    soMessage.fromMe            = NO;
//    soMessage.date              = [NSDate date];
//    if([UIImage imageWithData:data]){
//        soMessage.thumbnail     = [UIImage imageWithData:data];
//        soMessage.media         = data;
//        [self saveIncomingMessage:nil soMessage:soMessage messageSender:name];
//    }
//    else if(image){
//        soMessage.thumbnail     = [UIImage imageWithData:data];
//        soMessage.media         = data;
//        [self saveIncomingMessage:nil soMessage:soMessage messageSender:name];
//    }
    
//    DDLogVerbose(@"%@: Data was written to the path: %@", THIS_FILE, fullPath);
}

#pragma mark- XMPPOutgoingFileTransfer Delegate -

- (void)xmppOutgoingFileTransfer:(XMPPOutgoingFileTransfer *)sender
                didFailWithError:(NSError *)error
{
    DDLogInfo(@"Outgoing file transfer failed with error: %@", error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"There was an error sending your file. See the logs."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)xmppOutgoingFileTransferDidSucceed:(XMPPOutgoingFileTransfer *)sender
{
    DDLogVerbose(@"File transfer successful.");
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
//                                                    message:@"Your file was sent successfully."
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
}
*/

@end
