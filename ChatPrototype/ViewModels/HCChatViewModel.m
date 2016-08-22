//
//  HCChatViewModel.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCChatViewModel.h"
#import "NSIndexPath+ChatPrototype.h"
#import "SDCoreDataController.h"
#import "HCStoreManager.h"


NSString * const HCChatViewFetchControllerModelCacheName = @"messagesCache";

const float HCChatViewMaxSecondsToSplitMessagesIntoGroups = 300.0f;


@implementation HCChatBaseEntity



@end



@implementation HCChatDateStringEntity

- (id)initWithDate:(NSDate *)date andDateTimeString:(NSString*)dateTimeString {
    if (self = [super init]) {
        [self setEntityType:HCChatEntityTypeDateString];
        [self setCreated_at:date];
        [self setDateTimeString:dateTimeString];
    }
    return self;
}

@end



@implementation HCBaseMessageEntity



@end


@implementation HCTextMessageEntity

- (instancetype)initWithText:(NSString *)messageText {
    if (self = [super init]) {
        [self setText:messageText];
    }
    
    return self;
}

@end


@interface HCChatViewModel ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, copy) NSString *friendGuid;

@property (nonatomic, strong) NSMutableArray *messagesArray;
@property (nonatomic, strong) NSMutableArray *messageEntitiesArray;

@end

@implementation HCChatViewModel

- (instancetype)initWithFriendGuid:(NSString  * _Nonnull)friendGuid {
    
    if (self = [super init]) {
        [self setFriendGuid:friendGuid];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveNewMessage:) name:HCStoreManagerDidRecieveNewMessageNotification object:nil];
    }
    
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    }
    
    return _managedObjectContext;
}

- (void)didRecieveNewMessage:(NSNotification *)notification {
    NSString *senderGuid = [notification userInfo][HCStoreManagerMessageSenderGuidKey];
    NSString *recieverGuid = [notification userInfo][HCStoreManagerMessageRecieverGuidKey];
    NSString *messageGuid = [notification userInfo][HCStoreManagerMessageGuidKey];
    
    if (![senderGuid isEqualToString:[self friendGuid]] && ![recieverGuid isEqualToString:[self friendGuid]]) {
        return;
    }
    
    
    BaseMessage *message = [[HCStoreManager sharedInstance] getMessageWithGuid:messageGuid inContext:[self managedObjectContext]];
    if (message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addMessageToArrays:message];
        });
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUsersArray {
    
    NSArray *rawMessages = [[HCStoreManager sharedInstance] getMessagesWithUser:[self friendGuid] inContext:[self managedObjectContext]];
    
    [self setMessagesArray:[NSMutableArray new]];
    [self setMessageEntitiesArray:[NSMutableArray new]];
    
    
    for (int i = 0; i < [rawMessages count]; i++) {
        
        [[self messagesArray] addObject:rawMessages[i]];
        [[self messageEntitiesArray] addObject:[self messageEntityFromMessage:rawMessages[i]]];
        
        if (i == ([rawMessages count] - 1) || [[rawMessages[i] created_at]timeIntervalSinceDate:[rawMessages[i+1] created_at]] > HCChatViewMaxSecondsToSplitMessagesIntoGroups) {
        
            HCChatDateStringEntity *dateEntity = [self dateTimeEntityFromDate:[rawMessages[i] created_at]];
            [[self messagesArray] addObject: dateEntity];
            [[self messageEntitiesArray] addObject:dateEntity];
        }
    }
    
    HCViewModelTableViewDataSourceDidChangeBlock didChangeBlock = [self itemsCollectionDidChangeBlock];
    if (didChangeBlock)
        didChangeBlock();
}

- (void)addMessageToArrays:(BaseMessage *)message {
    __block NSInteger indexToInsert = NSNotFound;
    
    [[self messagesArray] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj created_at] compare:[message created_at]] != NSOrderedDescending) {
            indexToInsert = idx;
            *stop = YES;
        }
    }];
    
    
    NSIndexSet *insertedIndexSet = nil;
    NSIndexSet *updatedIndexSet = nil;
    
    if (indexToInsert == NSNotFound){
        
        if ([[self messagesArray] count] ==0) {
            HCChatDateStringEntity *dateEntity = [self dateTimeEntityFromDate:[message created_at]];
            [[self messagesArray] addObjectsFromArray:@[message, dateEntity]];
            [[self messageEntitiesArray] addObjectsFromArray:@[[self messageEntityFromMessage:message], dateEntity]];
            insertedIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
        }else{
            
            HCChatDateStringEntity *lastEntity = [[self messagesArray] lastObject];
            
            if ([[message created_at] timeIntervalSinceDate:[lastEntity created_at]]) {
                [[self messagesArray] insertObject:message atIndex:[[self messagesArray] count] - 1];
                [[self messageEntitiesArray] insertObject:[self messageEntityFromMessage:message] atIndex:[[self messagesArray] count] - 1];
                
                HCChatDateStringEntity *dateEntity = [self dateTimeEntityFromDate:[message created_at]];
                [[self messagesArray] setObject:dateEntity atIndexedSubscript:[[self messagesArray] count] - 1];
                [[self messageEntitiesArray] setObject:dateEntity atIndexedSubscript:[[self messagesArray] count] - 1];
                
                updatedIndexSet = [[NSIndexSet alloc] initWithIndex:[[self messagesArray] count] - 2];
                insertedIndexSet = [[NSIndexSet alloc] initWithIndex:[[self messagesArray] count] - 1];
            }else{
                HCChatDateStringEntity *dateEntity = [self dateTimeEntityFromDate:[message created_at]];
                [[self messagesArray] addObjectsFromArray:@[message, dateEntity]];
                [[self messageEntitiesArray] addObjectsFromArray:@[[self messageEntityFromMessage:message], dateEntity]];
                insertedIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([[self messagesArray] count] - 2, 2)];
            }
            
        }
        

    }else{
        
        [[self messagesArray] insertObject:message atIndex:indexToInsert];
        [[self messageEntitiesArray] insertObject:[self messageEntityFromMessage:message] atIndex:indexToInsert];
        insertedIndexSet = [[NSIndexSet alloc]initWithIndex:indexToInsert];
        
        if ([[message created_at] timeIntervalSinceDate:[[self messagesArray][indexToInsert + 1] created_at]] > HCChatViewMaxSecondsToSplitMessagesIntoGroups) {
            HCChatDateStringEntity *dateEntity = [self dateTimeEntityFromDate:[message created_at]];
            [[self messagesArray] insertObject:dateEntity atIndex:indexToInsert + 1];
            [[self messageEntitiesArray] insertObject:dateEntity atIndex:indexToInsert + 1];
            
            insertedIndexSet = [[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(indexToInsert, 2)];
        }
    }
    
    HCViewModelTableViewDataSourceDidChangeBlock startUpdateBlock = [self itemsCollectionStartUpdateItemsBlock];
    HCViewModelTableViewDataSourceDidUpdateItemsBlock addItemsBlock = [self itemsCollectionDidAddItemsBlock];
    HCViewModelTableViewDataSourceDidUpdateItemsBlock updateItemsBlock = [self itemsCollectionDidUpdateItemsBlock];
    HCViewModelTableViewDataSourceDidChangeBlock finishUpdateBlock = [self itemsCollectionFinishUpdateItemsBlock];
    
    
    if ((updatedIndexSet || insertedIndexSet) && addItemsBlock && startUpdateBlock && finishUpdateBlock && updateItemsBlock) {
        NSMutableArray *insertedIndexPathArray = [NSMutableArray new];
        [insertedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [insertedIndexPathArray addObject:[[NSIndexPath alloc] initWithTableViewSection:0 andItem:idx]];
        }];
        
        NSMutableArray *updatedIndexPathArray = [NSMutableArray new];
        [updatedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [updatedIndexPathArray addObject:[[NSIndexPath alloc] initWithTableViewSection:0 andItem:idx]];
        }];
        
        startUpdateBlock();
        updateItemsBlock(updatedIndexPathArray);
        addItemsBlock(insertedIndexPathArray);
        finishUpdateBlock();
    }
}


- (HCChatDateStringEntity *)dateTimeEntityFromDate:(NSDate *)date {
    HCChatDateStringEntity *dateEntity = [[HCChatDateStringEntity alloc]initWithDate:date andDateTimeString:[[HCChatViewModel relative_dateFormatter] stringFromDate:date]];

    return dateEntity;
}

+(NSDateFormatter*)relative_dateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *_relative_dateFormatter;
    dispatch_once(&onceToken, ^{
        _relative_dateFormatter = [[NSDateFormatter alloc]init];
        _relative_dateFormatter.timeStyle = NSDateFormatterShortStyle;
        _relative_dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _relative_dateFormatter.doesRelativeDateFormatting = YES;
    });
    
    return _relative_dateFormatter;
}

- (HCBaseMessageEntity * _Nonnull)messageEntityFromMessage:(BaseMessage *)message {
    if (!message)
        return nil;
    
    HCBaseMessageEntity *messageEntity = nil;
    
    if ([message isKindOfClass:[TextMessage class]]) {
        messageEntity = [[HCTextMessageEntity alloc] initWithText:[(TextMessage *)message title]];
        if ([[[message owner]guid] isEqualToString:[self friendGuid]]) {
            [messageEntity setEntityType:HCChatEntityTypeTextMessageRecieved];
        }else{
            [messageEntity setEntityType:HCChatEntityTypeTextMessageSent];
        }
    }else if ([message isKindOfClass:[GeoLocationMessage class]]) {
        
    }else if ([message isKindOfClass:[ImageMessage class]]) {
        
    }
    
    [messageEntity setGuid:[message guid]];
    [messageEntity setCreated_at:[message created_at]];
    [messageEntity setMessageStatus:[message messageStatus]];
    
    NSAssert(messageEntity != nil, @"Wasn't able to convert message to messageEntity");
    
    return messageEntity;
}

- (void)sendMessageDictionary:(NSDictionary *)messageDictionary completion:(void(^)(NSError * error))completion {
    BaseMessage *resultMessage = [[HCStoreManager sharedInstance] sendMessage:messageDictionary inContext:[self managedObjectContext] completion:^(NSError * _Nullable error) {
        if (completion)
            completion(error);
    }];
    
    if (resultMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addMessageToArrays:resultMessage];
        });
    }
}

#pragma mark - HCChatViewModelProtocol
- (NSString *)chatFriendName {
    User *friend = [[HCStoreManager sharedInstance] getUserWithGuid:[self friendGuid] inContext:[self managedObjectContext]];
    return [friend firstName];
}

- (BOOL)isTextMessagePossibleWithText:(NSString *)messageText {
    messageText = [messageText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!messageText || [messageText length] == 0) {
        return NO;
    }
    
    return YES;
}

- (void)sendMessageWithText:(NSString *)messageText completion:(void(^)(BOOL isSuccess))completion {
    
    messageText = [messageText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!messageText || [messageText length] == 0) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    NSDictionary *messageDictionary = @{HCStoreManagerMessageTextKey : messageText, HCStoreManagerMessageRecieverGuidKey : [self friendGuid]};
    
    [self sendMessageDictionary:messageDictionary completion:^(NSError *error) {
        if (completion) {
            completion(error == nil);
        }
    }];
}

- (void)reloadItemsCollection {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUsersArray];
    });
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [[self messageEntitiesArray] count];
}

- (NSUInteger)typeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [indexPath tableViewItem];
    if (index < [[self messageEntitiesArray] count]) {
        return [[self messageEntitiesArray][index] entityType];
    }
    
    return HCChatEntityTypeUnknown;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [indexPath tableViewItem];
    if (index < [[self messageEntitiesArray] count]) {
        return [self messageEntitiesArray][index];
    }
    
    return nil;
}

@end