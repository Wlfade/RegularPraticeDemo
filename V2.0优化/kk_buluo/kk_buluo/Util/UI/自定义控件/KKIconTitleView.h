//
//  KKIconTitleView.h
//  
//
//  Created by david on 2018/12/4.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKIconTitleView : UIView

-(instancetype)initWithImg:(UIImage *)img title:(NSString *)title;

//icon
@property (nonatomic,weak,readonly) UIImageView *iconImageView;
//宽高,只能设置一个, 另一个根据img等比缩放
@property (nonatomic, assign) CGFloat iconWidth;
@property (nonatomic, assign) CGFloat iconHeight;
//是否需要切成圆形 (以宽的一半为圆角)
@property (nonatomic,assign) BOOL needCircle;

//title
@property (nonatomic,assign) BOOL showFullTitle;
@property (nonatomic,weak,readonly) UILabel *titleLabel;

/**
 * @brief 添加tap点击的block
 * @param timeInterval 下次点击需要间隔多久, 不小于0
 * @param tapBlock  点击的Block, 参数tag是此view的tag
 */
-(void)addTapWithTimeInterval:(float)timeInterval tapBlock:(void(^)(NSInteger tag))tapBlock;

@end
