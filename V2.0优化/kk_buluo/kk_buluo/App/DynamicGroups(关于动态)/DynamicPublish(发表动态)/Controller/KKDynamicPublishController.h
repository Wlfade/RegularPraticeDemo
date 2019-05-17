//
//  KKDynamicPublishController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^PublishedBlock)(void);

@interface KKDynamicPublishController : BaseViewController

/** 发表成功后的回调block */
@property(nonatomic,strong) PublishedBlock block;

@end

NS_ASSUME_NONNULL_END
