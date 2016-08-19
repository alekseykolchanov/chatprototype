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

NSString * const HCStoreManagerUserListDidChangeNotification = @"HCStoreManagerUserListDidChangeNotification";


@interface HCStoreManager ()

@property (nonatomic, strong) id<HCServerManagerProtocol> serverManager;



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

- (NSManagedObjectContext *)currentContext {
    return [[SDCoreDataController sharedInstance]backgroundManagedObjectContext];
}

#pragma mark - User methods
- (BOOL)isLoggedIn {
    
    NSString *currentGuid = nil;
    if (!(currentGuid = [[self serverManager] currentUserGuid])) {
        return nil;
    }
    
    NSManagedObjectContext *objContext = [self currentContext];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid==%@",currentGuid];
    [fetchRequest setPredicate:predicate];
    
    __block int usersCount;
    
    [objContext performBlockAndWait:^{
        NSError *error;
        usersCount =  [objContext countForFetchRequest:fetchRequest error:&error];
    }];
    
    return usersCount > 0;
}

- (User *)currentUserInContext:(NSManagedObjectContext *)context {
    
    NSString *currentGuid = nil;
    if (!(currentGuid = [[self serverManager] currentUserGuid])) {
        return nil;
    }
    
    NSManagedObjectContext *objContext = context == nil ? [self currentContext] : context;

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guid==%@",currentGuid];
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
                User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self currentContext]];
                [[self currentContext] performBlockAndWait:^{
                    [user setGuid:userGUID];
                    [user setFirstName:userName];
#ifdef DEBUG
                    User *bot = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[self currentContext]];
                    [bot setGuid:@"BOT"];
                    [bot setFirstName:@"Chat bot"];
                    
#endif
                    [[self currentContext] save:nil];
                    
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
    
    NSManagedObjectContext *objContext = context == nil ? [self currentContext] : context;
    
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

#pragma mark - Sending messages
- (void)sendMessage:(BaseMessage *)message {
    
}

#pragma mark - Cleaning
- (void)cleanStorage {
    NSManagedObjectContext *objContext = [self currentContext];
    
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
