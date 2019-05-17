//
//  MAPI_ONE_AUTH_LOGIN.h
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 手机号登录 */
@interface MAPI_ONE_AUTH_LOGIN : MAPI_LoginBase
/**
 * @brief 创建请求obj
 * @param cell 手机号
 * @param loginPwd 登录密码
 * @param selectedDefaultUserToLogin 是否选择默认角色登录
 */
- (instancetype)initWithCell:(NSString *)cell loginPwd:(NSString *)loginPwd selectedDefaultUserToLogin:(BOOL)selectedDefaultUserToLogin;


@end

NS_ASSUME_NONNULL_END
