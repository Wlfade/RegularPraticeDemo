//
//  KKDyDetailAccessCountItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDyDetailAccessCountItem : NSObject
@property (nonatomic,assign) NSInteger accessCount; //浏览次数

/** 动态头像高度 */
@property (nonatomic,assign) CGFloat dynamicAccessHeight;
@end

NS_ASSUME_NONNULL_END
