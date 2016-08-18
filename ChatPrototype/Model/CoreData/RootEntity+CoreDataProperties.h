//
//  RootEntity+CoreDataProperties.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RootEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *guid;
@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSDate *updated_at;
@property (nullable, nonatomic, retain) NSDate *deleted_at;

@end

NS_ASSUME_NONNULL_END
