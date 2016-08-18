//
//  RootEntity+CoreDataProperties.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RootEntity+CoreDataProperties.h"

@implementation RootEntity (CoreDataProperties)

@dynamic guid;
@dynamic created_at;
@dynamic updated_at;
@dynamic deleted_at;

@end
