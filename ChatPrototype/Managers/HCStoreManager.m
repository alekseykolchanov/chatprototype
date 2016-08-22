//
//  HCStoreManager.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCStoreManager.h"
#import "SDCoreDataController.h"
#import "HCServerManagerProtocol.h"
#import "HCServerManager.h"

NSString * const HCStoreManagerBotUserGuid = @"BOT";

NSString * const HCStoreManagerUserListDidChangeNotification = @"HCStoreManagerUserListDidChangeNotification";

NSString * const HCStoreManagerDidRecieveNewMessageNotification = @"HCStoreManagerDidRecieveNewMessageNotification";
NSString * const HCStoreManagerMessageStatusDidChangeNotification = @"HCStoreManagerMessageStatusDidChangeNotification";


NSString * const HCStoreManagerMessageGuidKey = @"HCStoreManagerMessageGuidKey";
NSString * const HCStoreManagerMessageSenderGuidKey = @"HCStoreManagerMessageSenderGuidKey";
NSString * const HCStoreManagerMessageRecieverGuidKey = @"HCStoreManagerMessageRecieverGuidKey";

NSString * const HCStoreManagerMessageTextKey = @"HCStoreManagerMessageTextKey";
NSString * const HCStoreManagerMessageGPSPointKey = @"HCStoreManagerMessageGPSPointKey";
NSString * const HCStoreManagerMessageImageKey = @"HCStoreManagerMessageImageKey";


@interface HCStoreManager ()

@property (nonatomic, strong) id<HCServerManagerProtocol> serverManager;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end


@implementation HCStoreManager


+ (id)sharedInstance {
    static dispatch_once_t once;
    static HCStoreManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init {
    if (self = [super init]) {
        [self setServerManager:[[HCServerManager alloc] init]];
    }
    
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    return [[SDCoreDataController sharedInstance]backgroundManagedObjectContext];
}

#pragma mark - User methods
- (BOOL)isLoggedIn {
    
    NSString *currentGuid = nil;
    if (!(currentGuid = [[self serverManager] currentUserGuid])) {
        return NO;
    }
    
    NSManagedObjectContext *objContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid==%@",currentGuid];
    [fetchRequest setPredicate:predicate];
    
    __block NSUInteger usersCount;
    
    [objContext performBlockAndWait:^{
        NSError *error;
        usersCount =  [objContext countForFetchRequest:fetchRequest error:&error];
    }];
    
    return usersCount > 0;
}

- (User * _Nullable)getUserWithGuid:(NSString * _Nonnull)userGuid inContext:(NSManagedObjectContext * _Nullable)context {
    
    NSManagedObjectContext *objContext = context == nil ? [self managedObjectContext] : context;

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid==%@",userGuid];
    [fetchRequest setPredicate:predicate];
    
    __block NSArray *users;
    
    [objContext performBlockAndWait:^{
        NSError *error;
        users =  [objContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return [users count] > 0 ? [users firstObject] : nil;
}

- (void)loginWithName:(NSString *)name completion:(void(^)(NSError *error))completionBlock {
    
    [self cleanStorage];
    
    [[self serverManager] loginWithName:name completion:^(NSDictionary *userDictionary, NSError *error) {
        if (!error) {
            
            NSString *userGUID = userDictionary[HCServerManagerUserGuidParseKey];
            NSString *userName = userDictionary[HCServerManagerUserNameParseKey];
        
            if (!userGUID && [userGUID length] > 10) {
                error = [[NSError alloc]init];
            }else{
                User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
                [[self managedObjectContext] performBlockAndWait:^{
                    [user setGuid:userGUID];
                    [user setFirstName:userName];
#ifdef DEBUG
                    User *bot = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self managedObjectContext]];
                    [bot setGuid:HCStoreManagerBotUserGuid];
                    [bot setFirstName:@"Chat bot"];
                    
#endif
                    [[self managedObjectContext] save:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:HCStoreManagerUserListDidChangeNotification object:nil];
                }];
            }
        }
        
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

#pragma mark - User's friends
- (NSArray *)usersFriendsInContext:(NSManagedObjectContext *)context withSortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptorsArray {
    
    NSString *currentGuid = nil;
    if (!(currentGuid = [[self serverManager] currentUserGuid])) {
        return nil;
    }
    
    NSManagedObjectContext *objContext = context == nil ? [self managedObjectContext] : context;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid != %@",currentGuid];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setSortDescriptors:sortDescriptorsArray];
    
    __block NSArray *users;
    
    [objContext performBlockAndWait:^{
        NSError *error;
        users =  [objContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return users;
    
}

#pragma mark - Messages
- (BaseMessage * _Nullable)sendMessage:(NSDictionary * _Nonnull)messageDictionary inContext:(NSManagedObjectContext * _Nullable)context completion:(void(^ _Nullable)(NSError * _Nullable error))completionBlock {
    
    NSString *currentGuid = nil;
    if (!(currentGuid = [[self serverManager] currentUserGuid])) {
        if (completionBlock) {
            completionBlock([NSError new]);
        }
        return nil;
    }

    BaseMessage *createdMessage = nil;
    
    if (messageDictionary[HCStoreManagerMessageGPSPointKey]) {
        //create GPS message
    }else if (messageDictionary[HCStoreManagerMessageImageKey]) {
        // create image message
    }else{
        createdMessage = [NSEntityDescription insertNewObjectForEntityForName:@"TextMessage" inManagedObjectContext:[self managedObjectContext]];
        [[self managedObjectContext] performBlockAndWait: ^{
        [(TextMessage *)createdMessage setTitle:messageDictionary[HCStoreManagerMessageTextKey]];
        }];
    }
    
    if (createdMessage) {
        
        User *me = [self getUserWithGuid:currentGuid inContext:[self managedObjectContext]];
        User *friend = [self getUserWithGuid:messageDictionary[HCStoreManagerMessageRecieverGuidKey] inContext:[self managedObjectContext]];
        
        [[self managedObjectContext] performBlockAndWait:^{
            [createdMessage setOwner: me];
            [createdMessage setReciever:friend];
        }];
        
        [[SDCoreDataController sharedInstance] saveBackgroundContext];
        
        [[self serverManager] sendMessageWithDictionary:[self dictionaryToSendMessage:createdMessage] completion:^(NSDictionary *serverMessageDictionary, NSError *error) {
            
#ifdef DEBUG
            BaseMessage *botResponseMessage = nil;
            if (!error) {
                
                __block NSString *botMessageGuid = nil;
                __block NSString *botMessageSenderGuid = nil;
                __block NSString *botMessageRecieverGuid = nil;
                
                if (messageDictionary[HCStoreManagerMessageGPSPointKey]) {
                    //create Bot's GPS message
                }else if (messageDictionary[HCStoreManagerMessageImageKey]) {
                    // create Bot's image message
                }else{
                    botResponseMessage = [NSEntityDescription insertNewObjectForEntityForName:@"TextMessage" inManagedObjectContext:[self managedObjectContext]];
                    [[self managedObjectContext] performBlockAndWait: ^{
                        [(TextMessage *)botResponseMessage setTitle:messageDictionary[HCStoreManagerMessageTextKey]];
                        [botResponseMessage setOwner: friend];
                        [botResponseMessage setReciever:me];
                        
                        botMessageGuid = [[botResponseMessage guid] copy];
                        botMessageSenderGuid = [[[botResponseMessage owner] guid] copy];
                        botMessageRecieverGuid = [[[botResponseMessage reciever] guid] copy];
                    }];
                    
                    [[SDCoreDataController sharedInstance] saveBackgroundContext];
                    
                    
                    NSDictionary *userInfo = @{HCStoreManagerMessageGuidKey : botMessageGuid, HCStoreManagerMessageSenderGuidKey : botMessageSenderGuid, HCStoreManagerMessageRecieverGuidKey : botMessageRecieverGuid};
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:HCStoreManagerDidRecieveNewMessageNotification object:self userInfo:userInfo];
                }
            }
#endif
        }];
        
        if (context) {
            __block NSString * messageGuidCopy = nil;
            [[self managedObjectContext] performBlockAndWait:^{
                messageGuidCopy = [[createdMessage guid] copy];
            }];
            createdMessage = [self getMessageWithGuid:messageGuidCopy inContext:context];
        }
    }
    
    return createdMessage;
    
}

- (NSArray * _Nullable)getMessagesWithUser:(NSString * _Nonnull)userGuid inContext:(NSManagedObjectContext * _Nullable)context {
    
    
    NSString *currentGuid = nil;
    if (!(currentGuid = [[self serverManager] currentUserGuid])) {
        return nil;
    }
    
    NSManagedObjectContext *objContext = context == nil ? [self managedObjectContext] : context;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BaseMessage"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner.guid == %@ OR reciever.guid == %@", userGuid, userGuid];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDesriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDesriptor]];
    
    __block NSArray *messages;
    
    [objContext performBlockAndWait:^{
        NSError *error;
        messages =  [objContext executeFetchRequest:fetchRequest error:&error];
        
//        int firstIndex = [rawMessages count] > numberOfLastMessagesToReturn ? [rawMessages count] - numberOfLastMessagesToReturn : 0;
//        for (int i = firstIndex; i < [rawMessages count]; i++) {
//            [messages addObject: rawMessages[i]];
//        }
    }];
    
    return messages;
}

- (BaseMessage * _Nullable)getMessageWithGuid:(NSString * _Nonnull)messageGuid inContext:(NSManagedObjectContext * _Nullable)context {
    
    NSManagedObjectContext *objContext = context == nil ? [self managedObjectContext] : context;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BaseMessage"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid == %@", messageGuid];
    [fetchRequest setPredicate:predicate];
    
    __block NSArray *messages;
    
    [objContext performBlockAndWait:^{
        NSError *error;
        messages =  [objContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return [messages count] > 0 ? [messages firstObject] : nil;
    
}

#pragma mark - Helpers
- (NSDictionary *)dictionaryToSendMessage:(BaseMessage *)message {
    //TODO: implement method
    
    return @{};
}

#pragma mark - Cleaning
- (void)cleanStorage {
    
    [[self serverManager] cleanStorage];
    
    NSManagedObjectContext *objContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RootEntity"];
    [fetchRequest setIncludesPropertyValues:NO];
    
    [objContext performBlockAndWait:^{
        NSError *error;
        NSArray *managedObjects =  [objContext executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *obj in managedObjects) {
            [objContext deleteObject:obj];
        }
    }];
    
    [[SDCoreDataController sharedInstance] saveBackgroundContext];
    [[SDCoreDataController sharedInstance] saveMasterContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HCStoreManagerUserListDidChangeNotification object:nil];
}


@end
