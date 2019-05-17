//
//  KKDyDeBottomOperationView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KKDyDeBottomOperationView,KKDynamicOperationItem;
@protocol KKDyDeBottomOperationViewDelegate <NSObject>
//写内容代理调用

- (void)KKDyDeBottomOperationWriteAction:(KKDyDeBottomOperationView *)inforView;

//评论代理调用
- (void)KKDyDeBottomOperationCommentAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem;
//点赞代理调用
- (void)KKDyDeBottomOperationLikeAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem;
//收藏代理调用
- (void)KKDyDeBottomOperationCollectAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem;
//转发代理调用
- (void)KKDyDeBottomOperationTransmitAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem;

@end

@interface KKDyDeBottomOperationView : UIView
@property (nonatomic,weak)id <KKDyDeBottomOperationViewDelegate> delegate;

@property (nonatomic,strong) KKDynamicOperationItem *OperationItem;
@end

NS_ASSUME_NONNULL_END
