//
//  UISlider+Additions.h
//  ooApp
//
//  Created by James Rochabrun on 8/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.//

#import <UIKit/UIKit.h>

@interface UISlider (Additions)
+ (UISlider *)sliderWithMinValue:(float)minValue minTrackTintColor:(UIColor *)minTrackTintColor andMaxValue:(float)maxValue maxTrackTintColor:(UIColor *)maxTrackTintColor continuous:(BOOL)continuous;
@end
