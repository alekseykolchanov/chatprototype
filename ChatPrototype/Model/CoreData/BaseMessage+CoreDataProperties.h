//
//  BaseMessage+CoreDataProperties.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BaseMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) User *owner;
@property (nullable, nonatomic, retain) User *reciever;

@end

NS_ASSUME_NONNULL_END
