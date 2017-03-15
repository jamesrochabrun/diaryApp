//
//  CommonUIConstants.h
//  ooApp
//
//  Created by James Rochabrun on 7/31/16.
//  Copyright © 2016 jamesrochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

// Convenience Macros
#define UIColorRGB(rgbValue) [UIColor colorWithRed:(255&(rgbValue>> 16))/255.0f \
green:(255&(rgbValue >> 8))/255.0 \
blue:(255&rgbValue)/255.0 alpha:1.0]

#define UIColorRGBA(rgbValue) [UIColor colorWithRed:(255&(rgbValue>> 16))/255.0f \
green:(255&(rgbValue >> 8))/255.0f \
blue:(255&rgbValue)/255.0f \
alpha:(rgbValue >> 24)/255.0f]

#define UIColorRGBOverlay(rgbValue, alphaValue) [UIColor colorWithRed:(255&(rgbValue>> 16))/255.0f \
green:(255&(rgbValue >> 8))/255.0f \
blue:(255&rgbValue)/255.0f \
alpha:alphaValue]
#define IS_IPHONE4  ( [UIScreen  mainScreen].bounds.size.height <= 480)

static NSUInteger kColorOffBlack = 0xFF272727;
static const NSUInteger kColorElements1 = 0xFF272727;
static const NSUInteger kColorElements2 = 0xFFe0e0e0;
static const NSUInteger kColorElements3 = 0xff8D99AE;

static const NSUInteger kColorGrayLight = 0xFFB2B2B2;
static const NSUInteger kColorGrayMiddle = 0xFF53585F;
static const NSUInteger kColorWhite = 0xFFFFFFFF;
static const NSUInteger kColorBlack = 0xFF000000;
static const NSUInteger kColorClear = 0x00000000;
static const NSUInteger kColorNavyBlue = 0xFF000080;
static const NSUInteger kColorYellow = 0xFFF9FF00;
static const NSUInteger kColorMarkerFaded = 0x701874CD;
static const NSUInteger kColorConnectOverlayCell = 0xFF032E06;
static NSUInteger kColorOffWhite = 0xFFE5E5E5;
static const NSUInteger kColorOverlay10 = 0xE6000000;
static const NSUInteger kColorOverlay20 = 0xCC000000;
static const NSUInteger kColorOverlay25 = 0xC0000000;
static const NSUInteger kColorOverlay30 = 0xB3000000;
static const NSUInteger kColorOverlay35 = 0xA6000000;
static const NSUInteger kColorOverlay40 = 0x99000000;
static const NSUInteger kColorOverlay50 = 0x7F000000;
static const NSUInteger kColorYellowFlat = 0xf1c40f;
static const NSUInteger kColorRedFlat = 0xe74c3c;

// Geometry and metrics

static CGFloat kGeomWidthBigButton = 210.0;
static CGFloat kGeomHeightBigbutton = 40.0;
static CGFloat kGeomBottomPadding = 100.0;
static CGFloat kGeomMarginMedium = 20.0;
static CGFloat kGeomHeightToolBar = 50.0;
static CGFloat kGeomMarginBig = 40.0;
static CGFloat kGeomHeaderHeightInSection = 40.0;
static CGFloat kGeomWidthToolBarButton = 85.0;
static CGFloat kGeomTopViewHeight = 75.0;
static CGFloat kGeomDismmissButton = 44.0;
static CGFloat kGeomMarginDismissButton = 26.0;
static CGFloat kGeomHeightTextField = 35.0;
static CGFloat kGeomSpaceEdge = 4.0;
static CGFloat kGeomMinSpace = 1.0;
static CGFloat kGeomSpaceInter = 4;
static CGFloat kGeomMinimunInterItemSpacing = 5;
static CGFloat kGeomSpaceCellPadding = 3;
static CGFloat kGeomInterImageGap = 2;
static CGFloat kGeomIconSize = 30;
static CGFloat kGeomHeightButton = 40.0;
static CGFloat kGeomUploadWidth = 750;
static CGFloat kGeomMarginSmall = 10;
static CGFloat kGeomHeightStatusBar = 20;
static CGFloat kGeomHeightNavigationBar = 44;
static CGFloat kGeomToolBarButtonSize = 40.0;
static CGFloat kGeomLabelCellHeight = 30.0;
static CGFloat kGeomCellPadding = 10.0;
static CGFloat kGeomCellPaddingBottom = 38.0;
static CGFloat kGeomCellIconSize = 20.0;


static CGFloat kMaxScale = 2.1;
static CGFloat kMinScale = 0.9;
static CGFloat kExternalOffset = 100.0;
static CGFloat kInternalOffset = 100.0;
static CGFloat kPanVelocity = 0.4;
static CGFloat kPanDelay = 0.0;
static UIViewAnimationOptions kUIViewAnimationOption = UIViewAnimationOptionCurveEaseOut;


//filters
extern NSString *const kCIColorControls;
extern NSString *const kCIExposureAdjust;
extern NSString *const kCIHighlightShadowAdjust;
extern NSString *const kCIVignette;
extern NSString *const kCISharpenLuminance;
extern NSString *const kCIGammaAdjust;
extern NSString *const kCIPhotoEffectTransfer;
extern NSString *const kCIPhotoEffectChrome;
extern NSString *const kCIPhotoEffectInstant;
extern NSString *const kCIPhotoEffectFade;

extern NSString *const kInputPower;
extern NSString *const kInputEV;
extern NSString *const kInputSaturation;
extern NSString *const kInputContrast;
extern NSString *const kInputIntensity;
extern NSString *const kInputSharpness;
extern NSString *const kInputShadowAmount;
extern NSString *const kInputRadius;

//filters Ranges
static CGFloat kContrastRange = 0.25f;
static CGFloat kMaxDisplay = 100.0f;
static CGFloat kSaturationRange = 0.5f;
static CGFloat kBrightnessRange = 1.0f;
static CGFloat kVignetteRange = 10.0f;
static CGFloat kSharpnessRange = 25.0f;
static CGFloat kShadowRange = 1.0f;
static CGFloat kSliderLetGoRange = 1.0f;



