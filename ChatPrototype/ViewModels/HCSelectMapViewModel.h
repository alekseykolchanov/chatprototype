//
//  HCSelectMapViewModel.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCMapViewModel.h"

@protocol HCSelectMapViewModelProtocol <HCMapViewModelProtocol>


@end


@interface HCSelectMapViewModel : HCMapViewModel<HCSelectMapViewModelProtocol>

@end
