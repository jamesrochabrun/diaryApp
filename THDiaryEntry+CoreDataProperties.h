//
//  THDiaryEntry+CoreDataProperties.h
//  momentum
//
//  Created by James Rochabrun on 10/20/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "THDiaryEntry.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DiaryEntryMood) {
    DiaryEntryMoodGood = 0,
    DiaryEntryMoodAverage = 1,
    DiaryEntryMoodBad = 2
};

@interface THDiaryEntry (CoreDataProperties)

+ (NSFetchRequest<THDiaryEntry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *body;
@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSNumber *isFavorite;
@property (nullable, nonatomic, copy) NSString *location;
@property (nonatomic) int16_t mood;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;


//for a section we create this property
@property (nonatomic, readonly) NSString *sectionName;
//for a imagesize we create this property


//- (CGSize)loadImageData;

@end

NS_ASSUME_NONNULL_END
