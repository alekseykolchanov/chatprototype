//
//  HCViewModelTableViewDataSource.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 20/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HCViewModelTableViewDataSourceDidChangeBlock)();
typedef void(^HCViewModelTableViewDataSourceDidUpdateItemsBlock)(NSArray *indexPaths);

@protocol HCViewModelTableViewDataSource <NSObject>

- (void)reloadItemsCollection;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSUInteger)typeOfItemAtIndexPath:(NSIndexPath *)indexPath;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)setItemsCollectionDidChangeBlock:(HCViewModelTableViewDataSourceDidChangeBlock)didChangeBlock;
- (void)setItemsCollectionDidAddItemsBlock:(HCViewModelTableViewDataSourceDidUpdateItemsBlock)didAddItemsBlock;
- (void)setItemsCollectionDidUpdateItemsBlock:(HCViewModelTableViewDataSourceDidUpdateItemsBlock)didUpdateItemsBlock;
- (void)setItemsCollectionDidDeleteItemsBlock:(HCViewModelTableViewDataSourceDidUpdateItemsBlock)didDeleteItemsBlock;
- (void)setItemsCollectionStartUpdateItemsBlock:(HCViewModelTableViewDataSourceDidChangeBlock)startUpdateItemsBlock;
- (void)setItemsCollectionFinishUpdateItemsBlock:(HCViewModelTableViewDataSourceDidChangeBlock)finishUpdateItemsBlock;

@optional


@end
