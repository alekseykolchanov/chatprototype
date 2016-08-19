//
//  HCMainViewController.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCMainViewController.h"
#import "HCMainViewModel.h"
#import "HCUserListViewController.h"

NSString *const HCEnterNameRequestSegueName = @"HCEnterNameRequestSegue";
NSString *const HCEmbedNavigationControllerSegueName = @"HCEmbedNavigationControllerSegueName";

@interface HCMainViewController ()

@property (nonatomic, strong) id<HCMainViewModelProtocol> viewModel;

@property (nonatomic, strong) UINavigationController *embededNavigationController;
@property (nonatomic, strong) HCUserListViewController *embededUserListController;

@end

@implementation HCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewModel];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[self viewModel] isLoggedIn]) {
        [self performSegueWithIdentifier:HCEnterNameRequestSegueName sender:nil];
    }
}

- (void)setupViewModel {
    id<HCMainViewModelProtocol> viewModel = [[HCMainViewModel alloc] init];
    [self setViewModel: viewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:HCEmbedNavigationControllerSegueName]) {
        [self setEmbededNavigationController: [segue destinationViewController]];
        [self setEmbededUserListController:[[[self embededNavigationController] viewControllers] firstObject]];
    }
    
}


@end
