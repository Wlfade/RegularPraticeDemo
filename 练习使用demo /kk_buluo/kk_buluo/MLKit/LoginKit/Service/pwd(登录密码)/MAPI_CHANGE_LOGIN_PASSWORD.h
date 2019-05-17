//
//  MAPI_CHANGE_LOGIN_PASSWORD.h
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 修改登录密码 */
@interface MAPI_CHANGE_LOGIN_PASSWORD : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param pwd 新密码
 * @param oldPwd 老密码
 */
- (instancetype)initWithPwd:(NSString *)pwd oldPwd:(NSString *)oldPwd;

@end

NS_ASSUME_NONNULL_END
