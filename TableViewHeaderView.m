//
//  TableViewHeaderView.m
//  momentum
//
//  Created by James Rochabrun on 10/13/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "TableViewHeaderView.h"
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"
#import "Common.h"
#import "CommonUIConstants.h"

@implementation TableViewHeaderView

- (instancetype)initWithSectionTitle:(NSString *)sectionTitle {
    
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [UILabel new];
        [_titleLabel setFont:[UIFont regularFont:15]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor newGrayColor]];
        _titleLabel.text = sectionTitle;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_titleLabel sizeToFit];
    CGRect frame = _titleLabel.frame;
    frame.origin.x = (width(self) - width( _titleLabel)) / 2;
    frame.origin.y = (height(self) - height(_titleLabel)) / 2;
    _titleLabel.frame = frame;
    
    frame = self.frame;
    frame.size.height = kGeomHeaderHeightInSection;
    frame.size.width = width(self.superview);
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.frame = frame;
    
}









@end
