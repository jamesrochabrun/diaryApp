//
//  ImageViewController.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageWithData: self.pickedImage];
    self.messageLabel.font = [UIFont fontWithName:@"GOTHAM Narrow" size:20];
    [self showOrHideLabel];
}

- (IBAction)dismissViewcontroller:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showOrHideLabel {
    
    if (self.pickedImage == nil) {
        self.messageLabel.hidden = NO;
    } else {
        self.messageLabel.hidden = YES;
    }
}


@end
