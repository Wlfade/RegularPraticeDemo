//
//  DGButton.h
//  DGTool
//
//  Created by david on 2018/10/26.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DGButton;
typedef void(^DGButtonClickBlock)(DGButton *btn);

@interface DGButton : UIButton

#pragma mark - create
+ (DGButton *)btnWithFontSize:(CGFloat)fontSize title:(NSString *)title titleColor:(UIColor *)titleColor;

+ (DGButton *)btnWithFontSize:(CGFloat)fontSize bold:(BOOL)bold title:(NSString *)title titleColor:(UIColor *)titleColor;

+ (DGButton *)btnWithFontSize:(CGFloat)fontSize title:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor;

+ (DGButton *)btnWithFontSize:(CGFloat)fontSize bold:(BOOL)bold title:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor;

+ (DGButton *)btnWithImg:(UIImage *)img;

+ (DGButton *)btnWithBgImg:(UIImage *)bgImg;

#pragma mark - convenience
- (void)setNormalTitle:(NSString *)nTitle selectedTitle:(NSString *)sTitle;
- (void)setNormalTitleColor:(UIColor *)nColor selectedTitleColor:(UIColor *)sColor;

- (void)setNormalImg:(UIImage *)nImg selectedImg:(UIImage *)sImg;
- (void)setNormalBgImg:(UIImage *)nBgImg selectedBgImg:(UIImage *)sBgImg;

- (void)setNormalBgColor:(UIColor *)nBgColor selectedBgColor:(UIColor *)sBgColor;


#pragma mark - click
/** 允许点击的时间间隔,默认0.2秒 */
@property(nonatomic,assign) CGFloat clickTimeInterval;

/** 防止连续点击 */
- (void)addClickBlock:(DGButtonClickBlock)block;

@end
