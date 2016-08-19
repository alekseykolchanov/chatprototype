//
//  HCLoginViewModel.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCLoginViewModel.h"
#import "HCStoreManager.h"

@implementation HCLoginViewModel

#pragma mark - HCLoginViewModelProtocol
- (BOOL)isLoginPossibleWithName:(NSString *)name {
    return [name length] > 0;
}

- (void)loginWithName:(NSString *)name completion:(void(^)(BOOL isSuccess))completion {
    [[HCStoreManager sharedInstance] loginWithName:name completion:^(NSError *error) {
        
        if (completion)
            completion(!error);
        
    }];
}

@end
