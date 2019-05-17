//
//  LoginKitPwdServiceTool.h
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginKitPwdServiceTool : NSObject

/**
 * @brief 创建
 * @param extraParamDic 额外参数
 */
- (instancetype)initWithExtraParamDic:(nullable NSDictionary *)extraParamDic;

/**
 * @brief 请求注册
 * @param cell 手机号
 * @param pwd 密码(确认密码也用这个, 所以确认两次输入一致后,再调接口)
 * @param loginName 昵称
 * @param checkCode 验证码
 * @param verifyCellSign 加密的数据
 * @param randomStr 随机生成的字符串
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)registerWithCell:(NSString *)cell pwd:(NSString *)pwd loginName:(NSString *)loginName checkCode:(NSString *)checkCode verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr atView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;


/**
 * @brief 请求修改密码
 * @param pwd 新密码
 * @param oldPwd 老密码
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)changePwd:(NSString *)pwd oldPwd:(NSString *)oldPwd atView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

/**
 * @brief 请求修改密码
 * @param pwd 新密码
 * @param oldPwd 老密码
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)changePwdForOneAuth:(NSString *)pwd oldPwd:(NSString *)oldPwd atView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

/**
 * @brief 请求根据手机号修改密码
 * @param cell 手机号
 * @param pwd 新密码
 * @param verifyCellSign 加密的数据
 * @param randomStr 随机生成的字符串
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)changePwdByCell:(NSString *)cell pwd:(NSString *)pwd verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr atView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

@end

NS_ASSUME_NONNULL_END
