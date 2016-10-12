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
#import "Common.h"

@interface ImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setting up the scrollView
    _scrollView = [UIScrollView new];
    _scrollView.bouncesZoom = YES;
    _scrollView.delegate = self;
    _scrollView.clipsToBounds = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = 1.0;//This is the minimum scale, set it to whatever you want. 1.0 = default
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.minimumZoomScale = minimumScale;
    _scrollView.zoomScale = minimumScale;
    [_scrollView setContentMode:UIViewContentModeScaleAspectFit];
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;

    [self.view addSubview:_scrollView];
    
    //Setting up the imageView
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageWithData: self.entry.image];
    _imageView.userInteractionEnabled = YES;
    _imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    
    //Adding gesture recognizer
    [_imageView addGestureRecognizer:doubleTap];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    CGRect frame = _scrollView.frame;
    frame.size.height = height(self.view);
    frame.size.width = width(self.view);
    frame.origin.x = 0;
    frame.origin.y = 0;
    _scrollView.frame = frame;
//    
//    frame = _imageView.frame;
//    frame.size.height = _imageView.image.size.height;
//    frame.size.width = _imageView.image.size.width;
//    frame.origin.x = 0;
//    frame.origin.y = 0;
//    _imageView.frame = frame;
    
    frame = _imageView.frame;
    if (_imageView.image.size.height > _imageView.image.size.width) {
        frame.size.width = _imageView.image.size.width * width(self.view) /_imageView.image.size.height;
        frame.size.height = width(self.view);
    } else {
        frame.size.height = _imageView.image.size.height * width(self.view)/_imageView.image.size.width;
        frame.size.width = width(self.view);
    }
    frame.origin.x = (width(self.view) - frame.size.width)/2;
    frame.origin.y = (height(_scrollView) - frame.size.height)/2;
    _imageView.frame = frame;
    
    [_scrollView setContentSize:CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height)];

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

#pragma scrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // zoom in
    float newScale = [_scrollView zoomScale] * 1.3;//ZOOM_STEP;
    
    if (newScale > self.scrollView.maximumZoomScale){
        newScale = self.scrollView.minimumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [_scrollView zoomToRect:zoomRect animated:YES];
        
    }
    else{
        
        newScale = self.scrollView.maximumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [_scrollView zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [_scrollView frame].size.height / scale;
    zoomRect.size.width  = [_scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}



@end
