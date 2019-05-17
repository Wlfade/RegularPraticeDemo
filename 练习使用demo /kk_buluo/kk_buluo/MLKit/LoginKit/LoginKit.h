//
//  LoginKit.h
//  LoginKit
//
//  Created by david on 2019/2/27.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC_Share.h"
#import "MAPI_LoginBase.h"


#define LOGIN_KIT_NOTIFICATION_NEED_UPDATE_USER_INFO @"loginKitNotificationNeedUpdateUserInfo"///需要更新userInfo
#define LOGIN_KIT_NOTIFICATION_SAVE_ONE_AUTH_PLATFORM_INFO @"loginKitNotificationSaveOneAuthPlatformInfo"///保存oneAuthPlatformInfo签名信息
#define LOGIN_KIT_NOTIFICATION_SAVE_USER_PLATFORM_INFO @"loginKitNotificationSaveUserPlatformInfo"///保存userPlatformInfo签名信息



NS_ASSUME_NONNULL_BEGIN

/**
 * LoginKitBlock
 *
 * modifiedDic 修改过的error字典
 *
 * resModel 后台返回数据处理后的对象
 */
typedef void(^LoginKitBlock)(NSDictionary * __nullable modifiedDic, ResModel * _Nonnull resModel);

@interface LoginKit : NSObject

/** 发请求用的httpTask */
@property (nonatomic,strong,nullable) CC_HttpTask *httpTask;

/** 发请求用的url */
@property (nonatomic,strong) NSURL *url;

/** 获取单例 */
+ (instancetype)getInstance;

/**
 * @brief 配置loginKit
 * @param httpTask 发请求的httpTask(已配置httpHeaders,签名等信息), 若httpTask为空则用[CC_HttpTask getInstence]单例发请求
 * @param url 发请求的url
 
 * 如果需要给httpTask注册通知方法,可在调用本方法前自行配置,如异地登录LoginElse需求
 *
 */
+ (void)configWithHttpTask:(nullable CC_HttpTask *)httpTask url:(nonnull NSURL *)url;

/** 释放单例 */
- (void)remove;


#pragma mark - login
/**
 * @brief 创建请求obj
 * @param cell 手机号
 * @param pwd 登录密码
 * @param useDefaultUser 是否用默认角色登录
 * @param extraParamDic 额外参数
 * @param block 完成请求回调block
 *
 * modifiedDic: 修改后的错误提示, 用于展示冻结提示信息,
 * 其内容: name:原始errorStr,
 *        forBidReason:拒绝原因提示str,
 *        gmtExpiredTime:冻结时间提示Str,
 */
- (void)loginWithCell:(NSString *)cell pwd:(NSString *)pwd useDefaultUser:(BOOL)useDefaultUser extraParamDic:(nullable NSDictionary *)extraParamDic atView:(nullable UIView *)view mask:(BOOL)mask  block:(nullable LoginKitBlock)block;

#pragma mark - user Identity
/**
 * @brief 创建请求obj
 * @param realName  姓名
 * @param certNo  身份证号
 * @param userId  用户角色id
 * @param extraParamDic 额外参数
 * @param block 完成请求回调block
 */
-(void)realName:(NSString *)realName certNo:(NSString *)certNo userId:(NSString *)userId extraParamDic:(nullable NSDictionary *)extraParamDic atView:(nullable UIView *)view mask:(BOOL)mask  block:(nullable LoginKitBlock)block;

@end

NS_ASSUME_NONNULL_END
