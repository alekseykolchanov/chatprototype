//
//  HCSelectMapViewController.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCMapViewController.h"

@class HCSelectMapViewController;



extern NSString * const HCSelectmapViewControllerSelectedPointKey;



@protocol  HCSelectMapViewControllerDelegate <NSObject>

- (void)selectMapViewController:(HCSelectMapViewController *)mapViewController wantsToCloseWithResult:(NSDictionary *)resultDictionary;

@end

@interface HCSelectMapViewController : HCMapViewController

@property (nonatomic, weak) id<HCSelectMapViewControllerDelegate> delegate;

@end
