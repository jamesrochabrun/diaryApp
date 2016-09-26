//
//  FilterViewController.m
//  secretdiary
//
//  Created by James Rochabrun on 9/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "FilterViewController.h"
#import "TopView.h"
#import "CommonUIConstants.h"
#import "Common.h"

@interface FilterViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"the image %@", _pickedImage);

    _imageView = [UIImageView new];
    _imageView.image = _pickedImage;
    [self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect frame = _imageView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 200;
    _imageView.frame = frame;
    
}
- (IBAction)doneWasPressed:(UIBarButtonItem *)sender {
    
    __weak FilterViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}



@end
