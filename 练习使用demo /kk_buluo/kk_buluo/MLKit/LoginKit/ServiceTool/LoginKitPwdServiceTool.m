//
//  LoginKitPwdServiceTool.m
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "LoginKitPwdServiceTool.h"

#import "MAPI_REGISTER.h"
#import "MAPI_CHANGE_LOGIN_PASSWORD.h"
#import "MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY.h"
#import "MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD.h"

@interface LoginKitPwdServiceTool ()
/**
 * @brief 额外参数,会添加到http请求的params中
 *
 * 其key是后台定的字段, value是要设置的值
 */
@property (nonatomic,copy) NSDictionary *extraParamDic;
@end

@implementation LoginKitPwdServiceTool

- (instancetype)initWithExtraParamDic:(NSDictionary *)extraParamDic {
    self = [super init];
    if (self) {
        self.extraParamDic = extraParamDic;
    }
    return self;
}

-(void)registerWithCell:(NSString *)cell pwd:(NSString *)pwd loginName:(NSString *)loginName checkCode:(NSString *)checkCode verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    MAPI_REGISTER *reqObj = [[MAPI_REGISTER alloc]initWithCell:cell pwd:pwd loginName:loginName checkCode:checkCode verifyCellSign:verifyCellSign randomStr:randomStr];
    reqObj.extraParamDic = self.extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}

-(void)changePwd:(NSString *)pwd oldPwd:(NSString *)oldPwd atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    MAPI_CHANGE_LOGIN_PASSWORD *reqObj = [[MAPI_CHANGE_LOGIN_PASSWORD alloc]initWithPwd:pwd oldPwd:oldPwd];
    reqObj.extraParamDic = self.extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}

-(void)changePwdForOneAuth:(NSString *)pwd oldPwd:(NSString *)oldPwd atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY *reqObj = [[MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY alloc]initWithPwd:pwd oldPwd:oldPwd];
    reqObj.extraParamDic = self.extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}

-(void)changePwdByCell:(NSString *)cell pwd:(NSString *)pwd verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD *reqObj = [[MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD alloc]initWithCell:cell pwd:pwd verifyCellSign:verifyCellSign randomStr:randomStr];
    reqObj.extraParamDic = self.extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}

@end
