//
//  MAPI_USER_IDENTITY_COMPLETE.h
//  LoginKit
//
//  Created by david on 2019/4/30.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN
/** 类: 实名认证 */
@interface MAPI_USER_IDENTITY_COMPLETE : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param realName  姓名
 * @param certNo  身份证号
 * @param authedUserId  用户角色id
 */
- (instancetype)initWithRealName:(NSString *)realName certNo:(NSString *)certNo authedUserId:(NSString *)authedUserId;

@end

NS_ASSUME_NONNULL_END
