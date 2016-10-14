//
//  LocationManager.m
//  secretdiary
//
//  Created by James Rochabrun on 10/11/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "LocationManager.h"
#import "Common.h"

@implementation LocationManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (void)displayAlertAskingforUserPermission {
    
    UIAlertController *a= [UIAlertController alertControllerWithTitle:@"This app needs access to your location"
                                                              message:@"Allow it to add the location to your memories"
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Not now"
                                                     style: UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                         //donothing
                                                     }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Go"
                                                 style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     
                                                     if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                                                     [_locationManager requestWhenInUseAuthorization];
                                                     } else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                                                     [_locationManager requestAlwaysAuthorization];
                                                     }
                                                 }];
    [a addAction:cancel];
    [a addAction:ok];
    
    [self.delegate displayAlertInVC:a];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking granting location access!");
            [_locationManager startUpdatingLocation]; // this will access location automatically if user granted access manually. and will not show apple's request alert twice. (Tested)
            [self displayAlertAskingforUserPermission];

        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied location access request!!");
            // show text on label
            [self displayAlertIfAuthoriztionIsDenied];
            [_locationManager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            // clear text
            [_locationManager startUpdatingLocation]; //Will update location immediately
            NSLog(@"yes located");
        } break;
        default:
            break;
    }
}

- (void)displayAlertIfAuthoriztionIsDenied {
    
    UIAlertController *a= [UIAlertController alertControllerWithTitle:@"Please go to your settings and allow access to your location"
                                                              message:@"In order to create a great memory, we need to add the location to it. :)"
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style: UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                         //donothing
                                                         
                                                     }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Go"
                                                 style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     [Common goToSettings:kAppSettingsLocation];
                               
                                                 }];
    [a addAction:cancel];
    [a addAction:ok];
    
    [self.delegate displayAlertInVC:a];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    CLGeocoder *geocoer = [[CLGeocoder alloc]init];
    [geocoer reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        _locationString = placeMark.name;
    }];
}








@end
