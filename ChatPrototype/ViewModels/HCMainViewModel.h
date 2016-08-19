//
//  HCMainViewModel.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 19/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCMainViewModelProtocol <NSObject>

- (BOOL)isLoggedIn;

@end

@interface HCMainViewModel : NSObject<HCMainViewModelProtocol>

@end
