//
//  SCImageGridViewLayout.m
//  SCImagePickerController
//
//  Created by liaosenshi on 16/4/9.
//  Copyright © 2016年 liaosenshi. All rights reserved.
//

#import "SCImageGridViewLayout.h"

/// 最小 Cell 宽高
#define SCGridCellMinWH 104

@implementation SCImageGridViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat margin = 2;
    CGFloat itemWH = [self itemWHWithCount:3 margin:margin];
    
    self.itemSize = CGSizeMake(itemWH, itemWH);
    self.minimumInteritemSpacing = margin;
    self.minimumLineSpacing = margin;
    self.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (CGFloat)itemWHWithCount:(NSInteger)count margin:(CGFloat)margin {
    CGFloat itemWH = 0;
    CGSize size = self.collectionView.bounds.size;
    do {
        itemWH = floor((size.width - (count + 1) * margin) / count);
        count++;
    } while (itemWH > SCGridCellMinWH);
    return itemWH;
}
@end
