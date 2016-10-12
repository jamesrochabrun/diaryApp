//
//  ImageViewController.h
//  BlogReaderApp
//
//  Created by James Rochabrun on 31-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THDiaryEntry;

@interface ImageViewController : UIViewController<UIScrollViewDelegate>
@property THDiaryEntry *entry;

@end
