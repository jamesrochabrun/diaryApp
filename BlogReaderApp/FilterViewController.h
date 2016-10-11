//
//  FilterViewController.h
//  secretdiary
//
//  Created by James Rochabrun on 9/22/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THEntryViewcontroller.h"


@interface FilterViewController : UIViewController<UIGestureRecognizerDelegate, THEntryViewcontrollerDelegate>
@property (nonatomic, strong) UIImage *pickedImage;

@end
