//
//  HCMapViewController.m
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCMapViewController.h"
#import "CLLocation+ChatPrototype.h"
#import "HCMapViewModel.h"

@interface HCMapViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) id<HCMapViewModelProtocol> viewModel;

@end

@implementation HCMapViewController
@synthesize selectedPoint = _selectedPoint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViewModel];
    [self setupViewsAppearance];
    
    

    [[self mapView] setDelegate:self];
    if (!CGPointEqualToPoint(CGPointZero, [self selectedPoint])) {
        [self centerOnPoint:[self selectedPoint] animated:NO];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self viewModel] requestGPSAuthorization];
}

- (void)setupViewModel {
    HCMapViewModel *viewModel = [HCMapViewModel new];
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


- (void)setupViewsAppearance {
    
    [[self mapView] setShowsScale:YES];
    [[self mapView] setShowsPointsOfInterest:YES];
    
    [[self mapView] setShowsUserLocation:[[self viewModel] isGPSAccessGranted]];
}

- (void)setSelectedPoint:(CGPoint)selectedPoint {
    _selectedPoint = selectedPoint;
    
    if (![self viewIfLoaded])
        return;



}


- (void)centerOnPoint:(CGPoint)coordinatePoint animated:(BOOL)isAnimated {
    
    CLLocationDistance regionRadius = 1000;
    
    CLLocation *location = [[CLLocation alloc]initWithCGPoint:coordinatePoint];
    
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0);
    
    [[self mapView] setRegion:coordinateRegion animated:isAnimated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}


@end
