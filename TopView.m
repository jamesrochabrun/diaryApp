//
//  TopView.m
//  CharterProject
//
//  Created by James Rochabrun on 9/23/16.
//  Copyright © 2016 jamesrochabrun. All rights reserved.
//

#import "TopView.h"
#import "CommonUIConstants.h"

@implementation TopView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _dismissButton = [UIButton new];
        [_dismissButton setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissButton];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = _dismissButton.frame;
    frame.origin.x = kGeomMarginDismissButton;
    frame.origin.y = kGeomMarginDismissButton;
    frame.size.width = kGeomDismmissButton;
    frame.size.height = kGeomDismmissButton;
    _dismissButton.frame = frame;
}

- (void)dismissView {
    
    [self.delegate dismissVC];
}


@end
