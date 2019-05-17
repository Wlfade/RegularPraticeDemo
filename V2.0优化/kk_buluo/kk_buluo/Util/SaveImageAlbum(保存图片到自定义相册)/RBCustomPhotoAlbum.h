//
//  RBCustomPhotoAlbum.h
//  SavePhotoDemo
//
//  Created by 单车 on 2019/1/14.
//  Copyright © 2019 allison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RBCustomPhotoAlbum : NSObject
+ (instancetype)shareInstance;

/**
 保存图片到相册
 @param image 图片
 @param reminder 是否需要提示
 */
- (void)saveImageIntoAlbum:(nonnull UIImage *)image withNeedReminder:(BOOL)reminder;
- (void)showAlertMessage:(NSString *)message;
- (void)showSubmitAlert:(NSString *)subSting;
@end

NS_ASSUME_NONNULL_END
