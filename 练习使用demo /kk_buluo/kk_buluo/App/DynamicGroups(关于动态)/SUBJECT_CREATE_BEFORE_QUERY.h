//
//  SUBJECT_CREATE_BEFORE_QUERY.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class KKSubjectLengthConfig;

@interface SUBJECT_CREATE_BEFORE_QUERY : NSObject
+ (void)requestSubjectComplete:(void(^)(KKSubjectLengthConfig *))complete;
@end

NS_ASSUME_NONNULL_END
