//
//  DetailViewController.m
//  secretdiary
//
//  Created by James Rochabrun on 01-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DetailViewController.h"
#import "THDiaryEntry.h"
#import "THEntryViewcontroller.h"
#import "ImageViewController.h"
#import "DoubleTapImage.h"
#import "THCoreDataStack.h"
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"
#import "Common.h"
#import "CommonUIConstants.h"
#import "THCoreDataStack.h"


static NSString *shareURL = @"https://itunes.apple.com/us/app/momentumapp/id1164714008?l=es&ls=1&mt=8";


@interface DetailViewController ()<DoubleTapImagedelegate,UIScrollViewDelegate,MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) UIButton *isFavoriteButton;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *moodImageView;
@property (nonatomic, strong) UIButton *zoomButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *entryText;
@property (nonatomic , strong) UIImage *frameImage;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL showMap;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.entry == nil) {
        NSLog(@"%@", self.entry);
    }
    
    _scrollView = [UIScrollView new];
    _scrollView.bouncesZoom = YES;
    _scrollView.delegate = self;
    //_scrollView.clipsToBounds = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    float minimumScale = 1.0;//This is the minimum scale, set it to whatever you want. 1.0 = default
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.minimumZoomScale = minimumScale;
    _scrollView.zoomScale = minimumScale;
  //  [_scrollView setContentMode:UIViewContentModeScaleAspectFit];
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview:_scrollView];
    
    _frameImage = [UIImage imageWithData:_entry.image];
    
    _mainImageView = [UIImageView new];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds = YES;
    _mainImageView.userInteractionEnabled = YES;
    _mainImageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);

    _mainImageView.image = _frameImage;
    [_scrollView addSubview:_mainImageView];
    
    _optionsButton = [UIButton new];
    [_optionsButton addTarget:self action:@selector(showOptions) forControlEvents:UIControlEventTouchUpInside];
    [_optionsButton setImage:[UIImage imageNamed:@"options"] forState:UIControlStateNormal];
    [_scrollView addSubview:_optionsButton];
    
    _moodImageView = [UIImageView new];
    [_mainImageView addSubview:_moodImageView];
    
    _isFavoriteButton = [UIButton new];
    [_isFavoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    [_isFavoriteButton setImage:[UIImage imageNamed:@"favoriteFull"] forState:UIControlStateSelected];
    [_isFavoriteButton addTarget:self action:@selector(onFavoriteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.isFavoriteButton];
    
    BOOL isFavorite = [_entry.isFavorite boolValue];
    
    if (isFavorite) {
        [_isFavoriteButton setSelected:YES];
    } else {
        [_isFavoriteButton setSelected:NO];
    }
    
    _zoomButton = [UIButton new];
    [_zoomButton setImage:[UIImage imageNamed:@"zoom"] forState:UIControlStateNormal];
    [_zoomButton addTarget:self action:@selector(onZoomButtonPressed) forControlEvents:UIControlEventTouchUpInside];
   // [_scrollView addSubview:_zoomButton];
    
    _dateLabel = [UILabel new];
    _dateLabel.textColor = [UIColor newGrayColor];
    _dateLabel.font = [UIFont regularFont:17];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_entry.date];
    _dateLabel.text = [dateFormatter stringFromDate:date];
    [_scrollView addSubview:_dateLabel];
    
    _locationLabel = [UILabel new];
    _locationLabel.textColor = [UIColor newGrayColor];
    _locationLabel.font = [UIFont regularFont:17];
    _locationLabel.text = self.entry.location;
    [_scrollView addSubview:_locationLabel];
    
    _entryText = [UITextView new];
    _entryText.showsVerticalScrollIndicator = NO;
    _entryText.userInteractionEnabled = NO;
    _entryText.font = [UIFont regularFont:15];
    _entryText.textColor = [UIColor newGrayColor];
    _entryText.scrollEnabled = NO;
    _entryText.text = self.entry.body;
    [_scrollView addSubview:_entryText];

    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    
    //Adding gesture recognizer
    [_mainImageView addGestureRecognizer:doubleTap];
        
    _mapView = [MKMapView new];
    _mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    [_scrollView addSubview:_mapView];
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation]; //Will update location immediately
    
    UITapGestureRecognizer *showMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMapX)];
    //showMap.numberOfTapsRequired = 2;
    [_mapView addGestureRecognizer:showMap];
}

- (void)displayAlertInVC:(UIAlertController *)alertController {
    
    __weak DetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)showMapX {
    
    _showMap = !_showMap;
    
    __weak DetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
            [UIView animateWithDuration:kPanVelocity delay:0.5 options:kUIViewAnimationOption animations:^{

            
            if (weakSelf.showMap) {
                
                CGRect frame = weakSelf.mapView.frame;
                frame.size.height = height(weakSelf.view);
                frame.size.width = width(weakSelf.view);
                frame.origin.x = 0;
                frame.origin.y = 0;
                weakSelf.mapView.frame = frame;
            } else {
              //  [weakSelf.view setNeedsLayout];
                
                CGRect frame = _mapView.frame;
                frame.origin.x = 0;
                frame.origin.y = CGRectGetMaxY(_entryText.frame) + kGeomMarginSmall;
                frame.size.height = 150;
                frame.size.width = width(self.view);
                _mapView.frame = frame;
            }
            
            
        } completion:nil];
        

    });
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
    [_locationManager stopUpdatingLocation];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    CGRect frame = _scrollView.frame;
    frame.size.width = width(self.view);
    frame.size.height = height(self.view);
    frame.origin.x = 0;
    frame.origin.y = 0;
    _scrollView.frame = frame;

    frame = _mainImageView.frame;
    if (_frameImage.size.height > _frameImage.size.width) {
        frame.size.width = _frameImage.size.width * width(self.view) / _frameImage.size.height;
        frame.size.height = width(self.view);
    } else {
        frame.size.height =  _frameImage.size.height * width(self.view)/ _frameImage.size.width;
        frame.size.width = width(self.view);
    }
    frame.origin.x = (width(self.view) - frame.size.width)/2;
    frame.origin.y = 0;
    _mainImageView.frame = frame;
    
    frame = _moodImageView.frame;
    frame.size.width = kGeomDismmissButton;
    frame.size.height = kGeomDismmissButton;
    frame.origin.x = originX(self.view) + kGeomMarginMedium;
    frame.origin.y = originY(self.view) + kGeomMarginMedium;
    _moodImageView.frame = frame;
    
    frame = _optionsButton.frame;
    frame.size.height = 30;
    frame.size.width = 50;
    frame.origin.x = CGRectGetMaxX(self.view.frame) - kGeomMarginDismissButton - kGeomMarginBig;
    frame.origin.y = CGRectGetMaxY(_mainImageView.frame) + kGeomMarginMedium;
    _optionsButton.frame = frame;
    
//    frame = _mainImageView.frame;
//    frame.size.height = width(self.view);
//    frame.size.width = width(self.view);
//    frame.origin.x = 0;
//    frame.origin.y = 0;
//    _mainImageView.frame = frame;
    
    [_locationLabel sizeToFit];
    frame = _locationLabel.frame;
    frame.origin.x = (width(self.view) - width(_locationLabel)) /2;
    frame.origin.y = CGRectGetMaxY(_optionsButton.frame) + kGeomMarginSmall;
    _locationLabel.frame = frame;
    
    [_dateLabel sizeToFit];
    frame = _dateLabel.frame;
    frame.origin.x = (width(self.view) - width(_dateLabel)) /2;
    frame.origin.y = CGRectGetMaxY(_locationLabel.frame) + kGeomMarginSmall;
    _dateLabel.frame = frame;
    
    [self textViewDidChange:_entryText];
    
    frame = _isFavoriteButton.frame;
    frame.size.height = kGeomDismmissButton;
    frame.size.width = kGeomDismmissButton;
    frame.origin.x = CGRectGetMaxX(_mainImageView.frame) - frame.size.width - kGeomMarginMedium;
    frame.origin.y = CGRectGetMaxY(_mainImageView.frame) - frame.size.height - kGeomMarginMedium;
    _isFavoriteButton.frame = frame;

    frame = _mapView.frame;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(_entryText.frame) + kGeomMarginSmall;
    frame.size.height = 150;
    frame.size.width = width(self.view);
    _mapView.frame = frame;
    
    _scrollView.contentSize = CGSizeMake(width(self.view), CGRectGetMaxY(_mapView.frame));

}


- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat fixedWidth = width(self.view) * 0.8;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    newFrame.origin.x = (width(self.view) - fixedWidth) /2;
    newFrame.origin.y = CGRectGetMaxY(_dateLabel.frame) + kGeomMarginMedium;
    textView.frame = newFrame;
}

- (void)displayData {
    
    if(self.entry.mood == DiaryEntryMoodGood) {
        _moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if (self.entry.mood == DiaryEntryMoodAverage) {
        _moodImageView.image = [UIImage imageNamed:@"icn_average"];
    } else if (self.entry.mood == DiaryEntryMoodBad) {
        _moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }
    
    _entryText.text = self.entry.body;
    
    __weak DetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf textViewDidChange:_entryText];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    
    __weak DetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^(void){
    [weakSelf displayData];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//remeber with buttons the file dont need ibactions just define the segue identifiers to perform the action (pass the data);
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual :@"showImage"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ImageViewController *controller = (ImageViewController*)navigationController.topViewController;
        controller.entry = self.entry;
    } else {
        UINavigationController *navigationController = segue.destinationViewController;
        THEntryViewcontroller *entryViewController = (THEntryViewcontroller*)navigationController.topViewController;
        entryViewController.editMode = YES;
        entryViewController.entry = self.entry;
    }
}

- (void)onFavoriteButtonPressed {
    
    BOOL isFavorite = [self.entry.isFavorite boolValue];
    if (!isFavorite) {
        [self.isFavoriteButton setSelected:YES];
        [self changingIsFavoriteToTrue];
    } else {
        [self.isFavoriteButton setSelected:NO];
        [self changingIsFavoriteToFalse];
    }
}

- (void)onZoomButtonPressed {
    
    __weak DetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [weakSelf performSegueWithIdentifier:@"showImage" sender:self.zoomButton];
    });
}

- (void)changingIsFavoriteToTrue {
    
    BOOL myBool = YES;
    self.entry.isFavorite = [NSNumber numberWithBool:myBool];
    
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [coreDataStack saveContext];
    
    __weak DetailViewController *weakSelf = self;
    UIAlertController *alertSaved = [UIAlertController alertControllerWithTitle:@"Added to favorite moments!" message:@"You can revisit this entry in your favorites section" preferredStyle:UIAlertControllerStyleAlert];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertSaved animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertSaved dismissViewControllerAnimated:YES completion:nil];
        });
    });

}

- (void)changingIsFavoriteToFalse {
   
    BOOL myBool = NO;
    self.entry.isFavorite = [NSNumber numberWithBool:myBool];
    
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [coreDataStack saveContext];
}


#pragma scrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _mainImageView;
}


#pragma mark TapDetectingImageViewDelegate methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    float newScale = [_scrollView zoomScale] * 1.3;//ZOOM_STEP;
    
    if (newScale > self.scrollView.maximumZoomScale){
        newScale = self.scrollView.minimumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [_scrollView zoomToRect:zoomRect animated:YES];
    }
    else{    // zoom in

        newScale = self.scrollView.maximumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [_scrollView zoomToRect:zoomRect animated:YES];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    
    __weak DetailViewController *wekSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wekSelf updateUI:YES];
    });
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    if (scale == scrollView.minimumZoomScale) {
        __weak DetailViewController *wekSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wekSelf updateUI:NO];
        });
    }
}

- (void)updateUI:(BOOL)zoom {
    
    __weak DetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (zoom) {
            weakSelf.isFavoriteButton.hidden =
            weakSelf.moodImageView.hidden =
            weakSelf.dateLabel.hidden =
            weakSelf.locationLabel.hidden =
            weakSelf.optionsButton.hidden =
            weakSelf.mapView.hidden =
            weakSelf.entryText.hidden = YES;
            
        } else {
            weakSelf.isFavoriteButton.hidden =
            weakSelf.moodImageView.hidden =
            weakSelf.dateLabel.hidden =
            weakSelf.locationLabel.hidden =
            weakSelf.optionsButton.hidden =
            weakSelf.mapView.hidden =
            weakSelf.entryText.hidden = NO;
            [weakSelf.view setNeedsLayout];
        }
    });
}

//
//#pragma mark Utility methods
//
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

- (void)showOptions {
    
    UIAlertController *options = [UIAlertController alertControllerWithTitle:nil
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *Share = [UIAlertAction actionWithTitle:@"Share Photo"
                                                    style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                        [self shareImage];
                                                    }];
    UIAlertAction *Save = [UIAlertAction actionWithTitle:@"Save In Camera Roll"
                                                   style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                       
                                                       [self saveImegeInPhotoRoll];
                                                   }];
    
    UIAlertAction *Delete = [UIAlertAction actionWithTitle:@"Delete Entry"
                                                     style: UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                         [self removeEntryFromCoreData];
                                                     }];
    
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style: UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                         
                                                     }];
    
    
    [options addAction:Share];
    [options addAction:Save];
    [options addAction:Delete];
    [options addAction:Cancel];
    
    __weak DetailViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:options animated:YES completion:nil];
    });
}

- (void)saveImegeInPhotoRoll {
    
    UIImageWriteToSavedPhotosAlbum(_frameImage, nil, nil, nil);
    [self imageSavedInPhotoRollAlert];
}


- (void)shareImage {
    
    NSURL *shareLink = [[NSURL alloc] initWithString:shareURL];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[shareLink,_frameImage]
                                      applicationActivities:nil];
    
    [activityViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [activityViewController setExcludedActivityTypes:@[UIActivityTypePostToWeibo,
                                                       UIActivityTypeCopyToPasteboard,
                                                       UIActivityTypeMessage]];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:activityViewController animated:YES completion:nil];
    });
}


- (void)removeEntryFromCoreData {
    
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:_entry];
    [coreDataStack saveContext];
    
    __weak DetailViewController *weakSelf = self;
    UIAlertController *alertDeleted = [UIAlertController alertControllerWithTitle:@"Entry Deleted." message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertDeleted animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alertDeleted dismissViewControllerAnimated:YES completion:^{
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    });
}

- (void)imageSavedInPhotoRollAlert {
    
    __weak DetailViewController *weakSelf = self;
    UIAlertController *alertSaved = [UIAlertController alertControllerWithTitle:@"Image saved in your library." message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertSaved animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertSaved dismissViewControllerAnimated:YES completion:nil];
        });
    });
}


#pragma mapKit
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(nonnull MKUserLocation *)userLocation {
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
   // NSLog(@"the latitude is %@ , and the longitude is %@", _charterService.latitude , _charterService.longitude);
    
    point.coordinate = CLLocationCoordinate2DMake([self.entry.latitude doubleValue], [self.entry.longitude doubleValue]);
    point.title = @"Departure point";
    // point.subtitle = @"Richmond";
    
    [self.mapView setRegion:MKCoordinateRegionMake(point.coordinate, MKCoordinateSpanMake(0.8f, 0.8f)) animated:YES];
    
    [self.mapView addAnnotation:point];
}



@end
