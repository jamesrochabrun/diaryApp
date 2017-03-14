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

@implementation THEntryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGB(kColorOffBlack);
     
        self.mainImageView = [UIImageView new];
        self.mainImageView.clipsToBounds = true;
        self.mainImageView.backgroundColor = [UIColor redColor];
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.mainImageView.contentMode =  UIViewContentModeScaleAspectFill;
        [self addSubview:self.mainImageView];
   
        
    }
    return self;
}
- (void)layoutSubviews {
    
//       CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40);
//    self.mainImageView.frame = frame;
    
    [[_mainImageView.topAnchor constraintEqualToAnchor: self.topAnchor] setActive: true];
    [[_mainImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-  kGeomLabelCellHeight * 2] setActive: true];
    [[_mainImageView.widthAnchor constraintEqualToAnchor:self.widthAnchor] setActive: true];
    [[_mainImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive: true];
}


- (void)awakeFromNib {
    [super awakeFromNib];

//    NSArray *labels = @[self.locationLabel , self.dateLabel];
//    for (UILabel *label in labels) {
//        label.font = [UIFont regularFont:15];
//        label.textColor = [UIColor whiteColor];
//    }
}

- (void)configureCellForEntry:(THDiaryEntry*)entry {

//    self.locationLabel.text = entry.location;
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
//    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (entry.image) {        
        self.mainImageView.image = [UIImage imageWithData:entry.image];
    }
    
//    if(entry.mood == DiaryEntryMoodGood) {
//        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
//    } else if (entry.mood == DiaryEntryMoodAverage) {
//        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
//    } else if (entry.mood == DiaryEntryMoodBad) {
//        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
//    }
//    
//    if (entry.location.length > 0) {
//        self.locationLabel.text = entry.location;
//    } else {
//        self.locationLabel.text = @"No Location";
//    }
//    
//    BOOL isFavorite = [entry.isFavorite boolValue];
//    if (isFavorite) {
//        self.heartImage.hidden = NO;
//        [self.heartImage setImage:[UIImage imageNamed:@"redHeart"]];
//    } else {
//        self.heartImage.hidden = YES;
//    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
