//
//  ImageViewController.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "ImageViewController.h"
#import "UIFont+CustomFont.h"
#import "THDiaryEntry.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = [UIImage imageWithData: self.entry.image];
    
}

- (IBAction)dismissViewcontroller:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonPressed:(UIBarButtonItem *)sender {
    
    NSURL *shareLink = [[NSURL alloc] initWithString:@"https://itunes.apple.com/us/app/blogdiary/id1119667410?l=es&ls=1&mt=8"];
    UIImage *shareImage = [UIImage imageWithData:self.entry.image];
    
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
