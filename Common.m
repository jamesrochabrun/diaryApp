//
//  Common.m
//  CharterProject
//
//  Created by James Rochabrun on 9/21/16.
//  Copyright © 2016 jamesrochabrun. All rights reserved.
//

#import "Common.h"


NSArray * parseArrayOrNullFromServer (id object) {
   
    if  (object && [object isKindOfClass:[NSArray class]]) {
        return  (NSArray *)object;
    }
    return nil;
}

NSString * parseStringOrNullFromServer (id object) {
    
    if  (object && [object isKindOfClass:[NSString class]]) {
        return  (NSString *)object;
    }
    return nil;
}

NSDictionary * parseDictionaryOrNullFromServer (id object) {
    
    if  (object && [object isKindOfClass:[NSDictionary class]]) {
        return  (NSDictionary *)object;
    }
    return nil;
}

NSNumber * parseNSNumberOrNullFromServer (id object) {
    
    if  (object && [object isKindOfClass:[NSNumber class]]) {
        return  (NSNumber *)object;
    }
    if  (object && [object isKindOfClass:[NSString class]]) {
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:(NSString *)object];
        return myNumber;
    }
    return 0;
}


@implementation Common







@end
