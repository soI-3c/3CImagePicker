//
//  HBBrowseImageController.h
//  HBCameraPhotoController
//
//  Created by iOS-3C on 16/3/27.
//  Copyright © 2016年 heart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCBrowseImageController : UICollectionViewController
    @property(nonatomic, strong) NSArray *browseImages;
- (instancetype) initWithImages:(NSMutableArray *)photos selectIndex:(NSInteger) index;
@end
