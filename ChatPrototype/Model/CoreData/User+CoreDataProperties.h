//
//  User+CoreDataProperties.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSSet<BaseMessage *> *messagesSent;
@property (nullable, nonatomic, retain) BaseMessage *messagesRecieved;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addMessagesSentObject:(BaseMessage *)value;
- (void)removeMessagesSentObject:(BaseMessage *)value;
- (void)addMessagesSent:(NSSet<BaseMessage *> *)values;
- (void)removeMessagesSent:(NSSet<BaseMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
