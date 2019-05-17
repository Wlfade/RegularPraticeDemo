//
//  KKPwdSetVC.h
//  kk_buluo
//
//  Created by david on 2018/7/16.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSUInteger, KKPwdSetType) {
    KKPwdSetTypeForPwd = 0,           //登录密码 重设(找回)
    KKPwdSetTypeForPayPwd,        //支付密码 设置
    KKPwdSetTypeForPayPwdReset,   //支付密码 重设(找回)
};


/** 带有两个textField,设置密码VC */
@interface KKPwdSetVC : BaseViewController

-(instancetype)initWithType:(KKPwdSetType)type;

/** 短信验证码 */
@property(nonatomic,copy) NSString *smsStr;
/** 短信验证码id */
@property(nonatomic,copy) NSString *smsIdString;
/** 随机字符串(发送验证码后 后台给的) */
@property(nonatomic,copy) NSString *randomString;
/** cell验证签名 */
@property(nonatomic,copy) NSString *verifyCellSign;
/** 手机号 */
@property(nonatomic,copy) NSString *cell;

/** 是否是来自注册 */
@property (nonatomic,assign) BOOL isFromRegister;
/** 是否 需要跳转kk进行绑定 */
@property (nonatomic,assign) BOOL needJumpKK;

@end
