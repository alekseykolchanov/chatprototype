//
//  CLLocation+ChatPrototype.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "CLLocation+ChatPrototype.h"

@implementation CLLocation (ChatPrototype)

- (instancetype)initWithCGPoint:(CGPoint)point {
    if (self = [self initWithLatitude:point.x longitude:point.y]) {
        
    }
    
    return self;
}

- (CGPoint)CGPoint {
    return CGPointMake(self.coordinate.latitude, self.coordinate.longitude);
}

@end
