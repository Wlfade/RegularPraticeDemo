//
//  COMMENT_CREATE_BEFORE_QUERY.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/1.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface COMMENT_CREATE_BEFORE_QUERY : NSObject
+ (void)requestCommentCountComplete:(void(^)(NSInteger ))complete;
@end

NS_ASSUME_NONNULL_END
