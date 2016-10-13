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
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.font = [UIFont regularFont:17];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _textView = [UITextView new];
        _textView.userInteractionEnabled = NO;
        _textView.scrollEnabled = NO;
        _textView.font = [UIFont regularFont:15];
        [self addSubview:_textView];
        
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self textViewDidChange:_textView];
    
    [_titleLabel sizeToFit];
    CGRect frame = _titleLabel.frame;
    frame.origin.x = (width(self) - width(_titleLabel)) /2;
    frame.origin.y = CGRectGetMinY(_textView.frame) - kGeomMarginBig;
    _titleLabel.frame = frame;
    
    frame = _imageView.frame;
    frame.size.height = height(self);
    frame.size.width = width(self);
    frame.origin.x = 0;
    frame.origin.y = 0;
    _imageView.frame = frame;

}

- (void)textViewDidChange:(UITextView *)textView {
    
    CGFloat fixedWidth = width(self) * 0.8;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    newFrame.origin.x = (width(self) - fixedWidth) /2;
    newFrame.origin.y = (height(self) - newFrame.size.height) /2 + kGeomMarginBig;
    textView.frame = newFrame;
}

- (void)setContentWithImage:(UIImage *)image andTitle:(NSString *)title withMessage:(NSString *)message {
    
    _imageView.image = image;
    _titleLabel.text = title;
    _textView.text = message;
    
    __weak PlaceholderView *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf setNeedsLayout];
    });
}


@end
