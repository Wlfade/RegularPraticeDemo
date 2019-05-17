//
//  KKDyHeadView.h
//  KKTribe
//
//  Created by 单车 on 2018/7/14.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKDyHeadView,KKDynamicHeadItem;
@protocol KKDyHeadViewDelegate <NSObject>;
//更多按钮点击
- (void)KKDyHeadView:(KKDyHeadView *)dyHeadView didClickFunction:(UIButton *)sender;
//关注按钮点击
- (void)KKDyHeadView:(KKDyHeadView *)dyHeadView didClickFocus:(KKDynamicHeadItem *)dyHeadItem;
@end

@interface KKDyHeadView : UIView
@property (nonatomic,strong) KKDynamicHeadItem *dyHeadItem;

@property (nonatomic,weak)id <KKDyHeadViewDelegate> delegate;

@end
