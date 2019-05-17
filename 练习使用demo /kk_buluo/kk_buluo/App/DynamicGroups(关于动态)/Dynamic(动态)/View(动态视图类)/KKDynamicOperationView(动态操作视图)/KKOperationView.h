//
//  KKOperationView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/16.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKOperationView;

@protocol KKOperationViewDelegate <NSObject>

/** 动态转发 代理方法 */
- (void)KKOperationViewDidShare:(KKOperationView *)OperationView;

/** 动态评论 代理方法 */
- (void)KKOperationViewDidComment:(KKOperationView *)OperationView;

/** 动态点赞 代理方法 */
- (void)KKOperationViewDidLike:(KKOperationView *)OperationView withLiked:(BOOL)liked;

@end

@class KKDynamicOperationItem;
@interface KKOperationView : UIView
@property (nonatomic,strong)KKDynamicOperationItem *dyOperationItem;
@property (nonatomic,weak) id <KKOperationViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
