//
//  StreetVCViewController.h
//  momentum
//
//  Created by James Rochabrun on 11/4/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THDiaryEntry;
@import GoogleMaps;


@interface StreetVCViewController : UIViewController
@property (nonatomic) BOOL street;
@property (nonatomic, strong) THDiaryEntry *entry;
@property (nonatomic, strong) NSArray *steps;

@end
