//
//  THEntryCell.h
//  BlogReaderApp
//
//  Created by James Rochabrun on 26-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THDiaryEntry;

@interface THEntryCell : UITableViewCell
@property (strong, nonatomic)  UILabel *dateLabel;
@property (strong, nonatomic)  UILabel *locationLabel;
@property (strong, nonatomic)  UIImageView *moodImageView;
@property (strong, nonatomic)  UIImageView *heartImage;
@property (strong, nonatomic)  UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *locationIcon;
@property (nonatomic, strong) UIImageView *calendarIcon;
@property (nonatomic, strong) UIView *line;


//class method
//+ (CGFloat)heightForEntry:(THDiaryEntry *)entry;
- (void)configureCellForEntry:(THDiaryEntry*)entry;

@end
