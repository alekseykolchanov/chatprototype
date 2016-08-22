//
//  NSIndexPath+ChatPrototype.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "NSIndexPath+ChatPrototype.h"

@implementation NSIndexPath (ChatPrototype)

- (instancetype)initWithTableViewSection:(NSUInteger)section andItem:(NSUInteger)item {
    NSUInteger indexes[] = {section, item};
    if (self = [self initWithIndexes:indexes length:2]) {
        
    }
    return self;
}

- (NSUInteger)tableViewSection {
    
    return [self indexAtPosition:0];
}

- (NSUInteger)tableViewItem {
    if ([self length] > 0) {
        return [self indexAtPosition:1];
    }else{
        return NSNotFound;
    }
}

@end
