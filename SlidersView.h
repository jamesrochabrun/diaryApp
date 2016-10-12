//
//  SlidersView.h
//  ooApp
//
//  Created by James Rochabrun on 8/21/16.
//  Copyright © 2016 Oomami Inc. All rights reserved.
//

@class FilterSettings;

#import <UIKit/UIKit.h>

@interface SlidersView : UIView
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) FilterSettings *settings;
@property (nonatomic, assign) BOOL touched;
@property (nonatomic, strong) UILabel *valueLabel;


@end
