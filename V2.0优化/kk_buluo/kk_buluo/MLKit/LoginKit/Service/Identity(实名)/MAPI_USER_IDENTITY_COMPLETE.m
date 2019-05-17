//
//  MAPI_USER_IDENTITY_COMPLETE.m
//  LoginKit
//
//  Created by david on 2019/4/30.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_USER_IDENTITY_COMPLETE.h"

@interface MAPI_USER_IDENTITY_COMPLETE ()
/** 手机号 */
@property (nonatomic,copy) NSString *realName;
/** 登录密码 */
@property (nonatomic,copy) NSString *certNo;
/** 登录密码 */
@property (nonatomic,copy) NSString *authedUserId;

@end

@implementation MAPI_USER_IDENTITY_COMPLETE

/**
 * @brief 创建请求obj
 * @param realName  姓名
 * @param certNo  身份证号
 * @param authedUserId  用户角色id
 */
- (instancetype)initWithRealName:(NSString *)realName certNo:(NSString *)certNo authedUserId:(NSString *)authedUserId {
    self = [super init];
    if (self) {
        self.realName = realName;
        self.certNo = certNo;
        self.authedUserId = authedUserId;
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
    [params setObject:@"USER_IDENTITY_COMPLETE" forKey:@"service"];
    [params safeSetObject:self.realName forKey:@"realName"];
    [params safeSetObject:self.certNo forKey:@"certNo"];
    [params safeSetObject:self.authedUserId forKey:@"authedUserId"];
    
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
