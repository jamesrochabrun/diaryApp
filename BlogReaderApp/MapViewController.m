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
#import "MarkerDetailView.h"
#import "Common.h"
#import "UIFont+CustomFont.h"
@import GoogleMaps;



@interface MapViewController ()<GMSMapViewDelegate>
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) UIButton *directionsButton;
@property (nonatomic, strong) UIButton *streetButton;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, strong) NSArray *steps;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: [self.entry.latitude doubleValue]
                                                            longitude: [self.entry.longitude doubleValue]
                                                                 zoom:15
                                                              bearing:0//rotation
                                                         viewingAngle:0];
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    // self.mapView.mapType = kGMSTypeSatellite;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:10 maxZoom:18];
    self.view = _mapView;
    [self setUpMarkerData];
    
    _directionsButton = [UIButton new];
    _directionsButton.layer.borderColor = [UIColor blackColor].CGColor;
    _directionsButton.titleLabel.font = [UIFont regularFont:17];
    [_directionsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _directionsButton.layer.borderWidth = 2.0;
    [_directionsButton setTitle:@"Show Directions" forState:UIControlStateNormal];
    [_directionsButton addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_directionsButton];
    
    _streetButton = [UIButton new];
    _streetButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_streetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _streetButton.titleLabel.font = [UIFont regularFont:17];
    _streetButton .layer.borderWidth = 2.0;
    [_streetButton setTitle:@"Show Street View" forState:UIControlStateNormal];
    [_streetButton addTarget:self action:@selector(showStreetView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_streetButton];
}

- (void)setUpMarkerData {
    
    GMSMarker *marker = [GMSMarker new];
    marker.position = CLLocationCoordinate2DMake([self.entry.latitude doubleValue], [self.entry.longitude doubleValue]);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [UIImage imageNamed:@"locationIcon"];
    GMSGeocoder *geoCoder = [GMSGeocoder new];
    [geoCoder reverseGeocodeCoordinate:marker.position completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            marker.title = response.firstResult.locality;
            marker.snippet = response.firstResult.thoroughfare;
        });
    }];
    marker.map = nil;
    [self drawMarker:marker];
}

- (void)drawMarker:(GMSMarker *)marker {
    
    if (marker.map == nil) {
        marker.map = self.mapView;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = _directionsButton.frame;
    frame.size.height = 50;
    frame.size.width = 200;
    frame.origin.x = (width(self.view) - frame.size.width) /2;
    frame.origin.y = CGRectGetMaxY(self.view.frame) - frame.size.height *2;
    _directionsButton.frame = frame;
    
    frame = _streetButton.frame;
    frame.size.height = 50;
    frame.size.width = 200;
    frame.origin.x = frame.origin.x = (width(self.view) - frame.size.width) /2;
    frame.origin.y = CGRectGetMinY(_directionsButton.frame) - frame.size.height - 10;
    _streetButton.frame = frame;

}

- (IBAction)dismissView:(UIBarButtonItem *)sender {

  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma googlemapdelegate

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    MarkerDetailView *markerView = [[MarkerDetailView alloc] initWithMarker:marker];
    markerView.frame = CGRectMake(0, 0, 200, 70);
    return markerView;
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    if (self.polyline != nil)return;
    
    //check if my location is setted
    if (mapView.myLocation != nil) {
        //1) create a nsurl based on the directions API
        NSString *baseURL = @"https://maps.googleapis.com/maps/api/directions/json?";
        //required parameters
        NSString *startLocation = [NSString stringWithFormat:@"%f,%f",mapView.myLocation.coordinate.latitude, mapView.myLocation.coordinate.longitude];
        NSString *endLocation = [NSString stringWithFormat:@"%f,%f",marker.position.latitude, marker.position.longitude];
        NSString *browserAPIKEY = @"AIzaSyBK2neKROEYl_9rXXrOsFq_iwRE73shxWs";
        NSString *urlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=true&key=%@", baseURL, startLocation, endLocation,browserAPIKEY];
        NSLog(@"%@", urlString);
        //2) make a network request
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSession *session = [NSURLSession sharedSession];
        __weak MapViewController *weakSelf = self;
        self.polyline.map = nil;
        self.polyline = nil;
        
        NSURLSessionDataTask *directionsTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            //3) parse json response
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //handle ZERO_RESULTS
            NSString *status = json[@"status"];
            
            if (!error && [status isEqualToString:@"OK"]) {
                weakSelf.steps = json[@"routes"][0][@"legs"][0][@"steps"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //polyline
                    GMSPath *path = [GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
                    weakSelf.polyline = [GMSPolyline polylineWithPath:path];
                    weakSelf.polyline.strokeColor = [UIColor blackColor];
                    weakSelf.polyline.strokeWidth = 3.0f;
                    weakSelf.polyline.map = weakSelf.mapView;
                });
                
                // NSArray *test = [json valueForKeyPath:@"routes.legs.steps.html_instructions"];
                NSLog(@"steps.count %lu", weakSelf.steps.count);
            } else {
                [self alertUserNoRouteAvailable];
                NSLog(@"do something if no route");
            }
        }];
        [directionsTask resume];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.polyline.map = nil;
    self.polyline = nil;
}

- (void)alertUserNoRouteAvailable {
    
    __weak MapViewController *weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No route available" message:@"Sorry, Google can't show a route." preferredStyle:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)showStreetView:(id)sender {
    
}

- (void)showDirections:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
