//
//  FilterSettings.h
//  ooApp
//
//  Created by James Rochabrun on 8/28/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FilterSettings : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat defaultValue;
@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, assign) BOOL touched;
@property (nonatomic, assign) CGFloat displayNumber;


- (instancetype)initWithName:(NSString *)name minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue defaultValue:(CGFloat)defaultValue value:(CGFloat)value touched:(BOOL)touched displayName:(NSString *)displayName;
@end
