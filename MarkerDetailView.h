//
//  MarkerDetailView.h
//  momentum
//
//  Created by James Rochabrun on 11/4/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;

@interface MarkerDetailView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
- (instancetype)initWithMarker:(GMSMarker *)marker;

@end
