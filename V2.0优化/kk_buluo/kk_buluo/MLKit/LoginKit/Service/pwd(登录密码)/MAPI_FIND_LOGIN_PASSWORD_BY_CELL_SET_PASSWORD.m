//
//  MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD.m
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD.h"


@interface MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD ()
/** 手机号 */
@property (nonatomic,copy) NSString *cell;
/** 新密码 */
@property (nonatomic,copy) NSString *pwd;
/** 加密的数据 */
@property (nonatomic,copy) NSString *verifyCellSign;
/** 随机生成的字符串 */
@property (nonatomic,copy) NSString *randomStr;
@end

@implementation MAPI_FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD

- (instancetype)initWithCell:(NSString *)cell pwd:(NSString *)pwd verifyCellSign:(NSString *)verifyCellSign randomStr:(NSString *)randomStr {
    
    self = [super init];
    if (self) {
        self.cell = cell;
        self.pwd = pwd;
        self.verifyCellSign = verifyCellSign;
        self.randomStr = randomStr;
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
    [params setObject:@"FIND_LOGIN_PASSWORD_BY_CELL_SET_PASSWORD" forKey:@"service"];
    [params safeSetObject:self.cell forKey:@"cell"];
    [params safeSetObject:self.pwd forKey:@"newPassword"];
    [params safeSetObject:self.verifyCellSign forKey:@"verifyCellSign"];
    [params safeSetObject:self.randomStr forKey:@"randomString"];
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
