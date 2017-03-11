//
//  WaterFallCVDatasource.h
//  momentum
//
//  Created by James Rochabrun on 3/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WaterFallCVDatasource : NSObject<UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray *collection;

@end
