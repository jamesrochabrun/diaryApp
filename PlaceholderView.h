//
//  PlaceholderView.h
//  momentum
//
//  Created by James Rochabrun on 10/12/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *overLay;
- (void)setContentWithImage:(UIImage *)image andTitle:(NSString *)title withMessage:(NSString *)message;


@end
