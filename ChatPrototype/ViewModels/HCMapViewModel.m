//
//  HCMapViewModel.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCMapViewModel.h"

@interface HCMapViewModel()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HCMapViewModel
@synthesize locationManager = _locationManager;


- (instancetype)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
    }
    
    return self;
}


- (BOOL)isGPSAccessGranted {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
}

- (void)requestGPSAuthorization {
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [[self locationManager] requestWhenInUseAuthorization];
    }else{
        DidChangeLocationManagerPermitionBlock didChangePermitionBlock = [self didChangeLocationManagerPermition];
        if (didChangePermitionBlock)
            didChangePermitionBlock(NO);
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    DidChangeLocationManagerPermitionBlock didChangePermitionBlock = [self didChangeLocationManagerPermition];
    if (didChangePermitionBlock) {
        
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            didChangePermitionBlock(YES);
        }else{
            didChangePermitionBlock(NO);
        }
    }
}

@end
