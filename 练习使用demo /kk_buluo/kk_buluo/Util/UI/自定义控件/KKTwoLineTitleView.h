//
//  KKTwoLineTitleView.h
//  kk_buluo
//
//  Created by david on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKTwoLineTitleView : UIView
@property (nonatomic,weak,readonly) UILabel *titleLabel;
@property (nonatomic,weak,readonly) UILabel *detailLabel;

/**
 * @brief 添加tap点击的block
 * @param timeInterval 下次点击需要间隔多久, 不小于0
 * @param tapBlock  点击的Block, 参数tag是此view的tag
 */
-(void)addTapWithTimeInterval:(float)timeInterval tapBlock:(void(^)(NSInteger tag))tapBlock;

@end

NS_ASSUME_NONNULL_END
