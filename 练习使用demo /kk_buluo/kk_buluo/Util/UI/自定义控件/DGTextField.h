//
//  DGTextField.h
//  DGTool
//
//  Created by jczj on 2018/11/2.
//  Copyright © 2018年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGTextField : UITextField

//上移后，textField需要额外高于键盘顶部的距离，默认为0
@property (nonatomic, assign) CGFloat offset;

//需要向上移动的view，默认为keyWindow
@property (nonatomic, weak) UIView *movingView;


-(instancetype)initWithFrame:(CGRect)frame textFont:(CGFloat)font  textColor:(UIColor *)color bagTextColor:(UIColor *)bagColor  textAlignment:(NSTextAlignment)alignment;
@end

NS_ASSUME_NONNULL_END
