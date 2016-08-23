//
//  HCSelectMapViewController.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCSelectMapViewController.h"
@import MapKit;
#import "HCSelectMapViewModel.h"

NSString * const HCSelectmapViewControllerSelectedPointKey = @"HCSelectmapViewControllerSelectedPointKey";


@interface HCSelectMapViewController ()


@property (nonatomic, strong) id<HCSelectMapViewModelProtocol> viewModel;


@end

@implementation HCSelectMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[self navigationItem] leftBarButtonItem] setTarget:self];
    [[[self navigationItem] leftBarButtonItem] setAction:@selector(cancelButtonTap:)];
    
    [[[self navigationItem] leftBarButtonItem] setTarget:self];
    [[[self navigationItem] leftBarButtonItem] setAction:@selector(doneButtonTap:)];

}


- (void)setupViewModel {
    
    HCSelectMapViewModel *viewModel = [HCSelectMapViewModel new];
    
    [viewModel setSelectedPoint:[self selectedPoint]];
    
    [viewModel setDidChangeLocationManagerPermition:^(BOOL isAccessGranted){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isAccessGranted) {
                [[self mapView] setShowsUserLocation:YES];
            }else{
                [[self mapView] setShowsUserLocation:NO];
            }
        });
    }];
    
    
    [self setViewModel:viewModel];
}



#pragma mark - Actions
- (void)cancelButtonTap:(id)sender {
    [[self delegate] selectMapViewController:self wantsToCloseWithResult:nil];
}

- (void)doneButtonTap:(id)sender {
    
    CGPoint selectedPoint = [[self viewModel] selectedPoint];
    
    if (CGPointEqualToPoint(selectedPoint, CGPointZero)) {
        [[self delegate] selectMapViewController:self wantsToCloseWithResult:nil];
    }
    
    NSValue *gpsValue = [NSValue valueWithCGPoint:selectedPoint];
    [[self delegate] selectMapViewController:self wantsToCloseWithResult:@{HCSelectmapViewControllerSelectedPointKey : gpsValue}];
}



@end
