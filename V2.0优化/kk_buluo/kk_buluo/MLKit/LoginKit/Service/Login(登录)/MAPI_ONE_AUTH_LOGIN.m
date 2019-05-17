//
//  MAPI_ONE_AUTH_LOGIN.m
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_ONE_AUTH_LOGIN.h"

@interface MAPI_ONE_AUTH_LOGIN()
/** 手机号 */
@property (nonatomic,copy) NSString *cell;
/** 登录密码 */
@property (nonatomic,copy) NSString *loginPwd;
/** 使用默认角色登录 */
@property (nonatomic,assign) BOOL selectedDefaultUserToLogin;

@end


@implementation MAPI_ONE_AUTH_LOGIN

- (instancetype)initWithCell:(NSString *)cell loginPwd:(NSString *)loginPwd selectedDefaultUserToLogin:(BOOL)selectedDefaultUserToLogin {
    
    self = [super init];
    if (self) {
        self.cell = cell;
        self.loginPwd = loginPwd;
        self.selectedDefaultUserToLogin = selectedDefaultUserToLogin;
    }
    return self;
}

/** 父类声明,子类实现
 * modifiedDic: 修改后的错误提示, 用于展示冻结提示信息,
 * 其内容: name:原始errorStr,
 *        forBidReason:拒绝原因提示str,
 *        gmtExpiredTime:冻结时间提示Str,
 */
- (void)requestAtView:(UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block {
    
    //mask
    if (mask) {
        UIView *showV;
        if (view) {
            showV=view;
        }else{
            showV=[CC_Code getAView];
        }
        [[CC_Mask getInstance]startAtView:showV];
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ONE_AUTH_LOGIN" forKey:@"service"];
    [params safeSetObject:self.cell forKey:@"cell"];
    [params safeSetObject:self.loginPwd forKey:@"loginPassword"];
    [params safeSetObject:@(self.selectedDefaultUserToLogin) forKey:@"selectedDefaultUserToLogin"];
    //额外参数
    for (NSString *key in self.extraParamDic) {
        [params safeSetObject:self.extraParamDic[key] forKey:key];
    }
    
    //2.请求
    CC_HttpTask *httpTask = [LoginKit getInstance].httpTask;
    if (!httpTask) {
        httpTask = [CC_HttpTask getInstance];
    }
    [httpTask post:[LoginKit getInstance].url params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        if (error) {
            [self handleError:error model:resModel atView:view block:block];
        }else {
            //3.请求成功
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            if ([responseDic[@"success"] boolValue]) {
                
                //发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_KIT_NOTIFICATION_SAVE_ONE_AUTH_PLATFORM_INFO object:responseDic[@"oneAuthPlatformLogin"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_KIT_NOTIFICATION_SAVE_USER_PLATFORM_INFO object:responseDic[@"userPlatformLogin"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_KIT_NOTIFICATION_NEED_UPDATE_USER_INFO object:nil];
            }
            
            //4.block
            block(nil,resModel);
        }
        //mask
        if (mask) {
            [[CC_Mask getInstance] stop];
        }
    }];
}


/** 错误处理 */
- (void)handleError:(NSString *)error model:(ResModel *)resmodel atView:(UIView *)view block:(void (^)(NSDictionary *, ResModel *))block{
    
    if ([error isEqualToString:@"登录密码错误"]) {
        [CC_Notice showNoticeStr:@"账号或密码有误" atView:view];
        return ;
    }
    
    if([error isEqualToString:@"重试次数太多，拒绝认证"]) {
        [CC_Notice showNoticeStr:resmodel.resultDic[@"response"][@"detailMessage"] atView:view];
        return ;
    }
    
    if ([resmodel.resultDic[@"response"][@"error"][@"name"] isEqualToString:@"LOGIN_FORBIDDEN"]) {
        NSDictionary *responseDic = [resmodel.resultDic objectForKey:@"response"];
        NSString *forBidReasonStr = [NSString stringWithFormat:@"冻结理由：%@",[responseDic[@"resultMap"] objectForKey:@"forbiddenReason"]];
        NSString *gmtExpiredTimeStr = [NSString stringWithFormat:@"解冻时间：%@",[responseDic[@"resultMap"] objectForKey:@"gmtEnd"]];
        
        NSDictionary *errorDic=@{@"name":error,@"forBidReason":forBidReasonStr,@"gmtExpiredTime":gmtExpiredTimeStr};
        block(errorDic,resmodel);
        
        return;
    }
    
    
    [CC_Notice showNoticeStr:error atView:view delay:2];
}

@end
