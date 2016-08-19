//
//  HCMainViewModel.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 19/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCMainViewModel.h"
#import "HCStoreManager.h"


@implementation HCMainViewModel

- (BOOL)isLoggedIn {
    return [[HCStoreManager sharedInstance] isLoggedIn];
}

@end
