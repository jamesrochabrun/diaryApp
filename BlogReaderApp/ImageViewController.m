//
//  ImageViewController.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageWithData: self.pickedImage];
    
}





@end
