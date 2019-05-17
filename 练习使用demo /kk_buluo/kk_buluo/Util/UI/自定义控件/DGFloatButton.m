//
//  DGFloatButton.m
//  AbacusGo
//
//  Created by david on 17/9/1.
//  Copyright © 2017年 david. All rights reserved.
//

#import "DGFloatButton.h"
#define kScreenW       ([UIScreen mainScreen].bounds.size.width)
#define kScreenH       ([UIScreen mainScreen].bounds.size.height)
#define kIPhoneX  (MAX(kScreenW, kScreenH) >= 812)
#define kTabBarH  (kIPhoneX ? (49.f+34.f) : 49.f)

// 枚举四个吸附方向
typedef enum {
    AGFloatLeft,
    AGFloatRight,
    AGFloatTop,
    AGFloatBottom
}AGFloatDirection;

@interface DGFloatButton ()
@property (nonatomic,copy) NSString *imageUrlStr;
@property (nonatomic,copy) NSString *hrefUrlStr;
@end

@implementation DGFloatButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

#pragma mark - 配置
-(void)config{
    
    //1.添加target
    [self addTarget:self action:@selector(floatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //2.pan手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [self addGestureRecognizer:panRcognize];
}

#pragma mark - button点击
/** 悬浮按钮点击 */
- (void)floatButtonClicked:(UIButton *)sender{
    if (self.clickBlock) {
        self.userInteractionEnabled = NO;
        self.clickBlock();
        //防连续点击
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
    }
}

#pragma mark - pan手势
/** 悬浮按钮移动事件处理 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer{
    //1.移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    UIView *view = recognizer.view;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint translation = [recognizer translationInView:view.superview];
            view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
        }break;
            
        case UIGestureRecognizerStateEnded:{
            //2.确定最终center
            //2.0 准备参数
            CGFloat centerX = view.center.x;
            CGFloat centerY = view.center.y;
            CGFloat w = view.frame.size.width;
            CGFloat h = view.frame.size.height;
            CGFloat space = 5;
            
            CGFloat superViewW = view.superview.frame.size.width;
            CGFloat superViewH = view.superview.frame.size.height;
            CGFloat superTopMargin = [self getTopMargin];
            CGFloat superBottomMarin = [self getBottomMargin];
            
            //2.1 确定吸附方向
            CGFloat left = centerX;
            CGFloat right = superViewW - centerX;
            CGFloat top = centerY;
            CGFloat bottom = superViewH - centerY;
            
            AGFloatDirection minDirection = AGFloatLeft;
            CGFloat minDistance = left;
            if (right < minDistance) {
                minDistance = right;
                minDirection = AGFloatRight;
            }
            if (top < minDistance) {
                minDistance = top;
                minDirection = AGFloatTop;
            }
            if (bottom < minDistance) {
                minDirection = AGFloatBottom;
            }
            
           //2.2 最终 四个方向的center坐标
            CGFloat finalLeft = w/2.0 + space;
            CGFloat finalRight = superViewW - w/2.0 - space;
            CGFloat finalTop = superTopMargin + h/2.0 + space;
            CGFloat finalBottom = superViewH - superBottomMarin - h/2.0 - space;
            
            //2.3 吸附center坐标
            CGPoint newCenter = CGPointMake(w+5, h/ 2.0);
            switch (minDirection) {
                case AGFloatLeft:
                    newCenter = CGPointMake(finalLeft, centerY);
                    break;
                case AGFloatRight:
                    newCenter = CGPointMake(finalRight, centerY);
                    break;
                case AGFloatTop:
                    newCenter = CGPointMake(centerX, finalTop);
                    break;
                case AGFloatBottom:
                    newCenter = CGPointMake(centerX,finalBottom);
                    break;
            }
            
            //2.4 验证最终center的x
            if (newCenter.x < finalLeft) {
                newCenter.x = finalLeft;
            }else if (newCenter.x > finalRight){
                newCenter.x = finalRight;
            }
            
            //2.5 验证最终center的y
            if (newCenter.y < finalTop) {
                newCenter.y = finalTop;
            }else if (newCenter.y > finalBottom){
                newCenter.y = finalBottom;
            }
            
            //2.6 动画
            [UIView animateWithDuration:0.3 animations:^{
                recognizer.view.center = newCenter;
            }];
        }break;
            
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
    
    //3. 复位Translation
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
}

#pragma mark - tool
-(CGFloat)getTopMargin {
    
    //1.默认为0
    CGFloat margin = 0;
    
    UIResponder* nextResponder = self.superview.nextResponder;
    //2.如果superV的nextResponder是UIViewControler
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)nextResponder;
        //如果vc有navigationController 且navigationBar是显示的
        if (vc.navigationController && !vc.navigationController.navigationBarHidden) {
            margin = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44;
        }
    }
    
    //3.return
    return margin;
}

-(CGFloat)getBottomMargin {
    //1.默认为0
    CGFloat margin = 0;
    
    UIResponder* nextResponder = self.superview.nextResponder;
    //2.如果superV的nextResponder是UIViewControler
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)nextResponder;
        //如果vc有tabBarController 且tabBar是显示的
        if (vc.tabBarController && !vc.tabBarController.tabBar.hidden) {
            margin = kTabBarH;
        }
    }
    
    //3.return
    return margin;
}

@end
