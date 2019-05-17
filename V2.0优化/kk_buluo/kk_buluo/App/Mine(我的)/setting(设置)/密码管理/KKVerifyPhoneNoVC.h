//
//  KKVerifyPhoneNoVC.h
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, KKVerifyPhoneNoType) {
    KKVerifyPhoneNoTypeForPhoneNoReset=0,//重新设置手机号
    KKVerifyPhoneNoTypeForPwdReset,    //找回登录密码
    KKVerifyPhoneNoTypeForPayPwdReset  //找回支付密码
};

NS_ASSUME_NONNULL_BEGIN

@interface KKVerifyPhoneNoVC : BaseViewController

-(instancetype)initWithType:(KKVerifyPhoneNoType)type;

/** 手机号*/
@property (nonatomic, copy) NSString *phoneNoStr;

/** 随机字符串  用于重设手机号*/
@property(nonatomic,copy) NSString *randomStr;
/** cell验证签名 用于重设手机号*/
@property(nonatomic,copy) NSString *verifyCellSignStr;
@end

NS_ASSUME_NONNULL_END
