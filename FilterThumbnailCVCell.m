//
//  FilterThumbnailCVCell.m
//  secretdiary
//
//  Created by James Rochabrun on 9/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "FilterThumbnailCVCell.h"
#import "FilterSettings.h"
#import "Common.h"
#import "CommonUIConstants.h"
#import "UIFont+CustomFont.h"


@implementation FilterThumbnailCVCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
       // self.backgroundColor = [UIColor whiteColor];
        
        _filterType = [UILabel new];
        
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        
        _filterType = [UILabel new];
        [_filterType setTextColor:UIColorRGB(kColorOffBlack)];
        [_filterType setTextAlignment:NSTextAlignmentCenter];
        [_filterType setLineBreakMode:NSLineBreakByWordWrapping];
        [_filterType setFont:[UIFont regularFont:15]];
        [_filterType setNumberOfLines:0];
        
        _selectedView = [UIView new];
        _selectedView.backgroundColor = UIColorRGB(kColorOffBlack);
        _selectedView.hidden = YES;
        
        [self addSubview:_filterType];
        [self addSubview:_imageView];
        [self addSubview:_selectedView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = _filterType.frame;
    frame.size = CGSizeMake(width(self), 15);
    frame.origin = CGPointMake(0, 0);
    _filterType.frame = frame;
    
    frame = _imageView.frame;
    frame.size = CGSizeMake(width(self), height(self) - height(_filterType));
    frame.origin.y = CGRectGetMaxY(_filterType.frame) + kGeomInterImageGap ;
    _imageView.frame = frame;
    
    frame = _selectedView.frame;
    frame.size.width = width(self);
    frame.size.height = kGeomSpaceEdge;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(self.frame) - kGeomSpaceEdge +  kGeomInterImageGap;
    _selectedView.frame = frame;
}

- (void)setSelected:(BOOL)selected {
    
    self.selectedView.hidden = !selected;
}

- (void)setSettings:(FilterSettings *)settings {
    
    _settings = settings;
    _filter = settings.filter;
    _touched = settings.touched;
    
    [self setNeedsLayout];
}

- (void)configureEditionCellTypeWithSettings:(FilterSettings *)settings {
    
    _settings = settings;
    _filter = settings.filter;
    _touched = settings.touched;
    _filterType.text = settings.displayName;
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.image = [UIImage imageNamed:settings.displayName];
    
    if (_touched) {
        _selectedView.hidden = NO;
    } else {
        _selectedView.hidden = YES;
    }
    [self setNeedsLayout];
}





@end
