//
//  ImageMessage+CoreDataProperties.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ImageMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) Image *image;

@end

NS_ASSUME_NONNULL_END
