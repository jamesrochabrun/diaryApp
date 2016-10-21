//
//  DetailViewController.h
//  secretdiary
//
//  Created by James Rochabrun on 01-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@class THDiaryEntry;

@interface DetailViewController : UIViewController
@property (nonatomic, strong) THDiaryEntry *entry;



@end
