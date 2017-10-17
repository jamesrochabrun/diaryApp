//
//  PlaceholderView.m
//  momentum
//
//  Created by James Rochabrun on 10/12/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "PlaceholderView.h"
#import "UIFont+CustomFont.h"
#import "Common.h"
#import "CommonUIConstants.h"

@implementation PlaceholderView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _imageView = [UIImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        _overLay = [UIView new];
        _overLay.backgroundColor = UIColorRGBOverlay(kColorGrayMiddle, 0.5);
        _overLay.layer.cornerRadius = 40;
        [self addSubview:_overLay];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.font = [UIFont regularFont:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        _titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _titleLabel.layer.shadowRadius = 3.0f;
        _titleLabel.layer.shadowOpacity = 1;
        _titleLabel.layer.shadowOffset = CGSizeZero;
        _titleLabel.layer.masksToBounds = NO;
        [self addSubview:_titleLabel];
        
        _textView = [UITextView new];
        _textView.userInteractionEnabled = NO;
        _textView.scrollEnabled = NO;
        _textView.font = [UIFont regularFont:15];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        _textView.layer.shadowColor = [UIColor blackColor].CGColor;
        _textView.layer.shadowRadius = 3.0f;
        _textView.layer.shadowOpacity = 1;
        _textView.layer.shadowOffset = CGSizeZero;
        _textView.layer.masksToBounds = NO;
        [self addSubview:_textView];
        
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGRect frame = _imageView.frame;
    frame.size.height = height(self);
    frame.size.width = width(self);
    frame.origin.x = 0;
    frame.origin.y = 0;
    _imageView.frame = frame;
    

    [self textViewDidChange:_textView];
    
    [_titleLabel sizeToFit];
    frame = _titleLabel.frame;
    frame.origin.x = (width(self) - width(_titleLabel)) /2;
    frame.origin.y = CGRectGetMinY(_textView.frame) - kGeomMarginMedium;
    _titleLabel.frame = frame;
    
    CGFloat innerHeight = height(self.superview) - (kGeomHeightStatusBar + kGeomHeightNavigationBar + kGeomHeightToolBar);
    frame = _overLay.frame;
    frame.size.height = innerHeight * 0.7;
    frame.size.width = width(_textView) + kGeomMarginMedium;
    frame.origin.x = (width(self) - frame.size.width) / 2;
    frame.origin.y = (height(self.superview) - frame.size.height) /2;
    _overLay.frame = frame;

}

- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat fixedWidth = width(self) * 0.8;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    newFrame.origin.x = (width(self) - fixedWidth) /2;
    newFrame.origin.y = (height(self.superview) - newFrame.size.height) /2 ;
    textView.frame = newFrame;
}

- (void)setContentWithImage:(UIImage *)image andTitle:(NSString *)title withMessage:(NSString *)message {
    
    _imageView.image = image;
    _titleLabel.text = title;
    _textView.text = message;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}


@end
