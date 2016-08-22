//
//  NSIndexPath+ChatPrototype.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (ChatPrototype)

- (instancetype)initWithTableViewSection:(NSUInteger)section andItem:(NSUInteger)item;

- (NSUInteger)tableViewSection;
- (NSUInteger)tableViewItem;
@end
