//
//  TopView.h
//  CharterProject
//
//  Created by James Rochabrun on 9/23/16.
//  Copyright © 2016 jamesrochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

-(void)dismissVC;

@end

@interface TopView : UIView
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, weak)id<TopViewDelegate> delegate;


@end
