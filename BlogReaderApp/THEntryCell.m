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


@implementation THEntryCell

+ (CGFloat)heightForEntry:(THDiaryEntry *)entry {
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 200.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(204, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin +bottomMargin);
}

- (void)configureCellForEntry:(THDiaryEntry*)entry {
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (entry.image) {
        self.mainImageView.image = [UIImage imageWithData:entry.image];
    } else {
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    if(entry.mood == DiaryEntryMoodGood) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if (entry.mood == DiaryEntryMoodAverage) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    } else if (entry.mood == DiaryEntryMoodBad) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }
    
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame) / 2.0f;
    
    if (entry.location.length > 0) {
        self.locationLabel.text = entry.location;
    } else {
        self.locationLabel.text = @"No Location";
    }
}









- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
