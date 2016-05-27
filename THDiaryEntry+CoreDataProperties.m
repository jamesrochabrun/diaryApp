//
//  THDiaryEntry+CoreDataProperties.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 26-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "THDiaryEntry+CoreDataProperties.h"

@implementation THDiaryEntry (CoreDataProperties)

@dynamic date;
@dynamic mood;
@dynamic image;
@dynamic body;
@dynamic location;


//this returns a string for the property sectionName
- (NSString *)sectionName {
    
    NSDate *date  = [NSDate dateWithTimeIntervalSince1970:self.date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM yyy"];
    NSString *stringDate  = [dateFormatter stringFromDate:date];
    return stringDate;
}
@end
