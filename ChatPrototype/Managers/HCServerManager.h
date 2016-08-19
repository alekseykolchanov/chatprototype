//
//  HCServerInteractionManager.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCServerManagerProtocol.h"

@interface HCServerManager : NSObject<HCServerManagerProtocol>

@property (nonatomic, readonly) NSString *currentUserGuid;

- (void)loginWithName:(NSString *)name completion:(void(^)(NSDictionary *userDictionary, NSError *error))completionBlock;


@end
