//
//  UIFont+CustomFont.m
//  secretdiary
//
//  Created by James Rochabrun on 01-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

+ (UIFont*)regularFont:(NSInteger)size{
    return [UIFont fontWithName:@"GothamNarrow-Book" size:size];
}

+ (UIFont*)MediumFont:(NSInteger)size {
    return [UIFont fontWithName:@"GothamMedium" size:size];
}



@end
