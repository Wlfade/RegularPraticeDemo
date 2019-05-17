//
//  UIViewController+Base.h
//  kk_buluo
//
//  Created by david on 2019/3/14.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Base)

@property(nonatomic,strong) DGNavigationBar *naviBar;


#pragma mark - statusBar
- (UIStatusBarStyle)getStatusBarStyle;


#pragma mark - navi
/** 设置naviBar  barType类型 */
- (void)setNaviBarWithType:(DGNavigationBarType)barType;

#pragma mark title
/** 获取NaviBarTitle */
- (NSString *)naviBarTitle;

/** 设置NaviBarTitle */
- (void)setNaviBarTitle:(NSString *)title;

/** 设置title颜色 */
- (void)setNaviBarTitleColor:(UIColor *)color;

/** 设置title字体大小 */
- (void)setNaviBarTitleFont:(UIFont *)font;


#pragma mark backButton
/** 隐藏backBtn */
- (void)hideBackButton:(BOOL)hide;

/** 点击backBtn */
- (void)clickBackButton;

/** 延迟点击backBtn */
- (void)clickBackButtonWithDelay:(CGFloat)delay;

@end

NS_ASSUME_NONNULL_END
