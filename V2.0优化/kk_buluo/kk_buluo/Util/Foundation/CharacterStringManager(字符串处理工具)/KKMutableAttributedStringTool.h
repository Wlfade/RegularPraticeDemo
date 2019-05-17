//
//  KKMutableAttributedStringTool.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKMutableAttributedStringTool : NSObject

/**
 几个字符串p拼接成可变字符

 @param strings 字符串 数组
 @param colors 颜色 数组
 @param fonts 字体大小 数组
 @return 可变字符串
 */
+ (NSMutableAttributedString *)makeTheStrings:(NSArray *)strings withColors:(NSArray *)colors withFonts:(NSArray *)fonts;


/**
 创建可变字符串加删除划线

 @param strings 字符串 数组
 @param colors 颜色 数组
 @param fonts 字体大小 数组
 @param index 确定是哪个字符串需要划线的下标
 @return 创建可变字符串加删除划线
 */
+ (NSMutableAttributedString *)makeTheStrings:(NSArray *)strings withColors:(NSArray *)colors withFonts:(NSArray *)fonts withDeleteLineIndex:(NSInteger)index;

/**
 根据图片的名字和尺寸创建可变字符串
 @param imageName 图片名
 @param imageSize 图片尺寸
 @return 可变字符串
 */
+ (NSAttributedString *)makeTextAttachmentWithImagName:(NSString *)imageName withImageSize:(CGSize )imageSize;
@end

NS_ASSUME_NONNULL_END
