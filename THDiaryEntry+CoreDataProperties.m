//
//  THDiaryEntry+CoreDataProperties.m
//  momentum
//
//  Created by James Rochabrun on 10/20/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "THDiaryEntry+CoreDataProperties.h"
#import <UIKit/UIKit.h>

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

//- (CGSize )loadImageData {
//    UIImage *img = [UIImage imageWithData:self.image];
//    //CGFloat width = img.size.width <= 0.0 ? 960.0 : img.size.width;
////    CGFloat y = (152 * 100)/ width;
////    self.imageSizeH = (img.size.height * y)/100;
////    self.imageSizeW = width;
//    
//    //h1/ w1 = h2 / w2
//    //h2 = h1 / w1 * w2
////    self.imageSizeH = img.size.height / img.size.width * 200;
////    
////    return  CGSizeMake(200, self.imageSizeH);
//}




@end
