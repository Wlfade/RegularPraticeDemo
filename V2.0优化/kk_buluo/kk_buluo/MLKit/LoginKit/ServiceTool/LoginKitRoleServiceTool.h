//
//  LoginKitRoleServiceTool.h
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPI_LoginBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginKitRoleServiceTool : NSObject

/**
 * @brief 创建
 * @param extraParamDic 额外参数
 */
- (instancetype)initWithExtraParamDic:(nullable NSDictionary *)extraParamDic;

/**
 * @brief 请求创建角色
 * @param loginName 登录名
 * @param asDefaultUser 是否作为默认角色
 * @param asCurrentUser 是否作为当前用户角色
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)roleCreateWithLoginName:(NSString *)loginName asDefaultUser:(BOOL)asDefaultUser asCurrentUser:(BOOL)asCurrentUser atView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

/**
 * @brief 请求角色列表
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)roleListAtView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

/**
 * @brief 请求创建角色
 * @param userId 登录的userId
 * @param asDefaultUser 是否作为默认角色
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)roleLoginWithUserId:(NSString *)userId asDefaultUser:(BOOL)asDefaultUser atView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

@end

NS_ASSUME_NONNULL_END
