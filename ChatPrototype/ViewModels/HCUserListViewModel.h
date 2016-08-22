//
//  HCUserListViewModel.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 19/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCViewModelTableViewDataSource.h"

typedef NS_ENUM(NSUInteger, HCUserListEntityType) {
    HCUserListEntityTypeUnknown = 0,
    HCUserListEntityTypeUserFriend
};



@interface HCUserFriendEntity : NSObject

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *name;

@end





@protocol HCUserListViewModelProtocol <HCViewModelTableViewDataSource>



@end





@interface HCUserListViewModel : NSObject<HCUserListViewModelProtocol>

@property (nonatomic, copy) HCViewModelTableViewDataSourceDidChangeBlock itemsCollectionDidChangeBlock;

@property (nonatomic, copy) HCViewModelTableViewDataSourceDidUpdateItemsBlock itemsCollectionDidAddItemsBlock;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidUpdateItemsBlock itemsCollectionDidUpdateItemsBlock;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidUpdateItemsBlock itemsCollectionDidDeleteItemsBlock;

@property (nonatomic, copy) HCViewModelTableViewDataSourceDidChangeBlock itemsCollectionStartUpdateItemsBlock;
@property (nonatomic, copy) HCViewModelTableViewDataSourceDidChangeBlock itemsCollectionFinishUpdateItemsBlock;

@end
