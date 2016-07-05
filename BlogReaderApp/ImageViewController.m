//
//  ImageViewController.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "ImageViewController.h"
#import "UIFont+CustomFont.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageWithData: self.pickedImage];
    self.messageLabel.font = [UIFont regularFont:20];
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

- (IBAction)shareButtonPressed:(UIBarButtonItem *)sender {
    
    NSURL *shareLink = [[NSURL alloc] initWithString:@"https://itunes.apple.com/us/app/blogdiary/id1119667410?l=es&ls=1&mt=8"];
    UIImage *shareImage = [UIImage imageWithData:self.pickedImage];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[shareLink,shareImage]
                                      applicationActivities:nil];
    
    [activityViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [activityViewController setExcludedActivityTypes:@[UIActivityTypePostToWeibo,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeMessage]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:activityViewController animated:YES completion:nil];
    });
    
}



@end
