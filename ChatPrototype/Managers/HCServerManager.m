//
//  HCServerInteractionManager.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCServerManager.h"

NSString *const HCServerManagerDidChangeLoginStateNotification = @"HCServerManagerDidChangeLoginStateNotification";

NSString *const HCServerManagerCurrentUserGUIDKey = @"HCServerManagerCurrentUserGUIDKey";


@interface HCServerManager ()

@property (nonatomic, copy) NSString *currentUserGuid;

@end

@implementation HCServerManager
@synthesize currentUserGuid = _currentUserGuid;

//+ (id)sharedInstance {
//    static dispatch_once_t once;
//    static HCServerManager *sharedInstance;
//    dispatch_once(&once, ^{
//        sharedInstance = [[self alloc] init];
//    });
//    
//    return sharedInstance;
//}

- (NSString *)currentUserGuid {
    if (!_currentUserGuid) {
        _currentUserGuid = [[NSUserDefaults standardUserDefaults] objectForKey:HCServerManagerCurrentUserGUIDKey];
    }
    
    return _currentUserGuid;
}

- (void)setCurrentUserGuid:(NSString *)currentUserGuid {
    _currentUserGuid = currentUserGuid;
    
    if (_currentUserGuid) {
        [[NSUserDefaults standardUserDefaults] setObject:_currentUserGuid forKey:HCServerManagerCurrentUserGUIDKey];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:HCServerManagerCurrentUserGUIDKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)isLoggedIn {
    return [self currentUserGuid] != nil;
}

- (void)loginWithName:(NSString *)name completion:(void(^)(NSDictionary *userDictionary, NSError *error))completionBlock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            if (completionBlock) {
                NSString *userGuid = [[NSUUID UUID] UUIDString];
                NSDictionary *userDictionary = @{HCServerManagerUserGuidParseKey : userGuid,
                                                 HCServerManagerUserNameParseKey : name == nil ? @"" : name};
                
                [self setCurrentUserGuid:userGuid];
                completionBlock(userDictionary, nil);
            }
        });

}


@end
