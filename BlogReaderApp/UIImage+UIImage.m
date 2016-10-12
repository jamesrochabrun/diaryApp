//
//  UIImage+UIImage.m
//  secretdiary
//
//  Created by James Rochabrun on 9/26/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "UIImage+UIImage.h"

@implementation UIImage (UIImage)

+ (UIImage *)imageFromView:(UIView *)v {
    UIGraphicsBeginImageContextWithOptions(v.frame.size, NO, 0.0);
    //UIGraphicsBeginImageContext(v.frame.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    rect.size.height = rect.size.height * [image scale];
    rect.size.width = rect.size.width * [image scale];
    rect.origin.x = rect.origin.x * [image scale];
    rect.origin.y = rect.origin.y * [image scale];
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[image scale] orientation:[image imageOrientation]];
    CGImageRelease(newImageRef);
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
