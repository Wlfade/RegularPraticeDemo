//
//  MAPI_SELECT_USER_AUTH_LOGIN.m
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_SELECT_USER_AUTH_LOGIN.h"

@interface MAPI_SELECT_USER_AUTH_LOGIN ()
/** 登录名 */
@property (nonatomic,copy) NSString *userId;
/** 是否设为默认用户 */
@property (nonatomic,assign) BOOL asDefaultUser;
@end


@implementation MAPI_SELECT_USER_AUTH_LOGIN
- (instancetype)initWithUserId:(NSString *)userId asDefaultUser:(BOOL)asDefaultUser{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.asDefaultUser = asDefaultUser;
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
    [params setObject:@"SELECT_USER_AUTH_LOGIN" forKey:@"service"];
    [params safeSetObject:self.userId forKey:@"selectedLoginUserId"];
    [params safeSetObject:@(self.asDefaultUser) forKey:@"resetDefaultUser"];
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
            //3.请求成功
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            if ([responseDic[@"success"] boolValue]) {
                
                //发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_KIT_NOTIFICATION_SAVE_USER_PLATFORM_INFO object:responseDic[@"userPlatformLogin"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_KIT_NOTIFICATION_NEED_UPDATE_USER_INFO object:nil];
            }
            
            //4.调block
            block(nil, resModel);
        }
        
        //mask
        if (mask) {
            [[CC_Mask getInstance] stop];
        }
    }];
}

@end
