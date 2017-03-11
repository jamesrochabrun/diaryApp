//
//  ImageDetail.m
//  momentum
//
//  Created by James Rochabrun on 3/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

#import "ImageDetail.h"

@implementation ImageDetail

//- (id)init {
//    self = [super init];
//    if (self) {
//        [self loadImageData];
//    }
//    return  self;
//}

//@synthesize idImage, author, images, ruta_thumbnail, thumbnailData, emailfriend, imageData, imageSizeH;
//
//- (void) loadImageData {
//    NSURL *url = [NSURL URLWithString:self.images];
//    self.imageData = [NSData dataWithContentsOfURL:url];
//
//    UIImage *img = [UIImage imageWithData:self.imageData];
//
//    CGFloat y = (152 * 100)/ img.size.width;
//    self.imageSizeH = (img.size.height * y)/100;
//
//    self.thumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ruta_thumbnail]];
//}

- (void) loadImageData {
    
    UIImage *img = [UIImage imageNamed:self.images];
    
    NSLog(@"the image width = %f", img.size.width);
    
    CGFloat width = img.size.width <= 0.0 ? 960.0 : img.size.width;
    
    CGFloat y = (152 * 100)/ width;
    self.imageSizeH = (img.size.height * y)/100;
    
    NSLog(@"self.images = %@", self.images);
    NSLog(@" y = %f", y);
    NSLog(@"self.imagesize: %f" , self.imageSizeH);
    
    
    // self.thumbnailData = img;
}

@end
