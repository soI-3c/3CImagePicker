//
//  SCImageGridCell.m
//  SCImagePickerController
//
//  Created by liaosenshi on 16/4/9.
//  Copyright © 2016年 liaosenshi. All rights reserved.
//

#import "SCImageGridCell.h"

@interface SCImageGridCell()
    @property(nonatomic, strong) UIImageView *imageView;
@end

@implementation SCImageGridCell

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _selectingView.frame = self.bounds;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tapGestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellOnClick:)];
        [self addGestureRecognizer:tapGestur];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectingView];
    }
    return self;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (SCImageGridCellSelectingView *)selectingView {
    if (!_selectingView) {
        _selectingView = [[SCImageGridCellSelectingView alloc] init];
    }
    return _selectingView;
}
- (void)setImage:(UIImage *)image {
    if (image) {
        _image = image;
        [self.imageView setImage: self.image];
    }
}
-(void) cellOnClick:(SCImageGridCell *) cell {
    self.selectingView.hidden = !self.selectingView.hidden;
    if (self.delegate) {
        [self.delegate imageGridCell:self didSelected: !self.selectingView.hidden];
    }
}
@end
