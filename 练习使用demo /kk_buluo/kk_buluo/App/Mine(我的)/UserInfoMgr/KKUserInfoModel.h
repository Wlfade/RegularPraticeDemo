//
//  KKUserInfoModel.h
//  kk_buluo
//
//  Created by david on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKNameMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKUserInfoModel : NSObject

//---------------------外层字典--------------------
/** 用户简介 */
@property (nonatomic, copy) NSString *userMemo;

/** 用户头像 */
@property (nonatomic,copy) NSString *userLogoUrl;

/** 所在地区 */
@property (nonatomic, copy) NSString *location;

/** 是否完成实名和身份证验证 */
@property (nonatomic,assign) BOOL validateIdentity;//不用他判断,用certNo


//-----------------userInfoClient字典---------------
#pragma mark - 
/** 用户Id */
@property (nonatomic,copy) NSString *userId;

/** 登陆名 */
@property (nonatomic,copy) NSString *loginName;

/** 昵称 */
@property (nonatomic, copy) NSString *nickName;

/** 真实姓名 */
@property (nonatomic,copy) NSString *realName;

/** 手机号 */
@property (nonatomic,copy) NSString *cell;

/** 生日 */
@property (nonatomic, copy) NSString *birthday;

/**
 证件类型
 
 DENTITY_CARD => 身份证
 PASSPORT => 护照
 OFFICER_CARD => 军官证
 SOLDIER_CARD => 士兵证
 BACK_HOMETOWN_CARD => 回乡证
 TEMP_INDENTITY_CARD => 临时身份证
 HOKOU => 户口簿
 POLICE_CARD => 警官证
 TAIWAN_CARD => 台胞证
 BUSINESS_LICENSE => 营业执照
 TW_HK_MC_LICENSE => 港澳台居民大陆通行证
 OTHERS => 其他证件
 */
@property (nonatomic, strong) KKNameMsgModel *certType;

/** 证件号码 */
@property (nonatomic,copy) NSString *certNo;

/**
 性别
 
 M => 男
 F => 女
 U => 未知
 */
@property (nonatomic, strong) KKNameMsgModel *sex;

/** 电子邮件 */
@property (nonatomic, copy) NSString *email;

/** 默认账户号 */
@property (nonatomic, copy) NSString *defaultAccountNo;

/** 是否可登陆 */
@property (nonatomic,assign) BOOL canLogin;

/** 登陆密码 是否已设置 */
@property (nonatomic,assign) BOOL loginPasswordSet;

/** 账户密码 是否已设置 */
@property (nonatomic,assign) BOOL accountPasswordSet;

/** 手机是否验证,true表示已验证 */
@property (nonatomic,assign) BOOL cellValidate;

/** 电子邮件是否验证 */
@property (nonatomic,assign) BOOL emailValidate;

/** QQ是否验证 */
@property (nonatomic,assign) BOOL qqValidate;

/** 注册来源类型 */
@property (nonatomic, copy) NSString *registerFromTypeCode;

/** 注册来源的会员ID */
@property (nonatomic, copy) NSString *registerFromUserId;

@end

NS_ASSUME_NONNULL_END
