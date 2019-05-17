//
//  MAPI_USER_CREATE.h
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 创建角色 */
@interface MAPI_USER_CREATE : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param loginName 登录名
 * @param asDefaultUser 是否作为默认角色
 * @param asCurrentUser 是否作为当前用户角色
 */
- (instancetype)initWithLoginName:(NSString *)loginName asDefaultUser:(BOOL)asDefaultUser asCurrentUser:(BOOL)asCurrentUser;

@end

NS_ASSUME_NONNULL_END
