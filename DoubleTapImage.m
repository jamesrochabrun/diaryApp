//
//  DoubleTapImage.m
//  secretdiary
//
//  Created by James Rochabrun on 05-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DoubleTapImage.h"

@interface DoubleTapImage
()<UIGestureRecognizerDelegate>

@end

@implementation DoubleTapImage

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [super initWithCoder:aDecoder];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        self.gestureRecognizers = @[doubleTap];
        for (UIGestureRecognizer *recognizer  in self.gestureRecognizers) {
            recognizer.delegate = self;
        }
    }
    return self;
}

-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized ||
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self.delegate didImageDoubleTapped];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
