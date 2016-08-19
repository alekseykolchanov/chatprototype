//
//  HCLoginViewModel.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 18/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCLoginViewModelProtocol <NSObject>

- (BOOL)isLoginPossibleWithName:(NSString *)name;
- (void)loginWithName:(NSString *)name completion:(void(^)(BOOL isSuccess))completion;

@end

@interface HCLoginViewModel : NSObject<HCLoginViewModelProtocol>

@end
