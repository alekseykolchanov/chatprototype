//
//  HCMapViewModel.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

typedef  void(^DidChangeLocationManagerPermitionBlock)(BOOL isAllowed);


@protocol HCMapViewModelProtocol <NSObject>

- (CGPoint)selectedPoint;
- (void)setSelectedPoint:(CGPoint)point;

- (BOOL)isGPSAccessGranted;
- (void)requestGPSAuthorization;
- (CLLocationManager *)locationManager;
- (void)setDidChangeLocationManagerPermition:(DidChangeLocationManagerPermitionBlock)didGetLocationManagerPermition;

@end

@interface HCMapViewModel : NSObject<HCMapViewModelProtocol, CLLocationManagerDelegate>

@property (nonatomic) CGPoint selectedPoint;
@property (nonatomic, copy) DidChangeLocationManagerPermitionBlock didChangeLocationManagerPermition;

@end
