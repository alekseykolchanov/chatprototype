//
//  HCServerManagerProtocol.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 19/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

static NSString *const HCServerManagerUserNameParseKey = @"HCServerManagerUserNameParseKey";
static NSString *const HCServerManagerUserGuidParseKey = @"HCServerManagerUserGuidParseKey";

static NSString * const HCServerManagerMessageGuidParseKey = @"HCServerManagerMessageGuidParseKey";
static NSString * const HCServerManagerMessageCreatedAtParseKey = @"HCServerManagerMessageCreatedAtParseKey";
static NSString * const HCServerManagerMessageUpdatedAtParseKey = @"HCServerManagerMessageUpdatedAtParseKey";
static NSString * const HCServerManagerMessageDeletedAtParseKey = @"HCServerManagerMessageDeletedAtParseKey";
static NSString * const HCServerManagerMessageSenderGuidParseKey = @"HCServerManagerMessageSenderGuidParseKey";
static NSString * const HCServerManagerMessageRecieverGuidParseKey = @"HCServerManagerMessageRecieverGuidParseKey";
static NSString * const HCServerManagerMessageTextParseKey = @"HCServerManagerMessageTextParseKey";
static NSString * const HCServerManagerMessageImageParseKey = @"HCServerManagerMessageImageParseKey";
static NSString * const HCServerManagerMessageGPSPointParseKey = @"HCServerManagerMessageGPSPointParseKey";


@protocol HCServerManagerProtocol <NSObject>

- (NSString *)currentUserGuid;
- (void)loginWithName:(NSString *)name completion:(void(^)(NSDictionary *userDictionary, NSError *error))completionBlock;

- (void)sendMessageWithDictionary:(NSDictionary *)messageDictionary completion:(void(^)(NSDictionary *messageDictionary, NSError *error))completionBlock;

- (void)cleanStorage;

@end

