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
#import "HCChatViewController.h"

NSString * const HCUserFriendTableViewCellIdentifier = @"HCUserFriendTableViewCell";

NSString * const HCUserListToChatSegueIdentifier = @"HCUserListToChatSegue";

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
        [[weakSelf tableView] reloadData];
    }];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:HCUserListToChatSegueIdentifier]) {
        [(HCChatViewController *)[segue destinationViewController] setFriendGuid: [self selectedCellUserGuid]];
    }
    
}

- (NSString *)selectedCellUserGuid {
    NSIndexPath *selectedIP = [[self tableView]indexPathForSelectedRow];
    if (!selectedIP){
        return nil;
    }
    
    return [[[self viewModel] itemAtIndexPath:selectedIP] guid];
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
    
    NSAssert(false, @"Friend entity wasn't identified");
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
