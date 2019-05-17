//
//  KKNetworkConfig.h
//  kk_buluo
//
//  Created by david on 2019/3/16.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kNetConfig_id        @"id"//与后台约定的
#define kNetConfig_loginKey  @"loginKey"
#define kNetConfig_signKey   @"signKey"
#define kNetConfig_cryptKey  @"cryptKey"

NS_ASSUME_NONNULL_BEGIN

@interface KKNetworkConfig : NSObject

#pragma mark - life circle
+(instancetype)shareInstance;
- (void)removeHttpTaskConfig;

#pragma mark - 签名
#pragma mark oneAuth
/** 保存用户的oneAuth签名信息
 *
 * dic的key 分别是id,loginKey,signKey,cryptKey
 */
-(void)saveOneAuthInfo:(NSDictionary *)dic;
@property (nonatomic,copy,nullable) NSString *oneAuth_id;
@property (nonatomic,copy,nullable) NSString *oneAuth_loginKey;
@property (nonatomic,copy,nullable) NSString *oneAuth_signKey;
@property (nonatomic,copy,nullable) NSString *oneAuth_cryptKey;

#pragma mark user
/** 保存用户的user(角色)签名信息
 *
 * dic的key 分别是id,loginKey,signKey,cryptKey
 */
-(void)saveUserInfo:(NSDictionary *)dic;
@property (nonatomic,copy,nullable) NSString *user_id;
@property (nonatomic,copy,nullable) NSString *user_loginKey;
@property (nonatomic,copy,nullable) NSString *user_signKey;
@property (nonatomic,copy,nullable) NSString *user_cryptKey;


#pragma mark - 配置网络
+(void)configNetWork;

/** 获取 当前请求地址 */
+(NSURL *)currentUrl;

#pragma mark - 域名
@property (nonatomic,copy)NSString *domainStr;
@property (nonatomic,copy)NSString *ftWebDomainStr;
@property (nonatomic,copy)NSString *btWebDomainStr;
@property (nonatomic,copy)NSString *ftApiDomainStr;
@property (nonatomic,copy)NSString *btApiDomainStr;

#pragma mark - tool
/**
 @return app的名字
 */
+(NSString *)appName;



@end

NS_ASSUME_NONNULL_END
