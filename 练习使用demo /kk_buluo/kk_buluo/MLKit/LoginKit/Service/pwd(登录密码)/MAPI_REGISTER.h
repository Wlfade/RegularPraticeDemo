//
//  MAPI_REGISTER.h
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 注册 */
@interface MAPI_REGISTER : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param cell 手机号
 * @param pwd 密码(确认密码也用这个, 所以确认两次输入一致后,再调接口)
 * @param loginName 昵称
 * @param checkCode 验证码
 * @param verifyCellSign 加密的数据
 * @param randomStr 随机生成的字符串
 */
- (instancetype)initWithCell:(NSString *)cell pwd:(NSString *)pwd loginName:(NSString *)loginName checkCode:(NSString *)checkCode verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr;

@end

NS_ASSUME_NONNULL_END
