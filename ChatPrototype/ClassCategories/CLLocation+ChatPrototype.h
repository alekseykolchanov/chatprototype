//
//  CLLocation+ChatPrototype.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocation (ChatPrototype)

- (instancetype)initWithCGPoint:(CGPoint)point;

- (CGPoint)CGPoint;


@end
