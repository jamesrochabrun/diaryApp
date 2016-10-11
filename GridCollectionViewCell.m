//
//  GridCollectionViewCell.m
//  secretdiary
//
//  Created by James Rochabrun on 14-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "GridCollectionViewCell.h"
#import "THDiaryEntry.h"



@implementation GridCollectionViewCell

- (void)configureGridCellForEntry:(THDiaryEntry*)entry {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backgroundView.frame.size.width, self.backgroundView.frame.size.height)];
    imageView.image = [UIImage imageWithData:entry.image];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView = imageView;
    
    if(entry.mood == DiaryEntryMoodGood) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if (entry.mood == DiaryEntryMoodAverage) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    } else if (entry.mood == DiaryEntryMoodBad) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }
    
    BOOL isFavorite = [entry.isFavorite boolValue];
    if (isFavorite) {
        self.redHeartImageView.hidden = NO;
        [self.redHeartImageView setImage:[UIImage imageNamed:@"redHeart"]];
    } else {
        self.redHeartImageView.hidden = YES;
    }
}


@end
