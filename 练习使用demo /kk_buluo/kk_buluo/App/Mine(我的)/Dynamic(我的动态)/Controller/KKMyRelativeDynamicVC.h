//
//  KKMyRelativeDynamicVC.h
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KKMyDynamicType) {
    KKMyDynamicTypeCreate = 0,//发布
    KKMyDynamicTypeTransmit,//转发
    KKMyDynamicTypeLike,//点赞
    KKMyDynamicTypeCollect,//收藏
};

@interface KKMyRelativeDynamicVC : BaseViewController
-(instancetype)initWithType:(KKMyDynamicType)type;
@end

NS_ASSUME_NONNULL_END
