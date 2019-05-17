//
//  LoginKitCellSmsServiceTool.h
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPI_LoginBase.h"

typedef NS_ENUM(NSUInteger, LoginKitCellSmsType) {
    LoginKitCellSmsTypeRegister = 0, //注册
    LoginKitCellSmsTypeLoginPwdReset, //找回登录密码
};

NS_ASSUME_NONNULL_BEGIN

/** 类: loginKit手机短信服务工具 */
@interface LoginKitCellSmsServiceTool : NSObject

/**
 * @brief 创建
 * @param type 类型
 * @param cell 手机号
 * @param extraParamDic 额外参数
 *
 * type=MLCellSmsTypeOldCellVerify时,cell没用到,可不传
 */
- (instancetype)initWithType:(LoginKitCellSmsType)type cell:(NSString *)cell extraParamDic:(nullable NSDictionary *)extraParamDic;

/**
 * @brief 请求发送验证码
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)sendSmsAtView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

/**
 * @brief 请求验证验证码
 * @param checkCode 验证码
 * @param smsId 验证码短信的id
 * @param verifyCellSign 加密的数据
 * @param randomStr 随机生成的字符串
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)verifySmsWithCheckCode:(NSString *)checkCode smsId:(NSString *)smsId verifyCellSign:(nullable NSString *)verifyCellSign randomStr:(nullable NSString *)randomStr atView:(nullable UIView *)view mask:(BOOL)mask  block:(nullable LoginKitBlock)block;
@end

NS_ASSUME_NONNULL_END
