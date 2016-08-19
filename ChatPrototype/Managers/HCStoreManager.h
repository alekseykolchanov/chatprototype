//
//  HCStoreManager.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCCoreDataModels.h"


@interface HCStoreManager : NSObject

+ (id)sharedInstance;

- (BOOL)isLoggedIn;
- (User *)currentUserInContext:(NSManagedObjectContext *)context;
- (void)loginWithName:(NSString *)name completion:(void(^)(NSError *error))completionBlock;

- (void)sendMessage:(BaseMessage *)message;

@end
