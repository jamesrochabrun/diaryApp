//
//  FilterViewController.h
//  secretdiary
//
//  Created by James Rochabrun on 9/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THEntryViewcontroller.h"
@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterPhotoCancelled:(FilterViewController *)filterVC getNewPhoto:(BOOL)getNewPhoto ofType:(NSInteger)type;
@end

@interface FilterViewController : UIViewController<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, weak) id<FilterViewControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger sourceType;


@end
