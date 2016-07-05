//
//  THDiaryEntry+CoreDataProperties.h
//  secretdiary
//
//  Created by James Rochabrun on 05-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "THDiaryEntry.h"

NS_ASSUME_NONNULL_BEGIN


//typedef enum {
//    DiaryEntryMoodGood = 0,
//    DiaryEntryMoodAverage = 1,
//    DiaryEntryMoodBad = 2
//} DiaryEntryMood;

//NS_ENUM(int16_t,  DiaryEntryMood) {
//    DiaryEntryMoodGood = 0,
//    DiaryEntryMoodAverage = 1,
//    DiaryEntryMoodBad = 2
//};

typedef NS_ENUM(NSInteger, DiaryEntryMood) {
    DiaryEntryMoodGood = 0,
    DiaryEntryMoodAverage = 1,
    DiaryEntryMoodBad = 2
};

@interface THDiaryEntry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *location;
@property (nonatomic) int16_t mood;
@property (nullable, nonatomic, retain) NSNumber *isFavorite;

//for a section we create this property
@property (nonatomic, readonly) NSString *sectionName;

@end

NS_ASSUME_NONNULL_END
