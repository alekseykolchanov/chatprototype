//
//  BaseMessage.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootEntity.h"
#import "HCModelSupport.h"

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface BaseMessage : RootEntity

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic) HCMessageStatus messageStatus;

@end

NS_ASSUME_NONNULL_END

#import "BaseMessage+CoreDataProperties.h"
