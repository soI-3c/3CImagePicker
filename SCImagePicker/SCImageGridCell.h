//
//  SCImageGridCell.h
//  SCImagePickerController
//
//  Created by liaosenshi on 16/4/9.
//  Copyright © 2016年 liaosenshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCImageGridCellSelectingView.h"


@protocol SCImageGridCellDelegate;
@interface SCImageGridCell : UICollectionViewCell
    @property(nonatomic, strong) UIImage *image;
    @property(nonatomic, strong) SCImageGridCellSelectingView *selectingView;
    @property(nonatomic, weak)   id<SCImageGridCellDelegate> delegate;
@end



@protocol SCImageGridCellDelegate <NSObject>
    // 图片Cell选中事件,
    // cell, 图像cell
    // selected 是否选中
    - (void)imageGridCell:(SCImageGridCell *) cell didSelected:(BOOL) selected;
@end