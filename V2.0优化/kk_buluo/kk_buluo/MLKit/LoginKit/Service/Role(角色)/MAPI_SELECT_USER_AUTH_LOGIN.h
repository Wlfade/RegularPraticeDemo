//
//  MAPI_SELECT_USER_AUTH_LOGIN.h
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 选择角色授权登录 */
@interface MAPI_SELECT_USER_AUTH_LOGIN : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param userId 选择登录的userId
 * @param asDefaultUser 是否作为默认角色
 */
- (instancetype)initWithUserId:(NSString *)userId asDefaultUser:(BOOL)asDefaultUser;

@end

NS_ASSUME_NONNULL_END
