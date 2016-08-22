//
//  RootEntity.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "RootEntity.h"
#import "NSDate+ChatPrototype.h"

@implementation RootEntity

// Insert code here to add functionality to your managed object subclass

- (void)awakeFromInsert {
    self.guid = [[NSUUID UUID] UUIDString];
    self.created_at = [NSDate currentDateTime];
    self.updated_at = self.created_at;
}

@end
