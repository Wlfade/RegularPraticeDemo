//
//  UIViewController+KKImagePicker.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/26.
//  Copyright © 2019 yaya. All rights reserved.
//


#import "UIViewController+KKImagePicker.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>


static void *kImagePickerCompletionHandlerKey = @"kImagePickerCompletionHandlerKey";
static void *kImagePicturesKey = @"kImagePicturesKey";

static void *kCameraPickerKey = @"kCameraPickerKey";
static void *kPhotoLibraryPickerKey = @"kPhotoLibraryPickerKey";
static void *kImageSizeKey = @"kimageSizeKey";
static void *isCut =  @"isCut"; //截取


@interface UIViewController ()
<UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

//照相机控制器
@property (nonatomic, strong) UIImagePickerController *cameraPicker;
//相册控制器
@property (nonatomic, strong) UIImagePickerController *photoLibraryPicker;


//返回的数据block
@property (nonatomic, copy) KKImagePickerCompletionHandler completionHandler;
@property (nonatomic, copy) KKPicturesBlock pictures;


@property (nonatomic, assign) BOOL isCutImageBool; //是否需要裁剪图片
@property (nonatomic, assign) CGSize imageSize; //裁剪图片的尺寸
@end

@implementation UIViewController (KKImagePicker)
//- (void)pickImageWithCompletionHandler:(KKImagePickerCompletionHandler)completionHandler{
//    self.completionHandler = completionHandler;
//    [self presentChoseActionSheet];
//}
- (void)pickImageWithCompletionHandler:(KKImagePickerCompletionHandler)completionHandler withPictures:(KKPicturesBlock)pictures{
    
    self.completionHandler = completionHandler;
    self.pictures = pictures;
    
    [self kpresentChoseActionSheet];
}

- (void)kpickImageWithpickImageCutImageWithImageSize:(CGSize)imageSize CompletionHandler:(KKImagePickerCompletionHandler)completionHandler{
    self.completionHandler = completionHandler;
    self.isCutImageBool = YES;
    self.imageSize = imageSize;
    [self kpresentChoseActionSheet];
}
//判断摄像机是否可用
- (void)setUpCameraPickControllerIsEdit:(BOOL)isEdit {
    self.cameraPicker = [[UIImagePickerController alloc] init];
    self.cameraPicker.allowsEditing = isEdit; //拍照选去是否可以截取，和代理中的获取截取后的方法配合使用
    self.cameraPicker.delegate = self;
    self.cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
}
//判断相册是否可用
- (void)setUpPhotoPickControllerIsEdit:(BOOL)isEdit {
    self.photoLibraryPicker = [[UIImagePickerController alloc] init];
    self.photoLibraryPicker.allowsEditing = isEdit; // 相册选取是否截图
    self.photoLibraryPicker.delegate = self;
    //去掉毛玻璃效果 否则在ios11 下 全局设置了UIScrollViewContentInsetAdjustmentNever 导致导航栏遮住了内容视图
    self.photoLibraryPicker.navigationBar.translucent = NO;
    self.photoLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}
- (void)kpresentChoseActionSheet {
    
    //先创建好 不然调用的时候 第一次创建很慢 有2秒的延迟
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断相机可用
        [self setUpCameraPickControllerIsEdit:self.isCutImageBool];
    }
    [self setUpPhotoPickControllerIsEdit:self.isCutImageBool];
    
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self presentViewController:self.cameraPicker animated:YES completion:nil];
            }
            else {
                UIAlertController * noticeAlertController = [UIAlertController alertControllerWithTitle:@"未开启相机权限，请到设置界面开启" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"现在就去" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //跳转到设置界面
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                            
                        }];
                    } else {
                        // Fallback on earlier versions
                    }
                }];
                
                [noticeAlertController addAction:cancelAction];
                [noticeAlertController addAction:okAction];
                [self presentViewController:noticeAlertController animated:YES completion:^{
                    
                }];
            }
        }];

        
    }];
    
    UIAlertAction * choseFromAlbumAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pictures();
    }];
    
    [actionController addAction:cancelAction];
    [actionController addAction:takePhotoAction];
    [actionController addAction:choseFromAlbumAction];
    
    [self presentViewController:actionController animated:YES completion:^{
        
    }];
}
#pragma mark <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editedimage = [[UIImage alloc] init];
    if(self.isCutImageBool){
        //获取裁剪的图
        editedimage = info[@"UIImagePickerControllerEditedImage"]; //获取裁剪的图
        CGSize imageSize = CGSizeMake(413, 626);
        if (self.imageSize.height>0) {
            imageSize = self.imageSize;
        }
        editedimage = [self reSizeImage:editedimage toSize:imageSize];
    }
    else{
        editedimage = info[@"UIImagePickerControllerOriginalImage"];
    }
    NSData *imageData = UIImageJPEGRepresentation(editedimage, 0.0001);//首次进行压缩
    UIImage *image = [UIImage imageWithData:imageData];
    //图片限制大小不超过 1M     CGFloat  kb =   data.lenth / 1000;  计算kb方法 os 按照千进制计算
    while (imageData.length/1000 > 1024) {
        NSLog(@"图片超过1M 压缩");
        imageData = UIImageJPEGRepresentation(image, 0.5);
        image = [UIImage imageWithData:imageData];
    }
    self.completionHandler(imageData, image);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

#pragma mark - setters & getters

- (void)setCompletionHandler:(KKImagePickerCompletionHandler)completionHandler {
    objc_setAssociatedObject(self, kImagePickerCompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
}

- (KKImagePickerCompletionHandler)completionHandler {
    return objc_getAssociatedObject(self, kImagePickerCompletionHandlerKey);
}

- (void)setPictures:(KKPicturesBlock)pictures{
    objc_setAssociatedObject(self, kImagePicturesKey, pictures, OBJC_ASSOCIATION_COPY);
}

- (KKPicturesBlock)pictures{
     return objc_getAssociatedObject(self, kImagePicturesKey);
}

//设置相机授权
- (void)setCameraPicker:(UIImagePickerController *)cameraPicker {
    objc_setAssociatedObject(self, kCameraPickerKey, cameraPicker, OBJC_ASSOCIATION_RETAIN);
}
//获取相机授权
- (UIImagePickerController *)cameraPicker {
    return objc_getAssociatedObject(self, kCameraPickerKey);;
}
//设置相册授权
- (void)setPhotoLibraryPicker:(UIImagePickerController *)photoLibraryPicker {
    objc_setAssociatedObject(self, kPhotoLibraryPickerKey, photoLibraryPicker, OBJC_ASSOCIATION_RETAIN);
}
//获取相册授权
- (UIImagePickerController *)photoLibraryPicker {
    return objc_getAssociatedObject(self, kPhotoLibraryPickerKey);
}

- (void)setIsCutImageBool:(BOOL)isCutImageBool {
    return objc_setAssociatedObject(self, isCut, @(isCutImageBool), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isCutImageBool {
    return [objc_getAssociatedObject(self, isCut) boolValue];
}

- (void)setImageSize:(CGSize)imageSize {
    return objc_setAssociatedObject(self, kImageSizeKey, [NSValue valueWithCGSize:imageSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)imageSize {
    NSValue * value = objc_getAssociatedObject(self, kImageSizeKey);
    return  value.CGSizeValue;
}

@end
