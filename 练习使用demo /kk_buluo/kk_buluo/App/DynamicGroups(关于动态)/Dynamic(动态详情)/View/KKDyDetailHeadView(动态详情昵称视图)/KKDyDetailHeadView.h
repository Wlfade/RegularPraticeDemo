//
//  KKDyDetailHeadView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@class KKDynamicHeadItem,KKDyDetailHeadView;

@protocol KKDyDetailHeadViewDelegate <NSObject>


/**
 关注按钮点击的代理方法

 @param detailHeadView 头部视图
 @param dyHeadItem 数据模型
 @param focus 是否关注
 */
- (void)KKDyDetailHeadViewDidFocus:(KKDyDetailHeadView *)detailHeadView
                    withDyHeadItem:(KKDynamicHeadItem *)dyHeadItem
                         withFocus:(BOOL)focus;

@end

@interface KKDyDetailHeadView : UIView
@property (nonatomic,strong) KKDynamicHeadItem *dyHeadItem;

@property (nonatomic,weak) id <KKDyDetailHeadViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
