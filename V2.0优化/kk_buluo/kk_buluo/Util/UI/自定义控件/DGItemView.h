//
//  DGItemView.h
//  
//
//  Created by david on 2018/11/21.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DGItemViewIndicatorStyle) {
    DGItemViewIndicatorStyleLine, //default
    DGItemViewIndicatorStyleLayer
};

@class DGItemView;
@protocol DGItemViewDelegate <NSObject>
/**
 点击button让delegate调用代理方法
 
 @param itemView 触发代理方法的itemView
 @param index    当前点击item的index
 @return 此次点击是否有效
 */
-(BOOL)itemView:(DGItemView *)itemView didSelectedAtIndex:(NSUInteger)index;
@end

#pragma mark -
@interface DGItemView : UIView

@property (nonatomic,weak) id<DGItemViewDelegate> delegate;

/** itemStr数组, 赋值是,开始添加item控件
 * 最好在其他属性赋值之后在对titleArr赋值
 */
@property (nonatomic, copy) NSArray *titleArr;

/** 选中index
 * 在titleArr属性前赋值: 为默认选中index; 若超出titleArr的最大下标,及没有默认选中
 * 在titleArr属性后赋值: 会触发代理方法; 若超出titleArr的最大下标此次赋值无效
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

/** 是否需要等宽
 * 需要在titleArr属性前赋值, 默认为YES
 */
@property (nonatomic,assign) BOOL needEqualWidth;

/** 改变指定index对应的title */
-(void)changeTitle:(NSString *)title atIndex:(NSUInteger)index;

/** 获取指定index对应的itemButton */
-(UIButton *)itemButtonAtIndex:(NSUInteger)index;

#pragma mark - indicator
/** indicatorStyle */
@property (nonatomic, assign) DGItemViewIndicatorStyle indicatorStyle;

/** 是否显示indicatorView */
@property (nonatomic, assign) BOOL indicatorViewHidden;

/** indicator颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;

/** indicator图片 */
@property (nonatomic, strong) UIImage *indicatorImage;

/** 缩放比例
 * DGItemViewIndicatorStyleLine: 总是有效 0~1
 * DGItemViewIndicatorStyleLayer: 在needEqualWidth=YES时才有效,且>=0.4
 */
@property (nonatomic,assign) CGFloat indicatorScale;

/** lineIndicator的高度,默认为2.0, 范围0~itemView高度的一半 */
@property (nonatomic,assign) CGFloat lineIndicatorHeight;

/** layerIndicator的高度scale, 默认为0.7, 范围0.4~1.0 */
@property (nonatomic,assign) CGFloat layerIndicatorHeightScale;


#pragma mark - btn
/** 普通状态font */
@property (nonatomic, assign) UIFont *normalFont;
/** 选中状态font */
@property (nonatomic, assign) UIFont *selectedFont;
/** 普通状态 颜色 */
@property (nonatomic, strong) UIColor *normalColor;
/** 选中状态 颜色 */
@property (nonatomic, strong) UIColor *selectedColor;


#pragma mark - animation
/** 动画时间,默认0.25, 范围:0.05~3.0 */
@property (nonatomic,assign) CGFloat duration;

@end
