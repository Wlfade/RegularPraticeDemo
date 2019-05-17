//
//  KKDydeLikeItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKDynamicHeadItem.h"
NS_ASSUME_NONNULL_BEGIN

@class KKDydeLikeItem,KKDynamicHeadItem;

@interface KKDydeLikeItem : NSObject
/* 动态头像昵称模型 */
@property (nonatomic,strong) KKDynamicHeadItem *dynamicHeadItem;

@property (nonatomic,assign) CGFloat dydeLikeHeight;

+ (instancetype)KKDydeLikeItemWithDictionary:(NSDictionary *)dict;

+ (CGFloat)cellHeight:(KKDydeLikeItem *)item;
@end

NS_ASSUME_NONNULL_END
