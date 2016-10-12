//
//  UIImage+UIImage.h
//  secretdiary
//
//  Created by James Rochabrun on 9/26/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage)
+ (UIImage *)imageFromView:(UIView *)v;
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
@end
