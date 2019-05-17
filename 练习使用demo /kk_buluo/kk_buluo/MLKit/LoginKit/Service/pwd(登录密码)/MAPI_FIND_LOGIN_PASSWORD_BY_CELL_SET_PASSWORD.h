//
//  MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD.h
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 重置登录密码 */
@interface MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param cell 手机号
 * @param pwd 新密码
 * @param verifyCellSign 加密的数据
 * @param randomStr 随机生成的字符串
 */
- (instancetype)initWithCell:(NSString *)cell pwd:(NSString *)pwd verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr;


@end

NS_ASSUME_NONNULL_END
