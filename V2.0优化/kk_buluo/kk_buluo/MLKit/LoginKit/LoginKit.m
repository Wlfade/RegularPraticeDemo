//
//  LoginKit.m
//  LoginKit
//
//  Created by david on 2019/2/27.
//  Copyright © 2019 david. All rights reserved.
//

#import "LoginKit.h"
#import "MAPI_ONE_AUTH_LOGIN.h"
#import "MAPI_USER_IDENTITY_COMPLETE.h"

@implementation LoginKit

static LoginKit *_loginKit = nil;
static dispatch_once_t onceToken;

+ (instancetype)getInstance{
    dispatch_once(&onceToken, ^{
        _loginKit = [[LoginKit alloc]init];
    });
    return _loginKit;
}

+ (void)configWithHttpTask:(CC_HttpTask *)httpTask url:(NSURL *)url {
    
    //1.设置请求头
    [LoginKit getInstance].httpTask = httpTask;
    
    //2.配置url
    [LoginKit getInstance].url = url;
}

/** 释放 */
- (void)remove{
    _loginKit = nil;
    onceToken = 0;
}


#pragma mark- login

-(void)loginWithCell:(NSString *)cell pwd:(NSString *)pwd useDefaultUser:(BOOL)useDefaultUser extraParamDic:(NSDictionary *)extraParamDic atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    MAPI_ONE_AUTH_LOGIN *reqObj = [[MAPI_ONE_AUTH_LOGIN alloc]initWithCell:cell loginPwd:pwd selectedDefaultUserToLogin:useDefaultUser];
    reqObj.extraParamDic = extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}


#pragma mark - user Identity

-(void)realName:(NSString *)realName certNo:(NSString *)certNo userId:(NSString *)userId extraParamDic:(NSDictionary *)extraParamDic atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    MAPI_USER_IDENTITY_COMPLETE *reqObj = [[MAPI_USER_IDENTITY_COMPLETE alloc]initWithRealName:realName certNo:certNo authedUserId:userId];
    reqObj.extraParamDic = extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}

@end
