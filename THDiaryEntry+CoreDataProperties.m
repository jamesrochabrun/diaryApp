//
//  THDiaryEntry+CoreDataProperties.m
//  momentum
//
//  Created by James Rochabrun on 10/20/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "THDiaryEntry+CoreDataProperties.h"

@implementation THDiaryEntry (CoreDataProperties)

+ (NSFetchRequest<THDiaryEntry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"THDiaryEntry"];
}

@dynamic body;
@dynamic date;
@dynamic image;
@dynamic isFavorite;
@dynamic location;
@dynamic mood;
@dynamic latitude;
@dynamic longitude;


//this returns a string for the property sectionName
//step 10 this will go in the method fetchedResultsController as a sectionNameKeyPath
- (NSString *)sectionName {
    
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSString *stringDate  = [dateFormatter stringFromDate:date];
    return stringDate;
}

@end
