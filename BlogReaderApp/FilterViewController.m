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
#import "SlidersView.h"
#import "FilterSettings.h"
#import "ListCVFL.h"
#import "UICollectionView+Additions.h"
#import "FilterThumbnailCVCell.h"
#import "UIImage+UIImage.h"
#import "UIView+Additions.h"

@interface FilterViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) CIContext *context;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *listsLayout;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIImageView *croppedIV;

@property (nonatomic, assign) BOOL filterMode;
@property (nonatomic, assign) BOOL cropMode;
@property (nonatomic, strong) UIView *cropView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) SlidersView *sliderView;
@property (nonatomic) NSUInteger selectedFilter;

//edition filters
@property (nonatomic, strong) FilterSettings *saturationSettings;
@property (nonatomic, strong) FilterSettings *brightnessSettings;
@property (nonatomic, strong) FilterSettings *vignetteSettings;
@property (nonatomic, strong) FilterSettings *sharpnessSettings;
@property (nonatomic, strong) FilterSettings *shadowSettings;
@property (nonatomic, strong) FilterSettings *contrastSettings;
@property (nonatomic, strong) NSArray *editionFiltersArray;

//filters
@property (nonatomic, strong) FilterSettings *noFilterSettings;
@property (nonatomic, strong) FilterSettings *exposureSettings;
@property (nonatomic, strong) FilterSettings *vibrantSettings;
@property (nonatomic, strong) FilterSettings *chromeSettings;
@property (nonatomic, strong) FilterSettings *instantSettings;
@property (nonatomic, strong) FilterSettings *fadeSettings;
@property (nonatomic, strong) NSArray *filtersArray;

//ciimages
@property (nonatomic, strong) CIImage *inputImage;
@property (nonatomic, strong) CIImage *filteredImageThumbnail;

//crop
@property (nonatomic, strong) UIView *intersection;
@property (nonatomic, assign) CGFloat lastScale;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, assign) BOOL zoomInAndOut;
@property (nonatomic, strong) UILabel *infoLabel;
@end

static NSString * const FilterCelIdentifier = @"FilterCellIdentifier";


@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    
    _croppedIV = [UIImageView new];
    _croppedIV.contentMode = UIViewContentModeScaleAspectFit;
    //_croppedIV.backgroundColor = UIColorRGBA(kColorBackgroundTheme);
    _croppedIV.userInteractionEnabled = NO;
    _croppedIV.hidden = YES;
    
    _sliderView = [SlidersView new];
    _sliderView.backgroundColor = [UIColor whiteColor];
    [_sliderView.slider addTarget:self action:@selector(mainSlider:) forControlEvents:UIControlEventValueChanged];
    [_sliderView.slider addTarget:self action:@selector(mainSliderLetGo:) forControlEvents:UIControlEventTouchUpInside];
    _sliderView.hidden = YES;
    
    //edition Filters
    _saturationSettings = [[FilterSettings alloc] initWithName:kCIColorControls minValue:-kSaturationRange maxValue:kSaturationRange defaultValue:1 value:_sliderView.slider.value touched:NO displayName:@"Saturation"];
    
    _brightnessSettings = [[FilterSettings alloc] initWithName:kCIExposureAdjust minValue:-kBrightnessRange maxValue:kBrightnessRange defaultValue:0 value:_sliderView.slider.value touched:NO displayName:@"Brightness"];
    
    _shadowSettings = [[FilterSettings alloc] initWithName:kCIHighlightShadowAdjust minValue:-kShadowRange maxValue:kShadowRange defaultValue:0 value:_sliderView.slider.value touched:NO displayName:@"Shadow"];
    
    _contrastSettings = [[FilterSettings alloc] initWithName:kCIColorControls minValue:-kContrastRange maxValue:kContrastRange defaultValue:1 value:_sliderView.slider.value touched:NO displayName:@"Contrast"];
    
    _vignetteSettings = [[FilterSettings alloc] initWithName:kCIVignette minValue:0 maxValue:kVignetteRange defaultValue:0 value:_sliderView.slider.value touched:NO displayName:@"Vignette"];
    
    _sharpnessSettings = [[FilterSettings alloc] initWithName:kCISharpenLuminance minValue:0 maxValue:kSharpnessRange defaultValue:0 value:_sliderView.slider.value touched:NO displayName:@"Sharpness" ];
    
    _editionFiltersArray = @[_brightnessSettings, _contrastSettings, _saturationSettings, _sharpnessSettings, _vignetteSettings, _shadowSettings];
    
    //filters
    _noFilterSettings = [[FilterSettings alloc] initWithName:kCIGammaAdjust minValue:0 maxValue:0 defaultValue:1 value:0 touched:YES displayName:@"Normal"];
    [_noFilterSettings.filter setValue:@(_noFilterSettings.defaultValue) forKey:kInputPower];
    _exposureSettings = [[FilterSettings alloc] initWithName:kCIExposureAdjust minValue:0 maxValue:0 defaultValue:1 value:0 touched:NO displayName:@"Exposure"];
    [_exposureSettings.filter setValue:@(_exposureSettings.defaultValue) forKey:kInputEV];
    _vibrantSettings = [[FilterSettings alloc] initWithName:kCIPhotoEffectTransfer minValue:0 maxValue:0 defaultValue:0 value:0 touched:NO displayName:@"Vibrant"];
    _chromeSettings = [[FilterSettings alloc] initWithName:kCIPhotoEffectChrome minValue:0 maxValue:0 defaultValue:0 value:0 touched:NO displayName:@"Chrome"];
    _instantSettings = [[FilterSettings alloc] initWithName:kCIPhotoEffectInstant minValue:0 maxValue:0 defaultValue:0 value:0 touched:NO displayName:@"Instant"];
    _fadeSettings = [[FilterSettings alloc] initWithName:kCIPhotoEffectFade minValue:0 maxValue:0 defaultValue:0 value:0 touched:NO displayName:@"Fade"];
    _filtersArray = @[_noFilterSettings, _exposureSettings, _vibrantSettings, _chromeSettings, _instantSettings, _fadeSettings];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    [pinchGesture setDelegate:self];
    [_imageView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    [_imageView addGestureRecognizer:panGestureRecognizer];
    
    
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
    [tapTwice setDelegate:self];
    tapTwice.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:tapTwice];
    
    
    _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_filterButton setTitle:@"Filter" forState:UIControlStateNormal];
    [_filterButton addTarget:self action:@selector(showFilterMode:) forControlEvents:UIControlEventTouchUpInside];
    [_filterButton setSelected:YES];
    [_filterButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(showEditMode:) forControlEvents:UIControlEventTouchUpInside];
    [_editButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(goToFilterAndEditionMode) forControlEvents:UIControlEventTouchUpInside];
    
    _topView = [UIView new];
    _topView.userInteractionEnabled = NO;
    _topView.backgroundColor = [UIColor redColor];
    _bottomView = [UIView new];
    _bottomView.userInteractionEnabled = NO;
    _bottomView.backgroundColor = [UIColor redColor];
    
    _cropView = [UIView new];
    _cropView.userInteractionEnabled = NO;
    //_cropView.layer.borderColor = [UIColor blueColor].CGColor;
    // _cropView.layer.borderWidth = 1;
    _cropView.layer.masksToBounds = NO;
    _cropView.layer.shouldRasterize = YES;
    _filterMode = YES;
    
    _intersection = [UIView new];
    NSLog(@"the images is %@", _imageView.image);
    
    _croppedIV.image = _imageView.image;
    
    
    [self.view addSubview:_imageView];
    [self.view addSubview:_cropView];
    //_intersection.backgroundColor = UIColorRGBA(kColorGreen);
    [self.view addSubview:_croppedIV];
    [self.view addSubview:_intersection];
    
    [self.view addSubview:_topView];
    [self.view addSubview:_bottomView];
    [self.bottomView addSubview:_infoLabel];
    [self.view addSubview:_nextButton];
    [self.view addSubview:_editButton];
    [self.view addSubview:_filterButton];
    
    [self.view addSubview:_sliderView];
    
    _listsLayout = [[ListCVFL alloc] init];
    [_listsLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _collectionView = [UICollectionView collectionViewWithLayout:_listsLayout inView:self.view delegate:self];
    [_collectionView registerClass:[FilterThumbnailCVCell class] forCellWithReuseIdentifier:FilterCelIdentifier];
    
    //initializing the context
    _context = [CIContext contextWithOptions:nil];
    [self showCropMode];

}

- (void)showCropMode {
    
    _filterButton.hidden = YES;
    _editButton.hidden = YES;
    _collectionView.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    CGFloat w = width(self.view);
    CGFloat h = height(self.view);
    CGRect frame;
    
    frame = _filterButton.frame;
    frame.origin.x = 0;
    frame.size.width = w/2;
    frame.origin.y = h - kGeomHeightButton;
    frame.size.height = kGeomHeightButton;
    _filterButton.frame = frame;
    
    frame = _editButton.frame;
    frame.origin.x = CGRectGetWidth(_filterButton.frame);
    frame.size.width = w/2;
    frame.origin.y = h - kGeomHeightButton;
    frame.size.height = kGeomHeightButton;
    _editButton.frame = frame;
    
    frame = _collectionView.frame;
    frame.size = CGSizeMake(width(self.view), 120);
    frame.origin.x = (width(self.view) - width(self.view)) /2;
    frame.origin.y = CGRectGetMinY(_filterButton.frame) - frame.size.height;
    _collectionView.frame = frame;
    
    _sliderView.frame = CGRectMake(0, _collectionView.frame.origin.y , width(self.view), CGRectGetMinY(_filterButton.frame) - CGRectGetMinY(_collectionView.frame));
}

- (void)setPickedImage:(UIImage *)pickedImage {
    
    _pickedImage = pickedImage;
    _imageView.image = _pickedImage;
    [self initializeImageViewSize];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeImageViewSize {
    
    CGFloat vertical = height(self.view) - 100;
    CGFloat w = width(self.view);
    CGRect frame;
    
    frame = _imageView.frame;
    if (_imageView.image.size.height > _imageView.image.size.width) {
        frame.size.width = _imageView.image.size.width * width(self.view) /_imageView.image.size.height;
        frame.size.height = width(self.view);
    } else {
        frame.size.height = _imageView.image.size.height * width(self.view)/_imageView.image.size.width;
        frame.size.width = width(self.view);
    }
    frame.origin.x = (w - frame.size.width)/2;
    frame.origin.y = (vertical - frame.size.height)/2;
    _imageView.frame = frame;
    
    frame = _cropView.frame;
    frame.size.width = width(self.view);
    frame.size.height = width(self.view);
    frame.origin.x = (w - frame.size.width)/2;
    frame.origin.y = (vertical - frame.size.height)/2;
    _cropView.frame = frame;
    _croppedIV.frame = frame;
    
    frame = _topView.frame;
    frame.size.height = CGRectGetMinY(_cropView.frame);
    frame.size.width = width(self.view);
    frame.origin.y = 0;
    frame.origin.x = 0;
    _topView.frame = frame;
    
    frame = _bottomView.frame;
    frame.size.height = CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(_cropView.frame);
    frame.size.width = width(self.view);
    frame.origin.y = CGRectGetMaxY(_cropView.frame);
    frame.origin.x = 0;
    _bottomView.frame = frame;
    
    frame = _nextButton.frame;
    frame.size.height = kGeomHeightButton;
    frame.size.width = width(self.view);
    frame.origin.x = self.view.frame.origin.x;
    frame.origin.y = height(self.view) - kGeomHeightButton;
    _nextButton.frame = frame;

}

- (void)goToFilterAndEditionMode {
    
    _cropView.hidden = YES;
    _topView.hidden = YES;
    _bottomView.hidden = YES;
    _filterButton.hidden = NO;
    _editButton.hidden = NO;
    _collectionView.hidden = NO;
    _nextButton.hidden = YES;
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setTheCropViewImage];
    [self initializingTheFiltersWithCropViewImage];
    
    __weak FilterViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
}

- (void)initializingTheFiltersWithCropViewImage {
    
    UIImageView *thumbnailImageView = [UIImageView new];
    thumbnailImageView.image = _croppedIV.image;
    thumbnailImageView.frame = CGRectMake(0, 0, 70, 70);
    thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    thumbnailImageView.clipsToBounds = YES;
    UIImage *thumbnailImage = [UIImage imageFromView:thumbnailImageView];
    _filteredImageThumbnail = [CIImage imageWithCGImage:[thumbnailImage CGImage]];
    
    _inputImage = [CIImage imageWithCGImage:[_croppedIV.image CGImage]];
    NSLog(@"the croppediv.image is %@", _croppedIV.image);
    NSLog(@"the input image is %@", _inputImage);
    
    [_saturationSettings.filter setValue:_inputImage forKey:kCIInputImageKey];
    
    [_noFilterSettings.filter setValue:_inputImage forKey:kCIInputImageKey];
    [_exposureSettings.filter setValue:_inputImage forKey:kCIInputImageKey];
    [_vibrantSettings.filter setValue:_inputImage forKey:kCIInputImageKey];
    [_chromeSettings.filter setValue:_inputImage forKey:kCIInputImageKey];
    [_instantSettings.filter setValue:_inputImage forKey:kCIInputImageKey];
    [_fadeSettings.filter setValue:_inputImage forKey:kCIInputImageKey];
}

- (void)showFilterMode:(id)sender {
    
    if (_filterMode) {
        return;
    }
    if ([_filterButton.titleLabel.text isEqualToString:@"Reset"]) {
        
        [self resetEditingAction];
    } else {
        
        [_editButton setSelected:NO];
        [_filterButton setSelected:YES];
        _filterMode = YES;
    }
    __weak FilterViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
}

- (void)showEditMode:(id)sender {
    
    if ([_editButton.titleLabel.text isEqualToString:@"Done"]) {
        
        [_filterButton setSelected:NO];
        [self showSliderView:NO];
    } else {
        
        [_editButton setSelected:YES];
        [_filterButton setSelected:NO];
        _filterMode = NO;
    }
    __weak FilterViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.collectionView reloadData];
    });
}

- (void)showSliderView:(BOOL)show {
    
    if (show) {
        _collectionView.hidden = YES;
        _sliderView.hidden = NO;
        [_filterButton setTitle:@"Reset" forState:UIControlStateNormal];
        [_editButton setTitle:@"Done" forState:UIControlStateNormal];
        [_filterButton setSelected:YES];
        
    } else {
        _collectionView.hidden = NO;
        _sliderView.hidden = YES;
        [_filterButton setTitle:@"Filter" forState:UIControlStateNormal];
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
}

#pragma crop

- (void)setTheCropViewImage {
    
    _intersection.frame = CGRectIntersection(_imageView.frame, _cropView.frame);
    
    NSLog(@"the intersection frame is %@", NSStringFromCGRect(_intersection.frame));
    
    CGFloat scale = _imageView.image.size.width / CGRectGetWidth(_imageView.frame);

//    NSLog(@"_iv.image.size.width (%f) / _iv.frame.size.width (%f) =  scale (%f)", _iv.image.size.width,CGRectGetWidth(_iv.frame), scale);
    
    CGPoint oCO = CGPointMake(
                              fabs((CGRectGetMinX(_intersection.frame)-CGRectGetMinX(_imageView.frame)))*scale,
                              fabs((CGRectGetMinY(_intersection.frame)-CGRectGetMinY(_imageView.frame)))*scale);
    
    CGSize sCO = CGSizeMake(
                            (CGRectGetWidth(_intersection.frame))*scale,
                            (CGRectGetHeight(_intersection.frame))*scale);
    CGRect frame;
    frame.origin = oCO;
    frame.size = sCO;
    
//    NSLog(@"the frame CO is %@", NSStringFromCGRect(frame));
//    NSLog(@"the iv.frame is %@", NSStringFromCGRect(_iv.frame));
    
    UIImage *uiimage = [UIImage imageFromImage:_imageView.image inRect:frame];
    
    _imageView.hidden = YES;
    [_croppedIV setImage:uiimage];
    _croppedIV.hidden = NO;
    //_croppedIV.layer.borderColor = [UIColor purpleColor].CGColor;
    //_croppedIV.layer.borderWidth = 1;
   // NSLog(@"Sio:%@ cropped image size:%@", NSStringFromCGSize(_iv.image.size), NSStringFromCGSize(uiimage.size));
}

#pragma main filter methods (filter mode and edit mode)

- (void)applyFilter:(CIFilter *)filter {
    
    FilterThumbnailCVCell *cell = (FilterThumbnailCVCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedFilter inSection:0]];
    
    [cell setSelected:NO];
    
    for (FilterSettings *settings in _filtersArray) {
        if (filter == settings.filter) {
            settings.touched = YES;
        } else {
            settings.touched = NO;
        }
    }
    [self performFilterChain:filter];
}

- (void)mainSliderLetGo:(UISlider *)slider {
    
    for (FilterSettings *settings in _editionFiltersArray) {
        if (_sliderView.settings == settings) {
            if (floorf(fabs(slider.value * settings.displayNumber)) <= kSliderLetGoRange) {
                settings.value = 0;
                slider.value = 0;
                _sliderView.valueLabel.text = [NSString stringWithFormat:@"%.0f", settings.value * settings.displayNumber];
                if (settings.value == 0) {
                    settings.touched = NO;
                } else {
                    settings.touched = YES;
                }
            }
        }
    }
}

- (void)mainSlider:(UISlider *)slider {
    
    for (FilterSettings *settings in _editionFiltersArray) {
        
        if (_sliderView.settings == settings) {
            settings.value = slider.value;
            _sliderView.valueLabel.text = [NSString stringWithFormat:@"%.0f", settings.value * settings.displayNumber];
            if (settings.value == 0) {
                settings.touched = NO;
            } else {
                settings.touched = YES;
            }
        }
    }
    [self performFilterChain:nil];
}

- (void)resetEditingAction {
    
    for (FilterSettings *settings in _editionFiltersArray) {
        if (_sliderView.settings == settings) {
            settings.value = 0;
            _sliderView.slider.value = 0;
            _sliderView.valueLabel.text = [NSString stringWithFormat:@"%.0f", settings.value * settings.displayNumber];
            if (settings.value == 0) {
                settings.touched = NO;
            } else {
                settings.touched = YES;
            }
        }
    }
    [self performFilterChain:nil];
}

//main function for the filter chaining!!-
- (void)performFilterChain:(CIFilter *)filter {
    
    __weak FilterViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (filter) {
            [_saturationSettings.filter setValue:filter.outputImage forKey:kCIInputImageKey];
        }
        
        [weakSelf.saturationSettings.filter setValue:@(_saturationSettings.defaultValue + weakSelf.saturationSettings.value) forKey:kInputSaturation];
        
        //brightness
        [weakSelf.brightnessSettings.filter setValue:weakSelf.saturationSettings.filter.outputImage forKey:kCIInputImageKey];
        [weakSelf.brightnessSettings.filter setValue:@(weakSelf.brightnessSettings.value) forKey:kInputEV];
        
        //contrast
        [weakSelf.contrastSettings.filter setValue:weakSelf.brightnessSettings.filter.outputImage forKey:kCIInputImageKey];
        [weakSelf.contrastSettings.filter setValue:@(weakSelf.contrastSettings.defaultValue + weakSelf.contrastSettings.value) forKey:kInputContrast];
        
        //vignette
        [weakSelf.vignetteSettings.filter setValue:weakSelf.contrastSettings.filter.outputImage forKey:kCIInputImageKey];
        [weakSelf.vignetteSettings.filter setValue:@(weakSelf.vignetteSettings.value) forKey:kInputIntensity];
        [weakSelf.vignetteSettings.filter setValue:@(weakSelf.vignetteSettings.value / 10) forKey:kInputRadius];
        
        //sharpness
        [weakSelf.sharpnessSettings.filter setValue:weakSelf.vignetteSettings.filter.outputImage forKey:kCIInputImageKey];
        [weakSelf.sharpnessSettings.filter setValue:@(weakSelf.sharpnessSettings.value / 3) forKey:kInputSharpness];
        
        //Shadow
        [weakSelf.shadowSettings.filter setValue:weakSelf.sharpnessSettings.filter.outputImage forKey:kCIInputImageKey];
        [weakSelf.shadowSettings.filter setValue:@(- weakSelf.shadowSettings.value) forKey:kInputShadowAmount];
        
        [weakSelf setTheOutputImageInContext:weakSelf.shadowSettings.filter.outputImage];
    });
}

- (void)setTheOutputImageInContext:(CIImage *)outputImage {
    
    __weak FilterViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGImageRef cgimg = [weakSelf.context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        [weakSelf.croppedIV setImage:newImg];
        CGImageRelease(cgimg);
    });
}

#pragma collectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUInteger count;
    
    if (_filterMode) {
        count = _filtersArray.count;
    } else {
        count = _editionFiltersArray.count;
    }
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kGeomMinSpace;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(85, 100 + kGeomInterImageGap);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    if (_filterMode) {
        
        FilterSettings *settings = [_filtersArray objectAtIndex:row];
        [self applyFilter:settings.filter];
        
    } else {
        
        _sliderView.settings = [_editionFiltersArray objectAtIndex:row];
        [self showSliderView:YES];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterThumbnailCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCelIdentifier forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    CIImage *outputImage;
    
    if (_filterMode) {
        
        FilterSettings *settings = [_filtersArray objectAtIndex:row];
        cell.settings = settings;
        cell.filterType.text = settings.displayName;
        cell.editionType.text = nil;
        
        if (settings.touched) {
            cell.selectedView.hidden = NO;
            _selectedFilter = row;
        } else {
            cell.selectedView.hidden = YES;
        }
        
        switch (row) {
            case 0:
                outputImage = [self noFilter:_filteredImageThumbnail];
                break;
            case 1:
                outputImage = [self exposureAdjust:_filteredImageThumbnail];
                break;
            case 2:
                outputImage = [self toneCurveToLinear:_filteredImageThumbnail];
                break;
            case 3:
                outputImage = [self chromeEffect:_filteredImageThumbnail];
                break;
            case 4:
                outputImage = [self photoInstant:_filteredImageThumbnail];
                break;
            case 5:
                outputImage = [self fadeEffect:_filteredImageThumbnail];
                break;
            default:
                break;
        }
        
        __weak FilterThumbnailCVCell *weakCell = cell;
        __weak FilterViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            CGImageRef cgimg = [weakSelf.context createCGImage:outputImage fromRect:[outputImage extent]];
            UIImage *newImg = [UIImage imageWithCGImage:cgimg];
            [weakCell.imageView setImage:newImg];
            CGImageRelease(cgimg);
        });
    } else {
        
        cell.imageView.image = nil;//need assets
        cell.editionType.textColor = [UIColor blackColor];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        FilterSettings *settings = [_editionFiltersArray objectAtIndex:row];
        cell.settings = settings;
        cell.editionType.text = settings.displayName;
        cell.filterType.text = nil;
        if (settings.touched) {
            cell.selectedView.hidden = NO;
        } else {
            cell.selectedView.hidden = YES;
        }
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,kGeomSpaceEdge,0,kGeomSpaceEdge);
}


#pragma Gestures

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    UIView	*pannedView = [recognizer view];
    
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (pannedView.width <= _cropView.width || _imageView.height <= _cropView.height)
        {
            if (pannedView.left < _cropView.left - kInternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (_cropView.left + pannedView.width / 2 - kInternalOffset, pannedView.center.y);
                } completion:nil];
            }
            
            if (pannedView.top < _cropView.top - kInternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (pannedView.center.x, _cropView.top + pannedView.height / 2 - kInternalOffset);
                } completion:nil];
            }
            
            if (pannedView.right > _cropView.right + kInternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (_cropView.right - pannedView.width / 2 + kInternalOffset, pannedView.center.y);
                } completion:nil];
            }
            
            if (pannedView.bottom > _cropView.bottom + kInternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (pannedView.center.x, _cropView.bottom - pannedView.height / 2 + kInternalOffset);
                } completion:nil];
            }
        }
        else
        {
            if (pannedView.left > _cropView.left + kExternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (_cropView.left + pannedView.width / 2 + kExternalOffset, recognizer.view.center.y);
                } completion:nil];
                
            }
            
            if (pannedView.top > _cropView.top + kExternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (pannedView.center.x, _cropView.top + pannedView.height/2 + kExternalOffset);
                } completion:nil];
                
            }
            
            if (pannedView.left + pannedView.width < _cropView.left - kExternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (_cropView.left - pannedView.width/2 - kExternalOffset, pannedView.center.y);
                } completion:nil];
            }
            
            if (pannedView.bottom < _cropView.bottom - kExternalOffset)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    pannedView.center = CGPointMake (pannedView.center.x, _cropView.bottom - pannedView.height / 2 - kExternalOffset);
                } completion:nil];
            }
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (pannedView.width < _cropView.width)
        {
            if (pannedView.top >= _cropView.top)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    pannedView.center = CGPointMake (_cropView.center.x, _cropView.top + pannedView.height / 2);
                    NSLog(@" pan #1: %@" , NSStringFromCGPoint(pannedView.center));
                } completion:nil];
                return;
            }
            else if (pannedView.bottom <= _cropView.bottom)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    pannedView.center = CGPointMake (_cropView.center.x, _cropView.bottom - pannedView.height / 2);
                    NSLog(@" pan #2: %@" , NSStringFromCGPoint(pannedView.center));
                } completion:nil];
                return;
            }
            else
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    pannedView.center = CGPointMake (_cropView.center.x, pannedView.center.y );
                    NSLog(@"pan #3: %@" , NSStringFromCGPoint(pannedView.center));
                    
                } completion:nil];
                return;
            }
        }
        else if (pannedView.height < _cropView.height)
        {
            if (pannedView.top <= _cropView.top && pannedView.left >= _cropView.left)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    
                    NSLog(@"test1");
                    pannedView.center = CGPointMake (_cropView.left + pannedView.width / 2, _cropView.center.y);
                    
                } completion:nil];
                return;
            } else if ((pannedView.bottom >= _cropView.bottom && pannedView.left >= _cropView.left)) {
                
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    NSLog(@"test2");
                    pannedView.center = CGPointMake (_cropView.left + pannedView.width / 2, _cropView.center.y);
                    
                } completion:nil];
                return;
                
            } else if (pannedView.top <= _cropView.top && pannedView.right <= _cropView.right ) {
                
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    NSLog(@"test3");
                    
                    recognizer.view.center = CGPointMake (_cropView.right - pannedView.width / 2, _cropView.center.y);
                } completion:nil];
                return;
            } else if (pannedView.bottom >= _cropView.bottom && pannedView.right <= _cropView.right ) {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    NSLog(@"test4");
                    
                    recognizer.view.center = CGPointMake (_cropView.right - pannedView.width / 2, _cropView.center.y);
                } completion:nil];
                return;
                
            } else if (pannedView.bottom <= _cropView.bottom && pannedView.left >= _cropView.left) {
                
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    NSLog(@"test5");
                    pannedView.center = CGPointMake (_cropView.left + pannedView.width / 2, _cropView.center.y);
                    
                } completion:nil];
                return;
            } else if (pannedView.bottom <= _cropView.bottom && pannedView.right <= _cropView.right) {
                
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    NSLog(@"test6");
                    
                    recognizer.view.center = CGPointMake (_cropView.right - pannedView.width / 2, _cropView.center.y);
                } completion:nil];
                return;
            }
            else {
                
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    NSLog(@"test7");
                    
                    recognizer.view.center = CGPointMake (pannedView.center.x, _cropView.center.y);
                    
                } completion:nil];
                return;
            }
        }
        else
        {
            if (pannedView.left > _cropView.left && pannedView.top > _cropView.top)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    pannedView.center = CGPointMake (_cropView.left + pannedView.width / 2, _cropView.top + pannedView.height / 2);
                } completion:nil];
                return;
            }
            
            if (pannedView.right < _cropView.right && pannedView.top > _cropView.top)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    recognizer.view.center = CGPointMake (_cropView.right - pannedView.width / 2, _cropView.top + pannedView.height / 2);
                } completion:nil];
                return;
            }
            
            if (pannedView.right < _cropView.right && pannedView.bottom < _cropView.bottom)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    recognizer.view.center = CGPointMake (_cropView.right - pannedView.width / 2, _cropView.bottom - pannedView.height / 2);
                } completion:nil];
                return;
            }
            
            if (pannedView.left > _cropView.left && pannedView.bottom < _cropView.bottom)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    recognizer.view.center = CGPointMake (_cropView.left + pannedView.width / 2, _cropView.bottom - pannedView.height / 2);
                } completion:nil];
                return;
            }
            
            if (pannedView.left > _cropView.left)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    recognizer.view.center = CGPointMake (_cropView.left + pannedView.width / 2, pannedView.center.y);
                } completion:nil];
            }
            
            if (pannedView.top > _cropView.top)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    recognizer.view.center = CGPointMake (pannedView.center.x, _cropView.frame.origin.y + pannedView.height / 2);
                } completion:nil];
            }
            
            if (pannedView.right < _cropView.right)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    recognizer.view.center = CGPointMake (_cropView.right - pannedView.width / 2, pannedView.center.y);
                } completion:nil];
            }
            
            if (pannedView.bottom < _cropView.bottom)
            {
                [UIView animateWithDuration:kPanVelocity delay:kPanDelay options:kUIViewAnimationOption animations:^{
                    recognizer.view.center = CGPointMake (pannedView.center.x, _cropView.bottom - pannedView.height / 2);
                } completion:nil];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer {
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        _lastScale = [recognizer scale];
    }
    
    if ([recognizer state] == UIGestureRecognizerStateBegan ||
        [recognizer state] == UIGestureRecognizerStateChanged)
    {
        
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        // [self adjustAnchorPointForGestureRecognizer:recognizer];
        
        CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [recognizer view].transform = transform;
        } completion:nil];
        
        _lastScale = [recognizer scale];  // Store the previous scale factor for the next pinch gesture call
        
    }
    
    if ([recognizer state] == UIGestureRecognizerStateEnded) {
        
        if (_lastScale >= kMaxScale) {
            
            [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                recognizer.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
                
            } completion:^(BOOL finished) {
            }];
            _lastScale = kMaxScale;
        }
        
        if (_lastScale <= kMinScale && _imageView.frame.size.height <= _cropView.frame.size.height) {
            
            [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //recognizer.view.center = CGPointMake (self.view.center.x, self.view.center.y);
                recognizer.view.center = CGPointMake (self.cropView.center.x, self.cropView.center.y);
                recognizer.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            } completion:nil];
        }
    }
}

- (void)tapTwice:(UITapGestureRecognizer *)recognizer {
    
    _zoomInAndOut = !_zoomInAndOut;
    
    if (_zoomInAndOut) {
        
        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            recognizer.view.center = CGPointMake (self.cropView.center.x, self.cropView.center.y);
            recognizer.view.transform = CGAffineTransformMakeScale(1.35, 1.35);
        } completion:nil];
    } else {
        
        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            recognizer.view.center = CGPointMake (self.cropView.center.x, self.cropView.center.y);
            recognizer.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }
}


// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}


#pragma thumbnail filters

- (CIImage *)noFilter:(CIImage *)img {
    
    CIFilter *noFilter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [noFilter setValue:img forKey:kCIInputImageKey];
    [noFilter setValue:@(1) forKey:@"inputPower"];
    return noFilter.outputImage;
}

- (CIImage *)exposureAdjust:(CIImage *)img {
    
    CIFilter *expoAdjust = [CIFilter filterWithName:@"CIExposureAdjust"];
    [expoAdjust setValue:img forKey:kCIInputImageKey];
    [expoAdjust setValue:@(1) forKey:@"inputEV"];
    return expoAdjust.outputImage;
}

- (CIImage *)toneCurveToLinear:(CIImage *)img {
    
    CIFilter *toneCurveToLinear = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
    [toneCurveToLinear setValue:img forKey:kCIInputImageKey];
    return toneCurveToLinear.outputImage;
}

- (CIImage *)chromeEffect:(CIImage *)img {
    
    CIFilter *chromeEffect = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
    [chromeEffect setValue:img forKey:kCIInputImageKey];
    return chromeEffect.outputImage;
}

- (CIImage *)photoInstant:(CIImage *)img {
    
    CIFilter *instant =  [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    [instant setValue:img forKey:kCIInputImageKey];
    return instant.outputImage;
}

- (CIImage *)fadeEffect:(CIImage *)img {
    
    CIFilter *fadeEffect = [CIFilter filterWithName:@"CIPhotoEffectFade"];
    [fadeEffect setValue:img forKey:kCIInputImageKey];
    return fadeEffect.outputImage;
}



- (IBAction)doneWasPressed:(UIBarButtonItem *)sender {
    
    __weak FilterViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}



@end
