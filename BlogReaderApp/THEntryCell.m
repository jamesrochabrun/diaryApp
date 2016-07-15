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


@implementation THEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *labels = @[self.bodyLabel , self.locationLabel , self.dateLabel ];
    for (UILabel *label in labels) {
        label.font = [UIFont regularFont:15];
        label.textColor = [UIColor whiteColor];
    }
}

- (void)configureCellForEntry:(THDiaryEntry*)entry {
    
    self.bodyLabel.numberOfLines = 0;
    [self.bodyLabel sizeToFit];
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if (entry.image) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageWithData:entry.image];
        self.backgroundView = imageView;
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
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
