//
//  NSIndexPath+ChatPrototype.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "NSIndexPath+ChatPrototype.h"

@implementation NSIndexPath (ChatPrototype)

- (NSInteger)tableViewSection {
    
    return [self indexAtPosition:0];
}

- (NSInteger)tableViewItem {
    if ([self length] > 0) {
        return [self indexAtPosition:1];
    }else{
        return NSNotFound;
    }
}

@end
