//
//  HCStoreManager.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCCoreDataModels.h"

extern NSString * const HCStoreManagerUserListDidChangeNotification;

extern NSString * const HCStoreManagerDidRecieveNewMessageNotification;
extern NSString * const HCStoreManagerMessageStatusDidChangeNotification;


extern NSString * const HCStoreManagerMessageGuidKey;
extern NSString * const HCStoreManagerMessageSenderGuidKey;
extern NSString * const HCStoreManagerMessageRecieverGuidKey;

extern NSString * const HCStoreManagerMessageTextKey;
extern NSString * const HCStoreManagerMessageGPSPointKey;
extern NSString * const HCStoreManagerMessageImageKey;

@interface HCStoreManager : NSObject

+ (id)sharedInstance;

- (BOOL)isLoggedIn;
- (User * _Nullable)getUserWithGuid:(NSString * _Nonnull)userGuid inContext:(NSManagedObjectContext * _Nullable)context;
- (void)loginWithName:(NSString *)name completion:(void(^)(NSError *error))completionBlock;

- (NSArray *)usersFriendsInContext:(NSManagedObjectContext *)context withSortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptorsArray;

- (BaseMessage * _Nullable)sendMessage:(NSDictionary * _Nonnull)messageDictionary inContext:(NSManagedObjectContext * _Nullable)context completion:(void(^ _Nullable)(NSError * _Nullable error))completionBlock;
- (NSArray * _Nullable)getMessagesWithUser:(NSString * _Nonnull)userGuid inContext:(NSManagedObjectContext * _Nullable)context;
- (BaseMessage * _Nullable)getMessageWithGuid:(NSString * _Nonnull)messageGuid inContext:(NSManagedObjectContext * _Nullable)context;

@end
