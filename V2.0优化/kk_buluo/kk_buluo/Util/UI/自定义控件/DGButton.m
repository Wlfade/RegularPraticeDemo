//
//  DGButton.m
//  DGTool
//
//  Created by david on 2018/10/26.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGButton.h"

@interface DGButton ()

@property(nonatomic,copy) DGButtonClickBlock clickBlock;

@end


@implementation DGButton

#pragma mark - create

+ (DGButton *)btnWithFontSize:(CGFloat)fontSize title:(NSString *)title titleColor:(UIColor *)titleColor {
    return [self btnWithFontSize:fontSize bold:NO title:title titleColor:titleColor];
}

+ (DGButton *)btnWithFontSize:(CGFloat)fontSize bold:(BOOL)bold title:(NSString *)title titleColor:(UIColor *)titleColor {
    return [self btnWithFontSize:fontSize bold:bold title:title titleColor:titleColor bgColor:nil];
}

+ (DGButton *)btnWithFontSize:(CGFloat)fontSize title:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor {
    return [self btnWithFontSize:fontSize bold:NO title:title titleColor:titleColor bgColor:bgColor];
}

+ (DGButton *)btnWithFontSize:(CGFloat)fontSize bold:(BOOL)bold title:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor{

    DGButton *btn = [[DGButton alloc]init];
    btn.backgroundColor = bgColor;
    if (bold) {
         btn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
         btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
   
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

+ (DGButton *)btnWithImg:(UIImage *)img{
    DGButton *btn = [[DGButton alloc]init];
    [btn setImage:img forState:UIControlStateNormal];
    return btn;
}

+ (DGButton *)btnWithBgImg:(UIImage *)bgImg {
    DGButton *btn = [[DGButton alloc]init];
    [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
    return btn;
}

#pragma mark - convenience
- (void)setNormalTitle:(NSString *)nTitle selectedTitle:(NSString *)sTitle{
    [self setTitle:nTitle forState:UIControlStateNormal];
    [self setTitle:sTitle forState:UIControlStateSelected];
}

- (void)setNormalTitleColor:(UIColor *)nColor selectedTitleColor:(UIColor *)sColor{
    [self setTitleColor:nColor forState:UIControlStateNormal];
    [self setTitleColor:sColor forState:UIControlStateSelected];
}

- (void)setNormalImg:(UIImage *)nImg selectedImg:(UIImage *)sImg {
    [self setImage:nImg forState:UIControlStateNormal];
    [self setImage:sImg forState:UIControlStateSelected];
}

- (void)setNormalBgImg:(UIImage *)nBgImg selectedBgImg:(UIImage *)sBgImg {
    [self setBackgroundImage:nBgImg forState:UIControlStateNormal];
    [self setBackgroundImage:sBgImg forState:UIControlStateSelected];
}

- (void)setNormalBgColor:(UIColor *)nBgColor selectedBgColor:(UIColor *)sBgColor {
    UIImage *nBgImg = [self imageWithBgColor:nBgColor];
    UIImage *sBgImg = [self imageWithBgColor:sBgColor];
    [self setNormalBgImg:nBgImg selectedBgImg:sBgImg];
}


#pragma mark - 点击
/** 添加clickBlock: 防止连续点击 */
- (void)addClickBlock:(DGButtonClickBlock)block{
    self.clickBlock = block;
    self.clickTimeInterval = 0.01;
    [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

/** 点击button */
- (void)btnClicked:(DGButton *)button {
    self.clickBlock(button);
    self.enabled = NO;
    [self performSelector:@selector(changeEnabled:) withObject:button afterDelay:self.clickTimeInterval];
    
}

/** 改变button的enabled */
- (void)changeEnabled:(DGButton *)button{
    self.enabled = YES;
}

#pragma mark - tool
/** 画圆角矩形 */
- (UIImage *)imageWithBgColor:(UIColor *)bgColor{
    
    //1.画image
    CGSize size = CGSizeMake(10, 10);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    //CGContextRef contentRef = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:0];
    [path addClip];
    [bgColor setFill];
    [path fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //2.可拉伸
    UIEdgeInsets insets = UIEdgeInsetsMake(0, size.height/2.0 + 1, 0, size.height/2.0 +1);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    //3.return
    return image;
}

@end
