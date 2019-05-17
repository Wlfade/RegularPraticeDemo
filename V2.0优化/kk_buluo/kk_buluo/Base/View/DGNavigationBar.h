//
//  DGNavigationBar.h
//  DGTool
//
//  Created by david on 2018/12/26.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DGNavigationBarType) {
    DGNavigationBarTypeDefault,       //默认背景色,白色标题
    DGNavigationBarTypeClear,         //透明背景,无标题
    DGNavigationBarTypeWhite,         //白色背景,黑色标题
    DGNavigationBarTypeGray           //灰色背景,黑色标题
};

@interface DGNavigationBar : UIView

@property (nonatomic,assign) DGNavigationBarType barType;
@property (nonatomic,weak) UIButton *backButton;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,strong) UIImage *bgImage;
@property (nonatomic,strong) UIColor *bgColor;

@end

NS_ASSUME_NONNULL_END
