# 3CImagePicker
支持 iOS 7.0 以上  
1.导入头文件  
#import "SCImageGridViewController"  

在你要访问相册的事件中, 添加  :   
  在这只会访问 "相机胶卷" 这个相, 并不会访问其它自定义的相册  
 SCImageGridViewController *imageGridController = [[SCImageGridViewController alloc] initMaxPickerConunt:9 withMaxSize:200];  
    imageGridController.accomplishTakePhoto = ^(NSMutableArray <UIImage*> *photos) {        // 选择完成后的回调  
        // todo  
    };  
    if ([imageGridController canAuthorizationStatus]) {         // 判断权限  
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController: imageGridController] animated:true   completion:nil];  
    } else {  
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString   stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的手机相册", @" 智慧汽车网 "] delegate:nil cancelButtonTitle:@"确定"   otherButtonTitles:nil, nil] show];  
    }  

