//
//  KKRecomViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"

@class KKRecomViewController;

@protocol KKRecomViewControllerDelegate <NSObject>

//刷新关注用户列表，判断是否已经点击了关注用户了然后 让父控制器重新请求数据
- (void)KKRecomViewController:(KKRecomViewController *)viewController isFocusUser:(BOOL)foucus;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KKRecomViewController : BaseViewController

@property (nonatomic,weak)id <KKRecomViewControllerDelegate> delegate;

@property(nonatomic,assign)CGFloat viewFrameH;

- (void)reFreshRecommendUser;
@end

NS_ASSUME_NONNULL_END
