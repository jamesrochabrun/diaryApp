//
//  UIView+Additions.h
//  secretdiary
//
//  Created by James Rochabrun on 9/26/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

+ (UIView *)viewWithBackgroundColor:(UIColor *)color inParentView:(UIView *)parent;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


@end
