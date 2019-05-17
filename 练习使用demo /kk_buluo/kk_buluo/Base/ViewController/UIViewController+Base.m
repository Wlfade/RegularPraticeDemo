//
//  UIViewController+Base.m
//  kk_buluo
//
//  Created by david on 2019/3/14.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "UIViewController+Base.h"

@implementation UIViewController (Base)

#pragma mark - 关联对象
static const char *associatedNaviBarKey = "associatedNaviBarKey";

-(void)setNaviBar:(DGNavigationBar *)naviBar {
    objc_setAssociatedObject(self, associatedNaviBarKey, naviBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(DGNavigationBar *)naviBar {
    DGNavigationBar *naviBar = objc_getAssociatedObject(self, associatedNaviBarKey);
    return naviBar;
}

#pragma mark - statusBar

- (UIStatusBarStyle)getStatusBarStyle {
    //1.如果有navigationBarView
    if (self.naviBar) {
        DGNavigationBarType barType = self.naviBar.barType;
        switch (barType) {
            case DGNavigationBarTypeDefault:
            case DGNavigationBarTypeClear:
                return UIStatusBarStyleLightContent;
                break;
            case DGNavigationBarTypeWhite:
            case DGNavigationBarTypeGray:
                return  UIStatusBarStyleDefault;
                break;
            default:
                return UIStatusBarStyleLightContent;
                break;
        }
    }
    
    //2.没有navigationBarView
    return UIStatusBarStyleLightContent;
}

#pragma mark - navi

/** 设置自定义的navigationBar */
-(void)setNaviBarWithType:(DGNavigationBarType)barType{
    
    //1.创建自定义的navigationBarView
    DGNavigationBar *naviBarV = [[DGNavigationBar alloc]init];
    self.naviBar = naviBarV;
    naviBarV.barType = barType;
    [self.view addSubview:naviBarV];
    //隐藏系统的navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    //2. backButton
    [naviBarV.backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.navigationController.viewControllers.count > 1) {
        naviBarV.backButton.hidden = NO;
    }else{
        naviBarV.backButton.hidden = YES;
    }
    
    //3. 更新statusBar
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark title
/** 获取NaviBarTitle */
- (NSString *)naviBarTitle {
    return self.naviBar.titleLabel.text;
}

/** 设置NaviBarTitle */
- (void)setNaviBarTitle:(NSString *)title {
    if (title.length > 10) {
        self.naviBar.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    self.naviBar.titleLabel.text = title;
}

/** 设置title颜色 */
- (void)setNaviBarTitleColor:(UIColor *)color{
    self.naviBar.titleLabel.textColor = color;
}

/** 设置title字体大小 */
- (void)setNaviBarTitleFont:(UIFont *)font{
    self.naviBar.titleLabel.font = font;
}

#pragma mark backButton
//隐藏backBtn
- (void)hideBackButton:(BOOL)hide {
    self.naviBar.backButton.hidden = hide;
}

/** 点击backBtn */
-(void)clickBackButton {
    
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/** 延迟点击backBtn */
-(void)clickBackButtonWithDelay:(CGFloat)delay {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self clickBackButton];
    });
}

@end
