//
//  SCImageGridViewController.m
//  SCImagePickerController
//
//  Created by liaosenshi on 16/4/9.
//  Copyright © 2016年 liaosenshi. All rights reserved.
//

#import "SCImageGridViewController.h"
#import "SCImageGridViewLayout.h"
#import "SCImageGridCell.h"
#import "SCBrowseImageController.h"

#define defMaxPickerCount 9
#define ScreenSize [UIScreen mainScreen].bounds.size

static NSString * const reuseIdentifier = @"SCImageGridCell";
typedef void (^accomplishTakePhoto)(NSMutableArray *);                  // 完成拍摄后的回调用所有图片
@interface SCImageGridViewController ()<SCImageGridCellDelegate>
    @property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;
    @property(nonatomic, strong) NSMutableArray <ALAsset *> *assets;                //资源对象
    @property(nonatomic, strong) NSMutableArray <ALAsset *> *selectAssets;
    @property(nonatomic, assign) NSInteger maxPickerCount;
@end

@implementation SCImageGridViewController {
    /// 预览按钮
    UIBarButtonItem *_previewItem;
    /// 完成按钮
    UIBarButtonItem *_doneItem;
}

- (NSMutableArray<ALAsset *> *)assets {
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}
- (NSMutableArray<ALAsset *> *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [[NSMutableArray alloc] init];
    }
    return _selectAssets;
}

-(instancetype) initMaxPickerConunt:(CGFloat) maxpickerCount withMaxSize:(CGFloat) maxSize {
    SCImageGridViewLayout *layout = [[SCImageGridViewLayout alloc] init];
    if (self = [super initWithCollectionViewLayout: layout]) {
        _maxPickerCount = maxpickerCount > 0 ? maxpickerCount : defMaxPickerCount;
        self.imgMaxSize = maxSize;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    [self prepareUI];
    [self fetchAssetCollectionWithCompletion];
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
}

- (BOOL) canAuthorizationStatus {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted){
        //无权限
        return NO;
    }
    return YES;
}
- (void) fetchAssetCollectionWithCompletion {
    dispatch_group_t threadGroup = dispatch_group_create();
    [self.assetsLibrary enumerateGroupsWithTypes: ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        @autoreleasepool {
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                dispatch_group_enter(threadGroup);
                if (result) {
                    [self.assets addObject: result];
                }
                dispatch_group_leave(threadGroup);
            }];
            dispatch_group_notify(threadGroup, dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    }failureBlock:^(NSError *error) {
        
    }];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: reuseIdentifier forIndexPath: indexPath];
    cell.image = [UIImage imageWithCGImage:[self.assets[indexPath.item] thumbnail]];
    cell.selectingView.hidden = true;
    cell.delegate = self;
    cell.selectingView.hidden = ![self.selectAssets containsObject:self.assets[indexPath.item]];
    return cell;
}

#pragma mark - 设置界面
- (void)prepareUI {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationController.toolbarHidden = NO;
    self.navigationItem.title = @"图片选择器";
    // 工具条
    _previewItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(clickPreviewButton)];
    _previewItem.enabled = NO;
    _doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickFinishedButton:)];
    _doneItem.enabled = NO;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[_previewItem,spaceItem,_doneItem];
    // 取消按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCloseButton)];
    // 注册可重用 cell
    [self.collectionView registerClass:[SCImageGridCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 更新计数器显示
    [self updateCounter];
}

#pragma mark - 监听方法
- (void)imageGridCell:(SCImageGridCell *) cell didSelected:(BOOL) selected {
    CGFloat maxpickerCount = self.maxPickerCount > 0 ? self.maxPickerCount : defMaxPickerCount;
    if (maxpickerCount == self.selectAssets.count && selected) {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message: [NSString stringWithFormat:@"当前最多还能选择%i张", (int)maxpickerCount] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        cell.selectingView.hidden = true;
        return;
    }
    NSIndexPath *path = [self.collectionView indexPathForCell: cell];
    ALAsset *asset = self.assets[path.item];
    if (selected) {
        [self.selectAssets addObject:asset];
    }else {
        [self.selectAssets removeObject:asset];
    }
    [self updateCounter];
}

#pragma mark: -- 选择完成事件
- (void)clickFinishedButton:(UIBarButtonItem *)btn {
    btn.enabled = NO;
    if (self.accomplishTakePhoto) {
        [self returnSelectImgs:^(NSArray<UIImage *> *imgs) {
            if (imgs) {
                [self dismissViewControllerAnimated:true completion:^{
                    btn.enabled = YES;
                    self.accomplishTakePhoto((NSMutableArray *)imgs);
                }];
            }
        }];
    }
}
#pragma mark: -- 预览
- (void) clickPreviewButton {
    [self returnSelectImgs:^(NSArray<UIImage *> *imgs) {
        if (imgs) {
            SCBrowseImageController *browseImage = [[SCBrowseImageController alloc] initWithImages:imgs selectIndex:0];
            [self.navigationController pushViewController:browseImage animated:true];
        }
    }];
}
- (void)returnSelectImgs:(void(^)( NSArray<UIImage *> *)) action {
    NSMutableArray <UIImage *> *fullScreenImages = [[NSMutableArray alloc] init];
    [self.selectAssets enumerateObjectsUsingBlock:^(ALAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 需传入方向和缩放比例，否则方向和尺寸都不对
        UIImage *tempImg = [UIImage imageWithCGImage:obj.defaultRepresentation.fullResolutionImage
                                               scale:obj.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)obj.defaultRepresentation.orientation];
        tempImg = [self scaleImage:tempImg withMaxDataLeng: self.imgMaxSize];
        if (tempImg) {
            [fullScreenImages addObject:tempImg];
        }
    }];
    action(fullScreenImages);               // 根据不同的逻辑实现不同
}

- (void) updateCounter {
    CGFloat maxpickerCount = self.maxPickerCount > 0 ? self.maxPickerCount : defMaxPickerCount;
    self.navigationItem.title = [NSString stringWithFormat:@"(%lu/ %d)图片选择器",(unsigned long) self.selectAssets.count,(int)maxpickerCount];
    _doneItem.enabled = self.selectAssets.count > 0;
    _previewItem.enabled = self.selectAssets.count > 0;
}

- (void) clickCloseButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark <按比利压缩图片>
- (UIImage *) scaleImage:(UIImage *)image withMaxDataLeng:(CGFloat) maxDataLeng {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    CGFloat maxWidth = 0.0;
    if (image.size.width > image.size.height) {
        maxWidth = image.size.height / sqrt( UIImageJPEGRepresentation(image, 1.0).length / 1024 / maxDataLeng);
    }else {
        maxWidth = image.size.width / sqrt( UIImageJPEGRepresentation(image, 1.0).length / 1024 / maxDataLeng);
    }
    maxWidth =  maxWidth > ScreenSize.width ? maxWidth : ScreenSize.width ;
    image = [self scaleImageToWidth: maxWidth byImage: image];
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > self.imgMaxSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    return [UIImage imageWithData:imageData];
}

- (UIImage *) scaleImageToWidth:(CGFloat) width byImage:(UIImage *)image{
    if (image.size.width < width) {
        return image;
    }
    CGFloat imgHeight = width * image.size.height / image.size.width;
    CGSize size  = CGSizeMake(width, imgHeight);
    UIGraphicsBeginImageContext(size);
    // 在制定区域中缩放绘制完整图像
    [image  drawInRect:CGRectMake(0, 0, size.width + 2, size.height + 2)];
    // 4. 获取绘制结果
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    // 5. 关闭上下文
    UIGraphicsEndImageContext();
    return result;
}

@end
