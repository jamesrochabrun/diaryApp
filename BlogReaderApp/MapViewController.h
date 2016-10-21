//
//  MapViewController.h
//  momentum
//
//  Created by James Rochabrun on 10/20/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class THDiaryEntry;

@interface MapViewController : UIViewController
@property (nonatomic, strong) THDiaryEntry *entry;

@end
