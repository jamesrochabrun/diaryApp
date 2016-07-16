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
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage;


//class method
//+ (CGFloat)heightForEntry:(THDiaryEntry *)entry;
- (void)configureCellForEntry:(THDiaryEntry*)entry;

@end
