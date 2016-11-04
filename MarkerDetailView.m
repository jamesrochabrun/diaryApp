//
//  MarkerDetailView.m
//  momentum
//
//  Created by James Rochabrun on 11/4/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "MarkerDetailView.h"
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"
#import "CommonUIConstants.h"
@implementation MarkerDetailView


- (instancetype)initWithMarker:(GMSMarker *)marker {
    self = [super init];
    if (self) {
        
        self.layer.cornerRadius = 10;
        self.backgroundColor =  UIColorRGBOverlay(kColorBlack, 0.3);
        self.clipsToBounds = YES;
        
        _titleLabel = [UILabel new];
        [_titleLabel setFont:[UIFont regularFont:17]];
        [_titleLabel setTextColor:[UIColor lightTextColor]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = marker.title;
        [self addSubview:_titleLabel];
        
        _subTitleLabel = [UILabel new];
        [_subTitleLabel setFont:[UIFont regularFont:15]];
        [_subTitleLabel setTextColor:[UIColor lightTextColor]];
        _subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = marker.snippet;
        [self addSubview:_subTitleLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = _titleLabel.frame;
    frame.size.height = 20;
    frame.size.width = self.frame.size.width * 0.7;
    frame.origin.x = (self.frame.size.width - frame.size.width) /2;
    frame.origin.y = 10;
    _titleLabel.frame = frame;
    
    frame = _subTitleLabel.frame;
    frame.size.height = 50;
    frame.size.width = self.frame.size.width * 0.8;
    frame.origin.x = (self.frame.size.width - frame.size.width)/2;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame);
    _subTitleLabel.frame = frame;
    
}




@end
