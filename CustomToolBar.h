//
//  CustomToolBar.h
//  momentum
//
//  Created by James Rochabrun on 10/13/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomToolBarDelegate

- (void)goToFavorites;
- (void)goToHome;
- (void)goToCameraActions;

@end

@interface CustomToolBar : UIToolbar

@property (nonatomic, weak) id<CustomToolBarDelegate>del;
@property (nonatomic, strong) UIButton *homebutton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *favoritesButton;

@property (nonatomic, strong) UIBarButtonItem *home;
@property (nonatomic, strong) UIBarButtonItem *favorites;
@property (nonatomic, strong) UIBarButtonItem *camera;
@property (nonatomic, strong) UIBarButtonItem *spacer;
@property (nonatomic, assign) BOOL favoritesSelected;


@end
