//
//  DGLabel.h
//  DGTool
//
//  Created by jczj on 2018/8/23.
//  Copyright © 2018年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGLabel : UILabel

/** 创建label
 *
 * 左对齐
 */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

/** 创建 制定text,font,color,isBold的label */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color bold:(BOOL)isBold;

#pragma mark - tap
/**
 * @brief 添加tap点击的block
 * @param timeInterval 下次点击需要间隔多久, 不小于0
 * @param tapBlock  点击的Block, 参数tag是此view的tag
 */
-(void)addTapWithTimeInterval:(float)timeInterval tapBlock:(void(^)(NSInteger tag))tapBlock;

@end
