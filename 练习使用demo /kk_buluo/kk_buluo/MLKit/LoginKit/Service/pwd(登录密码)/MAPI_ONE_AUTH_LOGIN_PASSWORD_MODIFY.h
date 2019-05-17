//
//  MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY.h
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 修改oneAuth登录密码 */
@interface MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param pwd 新密码
 * @param oldPwd 老密码
 */
- (instancetype)initWithPwd:(NSString *)pwd oldPwd:(NSString *)oldPwd;

@end

NS_ASSUME_NONNULL_END
