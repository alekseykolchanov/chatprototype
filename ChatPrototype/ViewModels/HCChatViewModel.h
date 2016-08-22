//
//  HCChatViewModel.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCViewModelTableViewDataSource.h"
#import "HCCoreDataModels.h"

typedef NS_ENUM(NSUInteger, HCChatEntityType) {
    HCChatEntityTypeUnknown = 0,
    HCChatEntityTypeDateString,
    HCChatEntityTypeTextMessageSent,
    HCChatEntityTypeTextMessageRecieved,
    HCChatEntityTypeImageMessageSent,
    HCChatEntityTypeImageMessageRecieved,
    HCChatEntityTypeGPSMessageSent,
    HCChatEntityTypeGPSMessageRecieved
};


@interface HCChatBaseEntity : NSObject

@property (nonatomic) HCChatEntityType entityType;
@property (nonatomic, copy) NSDate *created_at;

@end



@interface HCChatDateStringEntity : HCChatBaseEntity

- (id)initWithDate:(NSDate *)date andDateTimeString:(NSString*)dateTimeString;
@property (nonatomic, copy) NSString *dateTimeString;

@end



@interface HCBaseMessageEntity : HCChatBaseEntity

@property (nonatomic, copy) NSString *guid;
@property (nonatomic) HCMessageStatus messageStatus;


@end


@interface HCTextMessageEntity : HCBaseMessageEntity

- (instancetype)initWithText:(NSString *)messageText;

@property (nonatomic, copy) NSString *text;

@end



@protocol HCChatViewModelProtocol <HCViewModelTableViewDataSource>

- (instancetype)initWithFriendGuid:(NSString *)friendGuid;
- (NSString *)chatFriendName;
- (BOOL)isTextMessagePossibleWithText:(NSString *)messageText;
- (void)sendMessageWithText:(NSString *)messageText completion:(void(^)(BOOL isSuccess))completion;

@end



@interface HCChatViewModel : NSObject<HCChatViewModelProtocol>

-(instancetype) __unavailable init;

@property (nonatomic, readonly) NSString *friendGuid;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidChangeBlock itemsCollectionDidChangeBlock;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidUpdateItemsBlock itemsCollectionDidAddItemsBlock;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidUpdateItemsBlock itemsCollectionDidUpdateItemsBlock;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidUpdateItemsBlock itemsCollectionDidDeleteItemsBlock;

@property (nonatomic, copy) HCViewModelTableViewDataSourceDidChangeBlock itemsCollectionStartUpdateItemsBlock;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidChangeBlock itemsCollectionFinishUpdateItemsBlock;

@end
