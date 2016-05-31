//
//  ImageViewController.h
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (nonatomic,strong) NSData *pickedImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
