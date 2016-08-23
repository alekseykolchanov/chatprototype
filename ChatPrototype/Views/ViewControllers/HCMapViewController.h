//
//  HCMapViewController.h
//  ChatPrototype
//
//  Created by Aleksei Kolchanov on 23/08/16.
//  Copyright © 2016 AlKol. All rights reserved.
//

#import "HCBaseViewController.h"
@import MapKit;

@interface HCMapViewController : HCBaseViewController

@property (nonatomic) CGPoint selectedPoint;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
