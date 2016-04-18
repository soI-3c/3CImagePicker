//
//  SCImageGridCellSelectingView.m
//  SCImagePickerController
//
//  Created by liaosenshi on 16/4/9.
//  Copyright © 2016年 liaosenshi. All rights reserved.
//

#import "SCImageGridCellSelectingView.h"

@interface SCImageGridCellSelectingView()
    @property(nonatomic, strong)  UIButton *selectBtn;
@end

@implementation SCImageGridCellSelectingView

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"select_yes"] forState: UIControlStateNormal];
    }
    return _selectBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.55;
        [self addSubview: self.selectBtn];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
   CGFloat x = self.frame.size.width - self.selectBtn.frame.size.width  - 4;
   CGFloat y = self.frame.size.height - self.selectBtn.frame.size.height - 4;
    self.selectBtn.frame = CGRectMake(x, y, self.frame.size.width / 4.0,  self.frame.size.height / 4.0);
}

@end
