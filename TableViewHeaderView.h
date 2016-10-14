//
//  TableViewHeaderView.h
//  momentum
//
//  Created by James Rochabrun on 10/13/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewHeaderView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
- (instancetype)initWithSectionTitle:(NSString *)sectionTitle;

@end
