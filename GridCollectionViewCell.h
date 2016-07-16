//
//  GridCollectionViewCell.h
//  secretdiary
//
//  Created by James Rochabrun on 14-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class THDiaryEntry;

@interface GridCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *redHeartImageView;



- (void)configureGridCellForEntry:(THDiaryEntry*)entry;


@end
