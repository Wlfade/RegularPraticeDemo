//
//  MAPI_USER_CREATE.m
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_USER_CREATE.h"

@interface MAPI_USER_CREATE ()
/** 登录名 */
@property (nonatomic,copy) NSString *loginName;
/** 是否设为默认用户 */
@property (nonatomic,assign) BOOL asDefaultUser;
/** 是否作为当前用户, 会更改当前的用户信息*/
@property (nonatomic,assign) BOOL asCurrentUser;
@end


@implementation MAPI_USER_CREATE

- (instancetype)initWithLoginName:(NSString *)loginName asDefaultUser:(BOOL)asDefaultUser asCurrentUser:(BOOL)asCurrentUser;{
    self = [super init];
    if (self) {
        self.loginName = loginName;
        self.asDefaultUser = asDefaultUser;
        self.asCurrentUser = asCurrentUser;
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
    [params setObject:@"USER_CREATE" forKey:@"service"];
    [params safeSetObject:self.loginName forKey:@"loginName"];
    [params safeSetObject:@(self.asDefaultUser) forKey:@"defaultLoginUser"];
    //额外参数
    for (NSString *key in self.extraParamDic) {
        [params safeSetObject:self.extraParamDic[key] forKey:key];
    }
    
    //2.请求
    __weak typeof(self) weakSelf = self;
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
                if (weakSelf.asCurrentUser) {
                    //发通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_KIT_NOTIFICATION_SAVE_USER_PLATFORM_INFO object:responseDic[@"userPlatformLogin"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_KIT_NOTIFICATION_NEED_UPDATE_USER_INFO object:nil];
                }
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
