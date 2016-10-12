//
//  FilterSettings.m
//  ooApp
//
//  Created by James Rochabrun on 8/28/16.
//  Copyright © 2016 Oomami Inc. All rights reserved.
//

#import "FilterSettings.h"
#import "CommonUIConstants.h"

@implementation FilterSettings

- (instancetype)initWithName:(NSString *)name minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue defaultValue:(CGFloat)defaultValue value:(CGFloat)value touched:(BOOL)touched displayName:(NSString *)displayName {
    
    self = [super init];
    
    if (self) {
        _name = name;
        _minValue = minValue;
        _maxValue = maxValue;
        _defaultValue = defaultValue;
        _value = value;
        _touched = touched;
        _filter = [CIFilter filterWithName:name];
        _displayName = displayName;
        _displayNumber = kMaxDisplay /fabs(maxValue);
    }
    
    return self;
}

@end
