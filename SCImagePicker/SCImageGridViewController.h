//
//  SCImageGridViewController.h
//  SCImagePickerController
//
//  Created by liaosenshi on 16/4/9.
//  Copyright © 2016年 liaosenshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^accomplishTakePhoto)(NSMutableArray *);                  // 完成拍摄后的回调用所有图片
@interface SCImageGridViewController : UICollectionViewController

    @property(nonatomic, copy) accomplishTakePhoto accomplishTakePhoto;
    @property(nonatomic, assign) CGFloat imgMaxSize;                    // 图片大小最大上限 /kb
    - (instancetype) initMaxPickerConunt:(CGFloat) maxpickerCount withMaxSize:(CGFloat) maxSize ;        // 默认最多 9张
    - (BOOL) canAuthorizationStatus;                                    // 判断是否有权限访问相册
@end
