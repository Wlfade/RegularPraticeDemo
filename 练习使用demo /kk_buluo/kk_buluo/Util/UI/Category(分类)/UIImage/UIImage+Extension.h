//
//  UIImage+Extension.h
//  BasicFramework
//
//  Created by Rainy on 16/10/26.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

#pragma mark - convinence
/** 识别图片中的二维码 */
-(BOOL)haveQRCode;

- (UIImage *)imageAdjustedByColor:(UIColor *)color;

- (UIImage*)imageRotatedByAngle:(CGFloat)Angle;

+ (UIImage *)imageWithColor:(UIColor*)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 获取BundleImg
+(UIImage *)imgNamed:(NSString *)imgName inBundle:(NSString *)bundleName;



#pragma mark - size
-(UIImage*)scaleToSize:(CGSize)size;

-(UIImage *)scaleToDefineWidth:(CGFloat)defineWidth;

//聊天的文字气泡拉伸
+ (UIImage *)resizedImage:(NSString *)name;

//调整图片大小
+ (UIImage *)resizedImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/* 裁剪椭圆形图片 例如：头像 */
+ (UIImage *)clipOvalImage:(UIImage *)image;

#pragma mark - bytesSize
/**
 *  压缩图片到指定文件大小
 *  @param KbSize  目标大小（最大值）(单位kb)
 *  @return 返回的图片文件
 */
- (UIImage *)compressToMaxKbSize:(CGFloat)KbSize;



#pragma mark - snapshot截图
+ (UIImage *)snapshotImageFromView:(UIView *)theView;

+ (UIImage *)snapshotImageFromScrollView:(UIScrollView *)scrollView;



#pragma mark - color
/**
 @brief根据图片获取主要颜色
 @param image      图片
 @ignoreDeviation  默认为0,不忽略偏差
 @return 颜色值
 */
+(UIColor*)mostColor:(UIImage*)image;

/**
 @brief根据图片获取主要颜色
 @param image      图片
 @ignoreDeviation  忽略偏差 (rgb两两偏差都小于此值的颜色,不记录比较)
 例1-> 灰色rgb相互偏差为0;  例2-> r=1,b=5,他们偏差为4
 @return 颜色值
 */
+(UIColor*)mostColor:(UIImage*)image ignoreDeviation:(NSUInteger)deviation;

/**
 *  @brief  取图片某一点的颜色
 *  @param point 某一点
 *  @return 颜色
 */
- (UIColor *)colorAtPoint:(CGPoint )point;

//more accurate method ,colorAtPixel 1x1 pixel
/**
 *  @brief  取某一像素的颜色
 *  @param point 一像素
 *  @return 颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;



#pragma mark - tint
- (UIImage *)lightImage;
- (UIImage *)extraLightImage;
- (UIImage *)darkImage;
- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;

/**
 *  @brief  获得灰度图
 *  @param sourceImage 图片
 *  @return 获得灰度图片
 */
+ (UIImage*)covertToGrayImageFromImage:(UIImage*)sourceImage;

#pragma mark - Blur
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

- (UIImage *)blurredImageWithRadius:(CGFloat)blurRadius;
- (UIImage *)blurredImageWithSize:(CGSize)blurSize;
- (UIImage *)blurredImageWithSize:(CGSize)blurSize
                        tintColor:(UIColor *)tintColor
            saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                        maskImage:(UIImage *)maskImage;




@end
