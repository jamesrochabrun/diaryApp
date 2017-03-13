//
//  WaterFallCVDatasource.m
//  momentum
//
//  Created by James Rochabrun on 3/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

#import "WaterFallCVDatasource.h"
#import "ImageDetail.h"
#import "UICollectionViewWaterfallCell.h"

static NSString * const reuseIdentifier = @"Cell";

@implementation WaterFallCVDatasource

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadDummyData];
    }
    return self;
}


- (void)loadDummyData {
    
    _collection = [NSMutableArray new];
    
    ImageDetail *sasha = [[ImageDetail alloc] init];
    sasha.author = @"sasha";
    sasha.ruta_thumbnail = @"sasha";
    sasha.images = @"sasha";
    
    ImageDetail *zapatillas = [[ImageDetail alloc] init];
    zapatillas.author = @"zapatillas";
    zapatillas.ruta_thumbnail = @"zapatillas";
    zapatillas.images = @"zapatillas";
    
    ImageDetail *abrigo = [[ImageDetail alloc] init];
    abrigo.author = @"abrigo";
    abrigo.ruta_thumbnail = @"abrigo";
    abrigo.images = @"abrigo";
    
    ImageDetail *camisa = [[ImageDetail alloc] init];
    camisa.author = @"camisa";
    camisa.ruta_thumbnail = @"camisa";
    camisa.images = @"camisa";
    
    ImageDetail *crop = [[ImageDetail alloc] init];
    crop.author = @"crop";
    crop.ruta_thumbnail = @"crop";
    crop.images = @"crop";
    
    ImageDetail *lentes = [[ImageDetail alloc] init];
    lentes.author = @"lentes";
    lentes.ruta_thumbnail = @"lentes";
    lentes.images = @"lentes";
    
    ImageDetail *polera = [[ImageDetail alloc] init];
    polera.author = @"polera";
    polera.ruta_thumbnail = @"polera";
    polera.images = @"polera";
    
    ImageDetail *sombrero = [[ImageDetail alloc] init];
    sombrero.author = @"sombrero";
    sombrero.ruta_thumbnail = @"sombrero";
    sombrero.images = @"sombrero";
    
    NSLog(@"camisa %f", camisa.imageSizeH);
    
    UIImage *cami = [UIImage imageNamed:@"crop"];
    NSLog(@"WIDTH: %f", cami.size.width);
    
    [self.collection addObject:camisa];
    [self.collection addObject:crop];
    [self.collection addObject:sombrero];
    [self.collection addObject:sasha];
    [self.collection addObject:zapatillas];
    [self.collection addObject:abrigo];
    [self.collection addObject:lentes];
    [self.collection addObject:polera];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
    ImageDetail *prenda = [[self collection] objectAtIndex:[indexPath item]];
    
    
    UICollectionViewWaterfallCell *cell =
    (UICollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                               forIndexPath:indexPath];
    
    //[[cell productImageView] setImageWithURL:[NSURL URLWithString:[prenda images]]];
    cell.productImageView.image = [UIImage imageNamed:prenda.images];
    
    
    //[[cell avatarImageView] setImageWithURL:[NSURL URLWithString:[prenda ruta_thumbnail]]];
    cell.avatarImageView.image = [UIImage imageNamed:prenda.ruta_thumbnail];
    
    // Datos del owner
    cell.nameLabel.text = prenda.author;
    
    NSLog(@"prenda.author: %@",  prenda.author);
    
    
    cell.tag = indexPath.row;
    
    cell.imageDetail = [self.collection objectAtIndex:indexPath.row];
    
    return  cell;
}

@end
