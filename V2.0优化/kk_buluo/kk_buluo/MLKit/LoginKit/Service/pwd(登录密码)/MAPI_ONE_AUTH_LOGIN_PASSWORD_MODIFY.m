//
//  MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY.m
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY.h"

@interface MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY ()
/** 新密码 */
@property (nonatomic,copy) NSString *pwd;
/** 老密码 */
@property (nonatomic,copy) NSString *oldPwd;
@end

@implementation MAPI_ONE_AUTH_LOGIN_PASSWORD_MODIFY

- (instancetype)initWithPwd:(NSString *)pwd oldPwd:(NSString *)oldPwd {
    self = [super init];
    if (self) {
        self.pwd = pwd;
        self.oldPwd = oldPwd;
    }
    return self;
}

/** 父类声明,子类实现 */
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
    [params setObject:@"ONE_AUTH_LOGIN_PASSWORD_MODIFY" forKey:@"service"];
    [params safeSetObject:self.pwd forKey:@"newLoginPassword"];
    [params safeSetObject:self.oldPwd forKey:@"oldLoginPassword"];
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
            [CC_Notice showNoticeStr:error atView:view];
        }else {
            //3.调block
            block(nil, resModel);
        }
        
        //mask
        if (mask) {
            [[CC_Mask getInstance] stop];
        }
    }];
}

@end
