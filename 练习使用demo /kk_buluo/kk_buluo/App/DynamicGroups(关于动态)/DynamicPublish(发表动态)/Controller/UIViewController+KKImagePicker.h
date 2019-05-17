//
//  UIViewController+KKImagePicker.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/26.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KKImagePickerCompletionHandler)(NSData *imageData, UIImage *image);

typedef void(^KKPicturesBlock)(void);

@interface UIViewController (KKImagePicker)
- (void)pickImageWithCompletionHandler:(KKImagePickerCompletionHandler)completionHandler withPictures:(KKPicturesBlock)pictures;
//- (void)pickImageWithCompletionHandler:(KKImagePickerCompletionHandler)completionHandler;
- (void)kpickImageWithpickImageCutImageWithImageSize:(CGSize)imageSize CompletionHandler:(KKImagePickerCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
