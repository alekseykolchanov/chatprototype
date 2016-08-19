//
//  HCUserListViewController.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 19/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCUserListViewController.h"
#import "HCUserListViewModel.h"
#import "HCUserFriendTableViewCell.h"

NSString * const HCUserFriendTableViewCellIdentifier = @"HCUserFriendTableViewCell";


@interface HCUserListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<HCUserListViewModelProtocol> viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end


@implementation HCUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewModel];
    
    
    [[self viewModel] reloadItemsCollection];
}

- (void)setupViewModel {
    HCUserListViewModel *vm = [HCUserListViewModel new];
    [self setViewModel:vm];
    
    __weak typeof(self) weakSelf = self;
    [vm setItemsCollectionDidChangeBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[weakSelf tableView] reloadData];
        });
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self viewModel] numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self viewModel] numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCUserListEntityType entityType = [[self viewModel] typeOfItemAtIndexPath: indexPath];
    
    switch (entityType) {
        case HCUserListEntityTypeUserFriend: {
            HCUserFriendTableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:HCUserFriendTableViewCellIdentifier];
            HCUserFriendEntity *friend = [[self viewModel] itemAtIndexPath:indexPath];
            [[cell userNameLabel] setText:[friend name]];
            return cell;
            break;
        }
        default:
            break;
    }
    
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
