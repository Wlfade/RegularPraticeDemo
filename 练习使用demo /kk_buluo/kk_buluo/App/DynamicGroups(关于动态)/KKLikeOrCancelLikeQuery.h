//
//  KKLikeOrCancelLikeQuery.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/28.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLikeOrCancelLikeQuery : NSObject
+ (void)requestIsClickLike:(BOOL)liked withLikeCount:(NSInteger)likeCount withObjectId:(NSString *)objectId withType:(NSString *)typeStr withFinish:(void(^)(BOOL,NSInteger))complete;
@end

NS_ASSUME_NONNULL_END
