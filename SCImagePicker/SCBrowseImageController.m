//
//  HBBrowseImageController.m
//  HBCameraPhotoController
//
//  Created by iOS-3C on 16/3/27.
//  Copyright © 2016年 heart. All rights reserved.
//

#import "SCBrowseImageController.h"
#import "SCImageCollectionCell.h"

#pragma mark <图片浏览器>
@interface SCBrowseImageController ()
    @property(nonatomic, assign) NSInteger selectIndex;
@end

@implementation SCBrowseImageController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark <图片数据源, 用户所选择的下标>
- (instancetype) initWithImages:(NSMutableArray *)photos selectIndex:(NSInteger) index{
    if (self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]) {
        self.browseImages = photos;
        self.selectIndex = index;                   // 进来时图片的下标, 滚动到指定位置
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareLayout];
    [self.collectionView registerClass:[SCImageCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    // 视图将要显示的时候滚动到显示用户选择的图片位置
  NSIndexPath *selectPath = [NSIndexPath indexPathForItem:self.selectIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:selectPath atScrollPosition: UICollectionViewScrollPositionLeft animated:true];
}
- (void)prepareLayout {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = self.view.bounds.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = true;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.browseImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.showImage = self.browseImages[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark <UICollectionViewDelegate>

@end
