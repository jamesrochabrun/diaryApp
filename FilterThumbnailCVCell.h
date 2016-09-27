//
//  FilterThumbnailCVCell.h
//
//  secretdiary
//
//  Created by James Rochabrun on 9/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.

#import <UIKit/UIKit.h>

@class FilterSettings;


@interface FilterThumbnailCVCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *filterType;
@property (nonatomic, strong) UILabel *editionType;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, assign) BOOL touched;
@property (nonatomic, assign) BOOL test;


@property (nonatomic, strong) FilterSettings *settings;
@property (nonatomic, strong) CIFilter *filter;

@end
