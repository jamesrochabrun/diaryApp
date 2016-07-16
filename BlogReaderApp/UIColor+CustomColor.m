//
//  UIColor+CustomColor.m
//  secretdiary
//
//  Created by James Rochabrun on 01-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

+ (UIColor*)mainColor {
    return [UIColor colorWithRed:0.0049 green:0.0049 blue:0.0049 alpha:1.0];
}

+ (UIColor*)newGrayColor {
    return [UIColor colorWithRed:0.471 green:0.4537 blue:0.3451 alpha:1.0];
}

+ (UIColor*)alertColor {
    return [UIColor colorWithRed:0.9882 green:0.3389 blue:0.3428 alpha:1.0];
}

@end
