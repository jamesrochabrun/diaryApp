//
//  DoubleTapImage.h
//  secretdiary
//
//  Created by James Rochabrun on 05-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DoubleTapImagedelegate <NSObject>

@optional
- (void)didImageDoubleTapped;



@end

@interface DoubleTapImage : UIImageView
@property id<DoubleTapImagedelegate>delegate;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
