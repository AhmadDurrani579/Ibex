//
//  ChatManager.m
//  Tellmo
//
//  Created by Waris Shams on 01/12/2015.
//  Copyright © 2015 Devbatch. All rights reserved.
//

#import "ChatManager.h"
#import "PAStorageHelper.h"
#import "MOMessage.h"
@implementation ChatManager


#pragma mark Get Chat Threads & Conversations methods

-(void)saveMessageInDatabase:(MOMessage *)soMessage forContactNumber:(id)contactNumber ofThread:(Thread *)thread withCompletionHandler:(void (^)(BOOL success))handler{
    
    Chat *messageToSave         = [NSEntityDescription insertNewObjectForEntityForName:@"Chat" inManagedObjectContext:[PAStorageHelper managedObjectContext]];
    messageToSave.chatThread    = thread;
    messageToSave.date          = soMessage.date;
    messageToSave.isOutgoing    = soMessage.messageFromMe ;
    
    thread.lastMessage          = soMessage.text;
    thread.sentAt               = soMessage.date;
    
    
    
//    if ([contactNumber isKindOfClass:[Number class]]) {
//        Number *myNumber            = (Number *)contactNumber;
//        //        messageToSave.chatContact   = myNumber.contact;
//        messageToSave.chatThread.lastMessageSentBy = myNumber.contact;
//        myNumber.contact.lastMessageSentBy = thread;
//        myNumber.contact.contactThread = thread;
//        thread.threadOpponent = myNumber.did;
//        if (![[thread.threadContacts allObjects] containsObject:myNumber.contact] && myNumber.contact != nil) {
//            [thread addThreadContactsObject:myNumber.contact];
//        }
//    }
//    else if([contactNumber isKindOfClass:[NSString class]]){
//        thread.threadOpponent = contactNumber;
//        NSArray *array = [[CAContactManager defaultManager] findNumberWithDID:contactNumber];
//        if (array.count > 0) {
//            Number *number = [array firstObject];
//            thread.lastMessageSentBy = number.contact;
//            [Thread save];
//        }
//    }
    
    
    
//    if (soMessage.type == SOMessageTypeText) {
//        messageToSave.message       = soMessage.text;
//        messageToSave.messagetype   = MessageTypeText;
//    }else if (soMessage.type == SOMessageTypePhoto){
//        messageToSave.image         = soMessage.media;
//        messageToSave.messagetype   = MessageTypeImage;
//    }else if (soMessage.type == SOMessageTypeVideo){
//        messageToSave.messagetype   = MessageTypeVideo;
//    }
    messageToSave.message = soMessage.text ;
    [thread addThreadChatsObject:messageToSave];
    
    handler([self saveContext]);
}

#pragma mark Delete Chat From Database

-(void)deleteChatWithThread:(Thread *)thread AndCompletionHandler:(void (^)(BOOL isSuccess))handler{
    
    //    NSLog (@"Thread : %@", thread);
    NSError *error = nil;
//    thread.threadContacts = nil;
    thread.threadChats = nil;
    thread.lastMessage = nil;
    if ([thread validateForDelete:&error]) {
        [[PAStorageHelper managedObjectContext] deleteObject:thread];
        [[PAStorageHelper managedObjectContext] save:&error];
        
        if (error) {
            handler(NO);
        }
        else
            handler(YES);
    }
    else{
        handler(NO);
    }
}

- (BOOL)saveContext{
    NSError *error = nil;
    [[PAStorageHelper managedObjectContext] save:&error];
    BOOL success               = YES;
    if (!error) {
        NSLog(@"Message Saved in DB");
        success                = YES;
    }else{
        NSLog(@"Message failed to saved in DB");
        success                = NO;
    }
    return success;
}

@end
