//
//  THEntryCell.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 26-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "THEntryCell.h"
#import "THDiaryEntry.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+CustomFont.h"
#import "Common.h"
#import "CommonUIConstants.h"
#import "UIColor+CustomColor.h"

@implementation THEntryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = UIColorRGB(kColorOffBlack);
        
        self.mainImageView = [UIImageView new];
        self.mainImageView.clipsToBounds = true;
        self.mainImageView.backgroundColor = [UIColor redColor];
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.mainImageView.contentMode =  UIViewContentModeScaleAspectFill;
        [self addSubview:self.mainImageView];
        
        self.locationIcon = [UIImageView new];
        self.locationIcon.clipsToBounds = true;
        self.locationIcon.image = [UIImage imageNamed:@"location"];
        self.locationIcon.translatesAutoresizingMaskIntoConstraints = false;
        self.locationIcon.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:self.locationIcon];
        
        self.calendarIcon = [UIImageView new];
        self.calendarIcon.clipsToBounds = true;
        self.calendarIcon.image = [UIImage imageNamed:@"calendar"];
        self.calendarIcon.translatesAutoresizingMaskIntoConstraints = false;
        self.calendarIcon.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:self.calendarIcon];
        
        self.dateLabel = [UILabel new];
        self.locationLabel = [UILabel new];
        
        NSArray *labels = @[self.locationLabel , self.dateLabel];
        for (UILabel *label in labels) {
            label.font = [UIFont regularFont:15];
            label.textColor = [UIColor newGrayColor];
            label.translatesAutoresizingMaskIntoConstraints = false;
            //label.adjustsFontSizeToFitWidth = true;
            label.backgroundColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            [self addSubview:label];
        }
        
        self.line = [UIView new];
        self.line.translatesAutoresizingMaskIntoConstraints = false;
        self.line.backgroundColor = [UIColor newGrayColor];
        [self addSubview:self.line];
        
        self.moodImageView = [UIImageView new];
        self.moodImageView.clipsToBounds = true;
        self.moodImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.moodImageView.contentMode =  UIViewContentModeScaleAspectFill;
        [self addSubview:self.moodImageView];
        
        self.heartImage = [UIImageView new];
        self.heartImage.clipsToBounds = true;
        self.heartImage.translatesAutoresizingMaskIntoConstraints = false;
        self.heartImage.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:self.heartImage];
        
    }
    return self;
}
- (void)layoutSubviews {
    
    [[_mainImageView.topAnchor constraintEqualToAnchor: self.topAnchor] setActive: true];
    [[_mainImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-(((kGeomLabelCellHeight * 2) + (kGeomCellPadding * 2)) +kGeomCellPaddingBottom)] setActive: true];
    [[_mainImageView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive: true];
    [[_mainImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive: true];
    
    [[_heartImage.widthAnchor constraintEqualToConstant:kGeomToolBarButtonSize] setActive:true];
    [[_heartImage.heightAnchor constraintEqualToConstant:kGeomToolBarButtonSize] setActive:true];
    [[_heartImage.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-kGeomCellPadding] setActive:true];
    [[_heartImage.topAnchor constraintEqualToAnchor:_mainImageView.topAnchor constant:kGeomCellPadding]setActive:true];
    
    [[_calendarIcon.topAnchor constraintEqualToAnchor:_mainImageView.bottomAnchor constant:kGeomCellPadding] setActive:true];
    [[_calendarIcon.leftAnchor constraintEqualToAnchor:self.leftAnchor constant: kGeomCellPadding] setActive:true];
    [[_calendarIcon.heightAnchor constraintEqualToConstant:kGeomCellIconSize] setActive:true];
    [[_calendarIcon.widthAnchor constraintEqualToConstant:kGeomCellIconSize] setActive:true];
    
    [[_locationIcon.topAnchor constraintEqualToAnchor:_calendarIcon.bottomAnchor constant: 8] setActive:true];
    [[_locationIcon.leftAnchor constraintEqualToAnchor:self.leftAnchor constant: kGeomCellPadding] setActive:true];
    [[_locationIcon.heightAnchor constraintEqualToConstant:kGeomCellIconSize] setActive:true];
    [[_locationIcon.widthAnchor constraintEqualToConstant:kGeomCellIconSize] setActive:true];
    
    [[_moodImageView.centerYAnchor constraintEqualToAnchor:_locationIcon.topAnchor] setActive:true];
    [[_moodImageView.heightAnchor constraintEqualToConstant:kGeomLabelCellHeight] setActive:true];
    [[_moodImageView.widthAnchor constraintEqualToConstant:kGeomLabelCellHeight] setActive:true];
    [[_moodImageView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant: -kGeomCellPadding] setActive:true];
    
    [[_dateLabel.topAnchor constraintEqualToAnchor:_calendarIcon.topAnchor] setActive:true];
    [[_dateLabel.rightAnchor constraintEqualToAnchor:_moodImageView.leftAnchor constant: -kGeomCellPadding] setActive:true];
    [[_dateLabel.leftAnchor constraintEqualToAnchor:_calendarIcon.rightAnchor constant: kGeomCellPadding] setActive:true];
    [[_dateLabel.heightAnchor constraintEqualToConstant:kGeomLabelCellHeight] setActive:true];
    
    [[_locationLabel.topAnchor constraintEqualToAnchor:_locationIcon.topAnchor] setActive:true];
    [[_locationLabel.rightAnchor constraintEqualToAnchor:_moodImageView.leftAnchor constant: -kGeomCellPadding] setActive:true];
    [[_locationLabel.leftAnchor constraintEqualToAnchor:_locationIcon.rightAnchor constant: kGeomCellPadding] setActive:true];
    [[_locationLabel.heightAnchor constraintEqualToConstant:kGeomLabelCellHeight] setActive:true];
    
    [[self.line.topAnchor constraintEqualToAnchor:_locationLabel.topAnchor] setActive:true];
    [[self.line.rightAnchor constraintEqualToAnchor:_locationLabel.rightAnchor] setActive:true];
    [[self.line.leftAnchor constraintEqualToAnchor:_locationLabel.leftAnchor] setActive:true];
    [[self.line.heightAnchor constraintEqualToConstant:0.5] setActive:true];

}

- (void)configureCellForEntry:(THDiaryEntry*)entry {

    self.locationLabel.text = entry.location;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (entry.image) {
        self.mainImageView.image = [UIImage imageWithData:entry.image];
    }
    
    if(entry.mood == DiaryEntryMoodGood) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if (entry.mood == DiaryEntryMoodAverage) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    } else if (entry.mood == DiaryEntryMoodBad) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }

    if (entry.location.length > 0) {
        self.locationLabel.text = entry.location;
    } else {
        self.locationLabel.text = @"No Location";
    }

    BOOL isFavorite = [entry.isFavorite boolValue];
    if (isFavorite) {
        self.heartImage.hidden = NO;
        [self.heartImage setImage:[UIImage imageNamed:@"redHeart"]];
    } else {
        self.heartImage.hidden = YES;
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
