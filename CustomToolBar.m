    //
//  CustomToolBar.m
//  momentum
//
//  Created by James Rochabrun on 10/13/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "CustomToolBar.h"
#import "CommonUIConstants.h"
#import "Common.h"

@implementation CustomToolBar

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [self setBarTintColor:[UIColor whiteColor]];
        
        _homebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kGeomToolBarButtonSize, kGeomToolBarButtonSize)];
        [_homebutton addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
        [_homebutton setBackgroundImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
        [_homebutton setBackgroundImage:[UIImage imageNamed:@"homeSelected"] forState:UIControlStateSelected];
        _home = [[UIBarButtonItem alloc] initWithCustomView:_homebutton];
        
        _cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kGeomToolBarButtonSize, kGeomToolBarButtonSize)];
        [_cameraButton addTarget:self action:@selector(goToCameraActions) forControlEvents:UIControlEventTouchUpInside];
        [_cameraButton setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        
        _camera = [[UIBarButtonItem alloc] initWithCustomView:_cameraButton];
        
        _favoritesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kGeomToolBarButtonSize,kGeomToolBarButtonSize)];
        [_favoritesButton addTarget:self action:@selector(goToFavorites) forControlEvents:UIControlEventTouchUpInside];
        [_favoritesButton setBackgroundImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
        [_favoritesButton setBackgroundImage:[UIImage imageNamed:@"favoriteSelected"] forState:UIControlStateSelected];
        
        _favorites = [[UIBarButtonItem alloc] initWithCustomView:_favoritesButton];
        
        _spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        NSArray *buttonItems = [NSArray arrayWithObjects:_spacer, _home, _spacer, _camera, _spacer, _favorites, _spacer, nil];
        [self setItems:buttonItems];
    }
    
    return self;
}

- (void)goToCameraActions {
    [self.del goToCameraActions];
}

- (void)goToFavorites {
    [self.del goToFavorites];
    [_favoritesButton setSelected:YES];
    [_homebutton setSelected:NO];
    _favoritesSelected = YES;
}

- (void)goToHome {
    [self.del goToHome];
    _favoritesSelected = NO;
    [_homebutton setSelected:YES];
    [_favoritesButton setSelected:NO];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y =  [[UIScreen mainScreen] bounds].size.height - 50;
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    frame.size.height = 50;
    self.frame = frame;
    
    
    
}

@end
