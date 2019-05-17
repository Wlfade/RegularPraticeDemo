//
//  KKMyWebAppsListCell.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/24.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyRecommendCell.h"
@class KKApplicationInfo;
NS_ASSUME_NONNULL_BEGIN

@interface KKMyWebAppsListCell : KKMyRecommendCell
@property (nonatomic, strong) KKApplicationInfo *appInfo;

@end

NS_ASSUME_NONNULL_END
