//
//  HBImageCollectionCellCollectionCell.m
//  HBCameraPhotoController
//
//  Created by iOS-3C on 16/3/27.
//  Copyright © 2016年 heart. All rights reserved.
//

#import "SCImageCollectionCell.h"
#define SCREENSIZE [UIScreen mainScreen].bounds.size
#define CutOutBtnWH 15

@interface SCImageCollectionCell()
    @property(nonatomic, strong) UIImageView *imageView;
@end

@implementation SCImageCollectionCell

- (void)setShowImage:(UIImage *)showImage {
    _showImage = showImage;
    self.imageView.image = self.showImage;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
       _imageView.contentMode =  UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}
@end
