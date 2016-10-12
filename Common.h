//
//  Common.h
//  CharterProject
//
//  Created by James Rochabrun on 9/21/16.
//  Copyright © 2016 jamesrochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kAppSettingsPhotos,
    kAppSettingsCamera,
    kAppSettingsLocation,
    kAppSettingsContacts
} kAppSettings;


@class AppDelegate;
#define APP ((AppDelegate* )[UIApplication sharedApplication].delegate)

static inline CGFloat width(UIView *view) { return view.bounds.size.width; }
static inline CGFloat height(UIView *view) { return view.bounds.size.height; }
static inline CGFloat originX(UIView *view) { return view.frame.origin.x; }
static inline CGFloat originY(UIView *view) { return view.frame.origin.y; }



extern NSArray * parseArrayOrNullFromServer (id object);
extern NSString * parseStringOrNullFromServer (id object);
extern NSDictionary * parseDictionaryOrNullFromServer (id object);
extern NSNumber * parseNSNumberOrNullFromServer (id object);

@interface Common : NSObject
+ (void)goToSettings:(kAppSettings)settings;


@end
