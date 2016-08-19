//
//  HCServerManagerProtocol.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 19/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

static NSString *const HCServerManagerUserNameParseKey = @"HCServerManagerUserNameParseKey";
static NSString *const HCServerManagerUserGuidParseKey = @"HCServerManagerUserGuidParseKey";

@protocol HCServerManagerProtocol <NSObject>

- (NSString *)currentUserGuid;
- (void)loginWithName:(NSString *)name completion:(void(^)(NSDictionary *userDictionary, NSError *error))completionBlock;

@end

