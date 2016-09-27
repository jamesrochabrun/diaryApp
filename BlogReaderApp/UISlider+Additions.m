//
//  UISlider+Additions.m
//  ooApp
//
//  Created by James Rochabrun on 8/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.//

#import "UISlider+Additions.h"

@implementation UISlider (Additions)

+ (UISlider *)sliderWithMinValue:(float)minValue minTrackTintColor:(UIColor *)minTrackTintColor andMaxValue:(float)maxValue maxTrackTintColor:(UIColor *)maxTrackTintColor continuous:(BOOL)continuous {
    
    UISlider *slider = [UISlider new];
    slider.minimumValue = minValue;
    slider.minimumTrackTintColor = minTrackTintColor;
    slider.maximumValue = maxValue;
    slider.maximumTrackTintColor = maxTrackTintColor;
    slider.continuous = continuous;
    return slider;
}


@end
