//
//  MapViewController.m
//  momentum
//
//  Created by James Rochabrun on 10/20/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "MapViewController.h"
#import "TopView.h"
#import "Common.h"
#import "THDiaryEntry.h"
@import GoogleMaps;



@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_street) {
        [self streetView];
        
    } else{
        _mapView = [MKMapView new];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [self.view addSubview:_mapView];
        
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation]; //Will update location immediately
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    CGRect frame = _mapView.frame;
    frame.size.height = height(self.view);
    frame.size.width = width(self.view);
    frame.origin.x = 0;
    frame.origin.y = 0;
    _mapView.frame = frame;
}

#pragma mapKit
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation {
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    point.coordinate = CLLocationCoordinate2DMake([self.entry.latitude doubleValue], [self.entry.longitude doubleValue]);
    point.title = @"Memory location";
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    point.subtitle = [dateFormatter stringFromDate:date];
        
    [self.mapView setRegion:MKCoordinateRegionMake(point.coordinate, MKCoordinateSpanMake(0.8f, 0.8f)) animated:YES];
    
    [self.mapView addAnnotation:point];
}

- (void)streetView {
    
    CLLocationCoordinate2D panoramaNear = CLLocationCoordinate2DMake([self.entry.latitude doubleValue], [self.entry.longitude doubleValue]);
    NSLog(@"the lat %f", [self.entry.latitude doubleValue]);
    NSLog(@"the long %f", [self.entry.longitude doubleValue]);
    
    GMSPanoramaView *panoView =
    [GMSPanoramaView panoramaWithFrame:CGRectZero
                        nearCoordinate:panoramaNear];
    
    self.view = panoView;
}

- (void)viewDidDisappear:(BOOL)animated {
    
      [_locationManager stopUpdatingLocation];
}


- (IBAction)dismissView:(UIBarButtonItem *)sender {

  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}




@end
