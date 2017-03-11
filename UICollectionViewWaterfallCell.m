//
//  UICollectionViewWaterfallCell.m
//  momentum
//
//  Created by James Rochabrun on 3/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

#import "UICollectionViewWaterfallCell.h"

@implementation UICollectionViewWaterfallCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // agregamos una sombra a la celda
        self.backgroundColor = [UIColor yellowColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity = 0.4f;
        //self.backgroundColor = [UIColor yellowColor];
        
        _productImageView = [UIImageView new];
        [self addSubview:_productImageView];
        
        //    // formatear selected background view
        //    UIView *backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        //    backgroundView.layer.borderColor = [[UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1] CGColor];
        //    backgroundView.layer.borderWidth = 10.0f;
        //    self.selectedBackgroundView = backgroundView;
        
        // formatear la imagen
        [self formatProductImageView];
        
        // formatear el contenedor del avatar
        [self formatAvatarImageContainerView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = _productImageView.frame;
    frame.size.height = self.frame.size.height;
    frame.size.width = self.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = 0;
    _productImageView.frame = frame;
}

//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//
//    NSLog(@"prepareForReuse");
//
//    // limpiamos la celda
//    [[self nameLabel] setText:nil];
//    [[self productImageView] setImage:nil];
//    [[self avatarImageView] setImage:nil];
//
////    // limpiamos la data de las imágenes
////    [[self imageDetail] setImageData:nil];
////    [[self imageDetail] setThumbnailData:nil];
////
////    // formatear la imagen
////    [self formatProductImageView];
////
////    // formatear el avatar
////    [self formatAvatarImageView];
//}

- (void)formatProductImageView
{
    self.productImageView.layer.borderColor = [[UIColor colorWithRed:109/255 green:103/255 blue:98/255 alpha:0.1] CGColor];
    self.productImageView.layer.borderWidth = 1.0f;
}

- (void)formatAvatarImageContainerView
{
    //self.avatarImageView.layer.cornerRadius = 10.0f;
    
    self.avatarImageContainerView.layer.borderColor = [[UIColor colorWithRed:109/255 green:103/255 blue:98/255 alpha:0.1] CGColor];
    self.avatarImageContainerView.layer.borderWidth = 1.0f;
    
    self.avatarImageContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.avatarImageContainerView.layer.shadowRadius = 2.0f;
    self.avatarImageContainerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.avatarImageContainerView.layer.shadowOpacity = 0.4f;
}



@end
