//
//  MAPI_REGISTER_SEND_SMS_ACK.h
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

/** 类: 注册时 获取短信验证码 */
@interface MAPI_REGISTER_SEND_SMS_ACK : MAPI_LoginBase

/**
 * @brief 创建请求obj
 * @param cell 手机号
 */
- (instancetype)initWithCell:(NSString *)cell;


@end

NS_ASSUME_NONNULL_END
