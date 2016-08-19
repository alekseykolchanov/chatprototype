//
//  HCUserListViewModel.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 19/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCUserListViewModel.h"
#import "HCStoreManager.h"
#import "SDCoreDataController.h"
#import "NSIndexPath+ChatPrototype.h"

@implementation HCUserFriendEntity



@end


@interface HCUserListViewModel ()

@property (nonatomic, strong) NSManagedObjectContext *currentContext;

@property (nonatomic, strong) NSArray *usersArray;
@property (nonatomic, strong) NSArray *userEntitiesArray;


@end

@implementation HCUserListViewModel
@synthesize currentContext = _currentContext;

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userListDidChange:) name:HCStoreManagerUserListDidChangeNotification object:nil];
    }
    
    return self;
}

- (NSManagedObjectContext *)currentContext {
    if (!_currentContext) {
        _currentContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    }
    
    return _currentContext;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userListDidChange:(NSNotification *)notification {
    [self updateUsersArray];
}

- (void)updateUsersArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSSortDescriptor *nameSortDesrciptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSArray *userFriends = [[HCStoreManager sharedInstance] usersFriendsInContext:[self currentContext] withSortDescriptors:@[nameSortDesrciptor]];
        
        NSMutableArray *entitiesArray = [[NSMutableArray alloc] initWithCapacity:[userFriends count]];
        for (User *friend in userFriends) {
            HCUserFriendEntity *friendEntity = [HCUserFriendEntity new];
            [friendEntity setName:[friend firstName]];
            [entitiesArray addObject:friendEntity];
        }
        [self setUsersArray:userFriends];
        [self setUserEntitiesArray:entitiesArray];
        
        HCViewModelTableViewDataSourceDidChangeBlock didChangeBlock = [self itemsCollectionDidChangeBlock];
        if (didChangeBlock) {
            didChangeBlock();
        }
    });
}

#pragma mark - HCUserListViewModelProtocol
- (void)reloadItemsCollection {
    [self updateUsersArray];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [[self userEntitiesArray] count];
}

- (NSUInteger)typeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    return HCUserListEntityTypeUserFriend;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [indexPath tableViewItem];
    if (index < [[self userEntitiesArray] count]) {
        return [self userEntitiesArray][index];
    }
    
    return nil;
}


@end
