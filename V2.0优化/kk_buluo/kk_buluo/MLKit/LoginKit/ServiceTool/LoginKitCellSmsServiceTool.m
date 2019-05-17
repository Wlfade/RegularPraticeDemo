//
//  LoginKitCellSmsServiceTool.m
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "LoginKitCellSmsServiceTool.h"
//register
#import "MAPI_REGISTER_SEND_SMS_ACK.h"
#import "MAPI_REGISTER_VALIDATE_SMS_ACK.h"
//找回登录密码
#import "MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SEND_SMS_ACK.h"
#import "MAPI_FIND_LOGIN_PASSWORD_BY_CELL_VALIDTE_SMS_ACK.h"


@interface LoginKitCellSmsServiceTool ()
/** 类型 */
@property (nonatomic,assign) LoginKitCellSmsType type;

/** 手机号 */
@property (nonatomic,copy) NSString *cell;

/**
 * @brief 额外参数,会添加到http请求的params中
 *
 * 其key是后台定的字段, value是要设置的值
 */
@property (nonatomic,copy) NSDictionary *extraParamDic;
@end


@implementation LoginKitCellSmsServiceTool

- (instancetype)initWithType:(LoginKitCellSmsType)type cell:(NSString *)cell extraParamDic:(NSDictionary *)extraParamDic {
    self = [super init];
    if (self) {
        self.type = type;
        self.cell = cell;
        self.extraParamDic = extraParamDic;
    }
    return self;
}


/** 请求发送验证码 */
- (void)sendSmsAtView:(UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block {
    
    NSString *cell = self.cell;
    MAPI_LoginBase *reqObj;
    
    //1.获取请求对象
    switch (self.type) {
        case LoginKitCellSmsTypeRegister:{
            reqObj = [[MAPI_REGISTER_SEND_SMS_ACK alloc]initWithCell:cell];
        } break;
        case LoginKitCellSmsTypeLoginPwdReset:{
            reqObj = [[MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SEND_SMS_ACK alloc]initWithCell:cell];
        } break;
        default:
            break;
    }
    
    //2.发请求
    reqObj.extraParamDic = self.extraParamDic;
    if (reqObj) {
        [reqObj requestAtView:view mask:mask block:block];
    }
}

/** 请求验证验证码 */
- (void)verifySmsWithCheckCode:(NSString *)checkCode smsId:(NSString *)smsId verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    NSString *cell = self.cell;
    MAPI_LoginBase *reqObj;
    
    //1.获取请求对象
    switch (self.type) {
        case LoginKitCellSmsTypeRegister:{
            reqObj = [[MAPI_REGISTER_VALIDATE_SMS_ACK alloc]initWithCell:cell checkCode:checkCode smsId:smsId];
        } break;
        case LoginKitCellSmsTypeLoginPwdReset:{
            reqObj = [[MAPI_FIND_LOGIN_PASSWORD_BY_CELL_VALIDTE_SMS_ACK alloc]initWithCell:cell checkCode:checkCode smsId:smsId];
        } break;
        default:
            break;
    }
    
    //2.发请求
    reqObj.extraParamDic = self.extraParamDic;
    if (reqObj) {
        [reqObj requestAtView:view mask:mask block:block];
    }
    
}


@end
