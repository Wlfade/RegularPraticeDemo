//
//  MAPI_REGISTER_VALIDATE_SMS_ACK.m
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_REGISTER_VALIDATE_SMS_ACK.h"

@interface MAPI_REGISTER_VALIDATE_SMS_ACK ()
/** 手机号 */
@property (nonatomic,copy) NSString *cell;
/** 验证码 */
@property (nonatomic,copy) NSString *checkCode;
/** 验证码短信的id */
@property (nonatomic,copy) NSString *smsId;
@end


@implementation MAPI_REGISTER_VALIDATE_SMS_ACK

- (instancetype)initWithCell:(NSString *)cell checkCode:(NSString *)checkCode smsId:(NSString *)smsId {
    
    self = [super init];
    if (self) {
        self.cell = cell;
        self.checkCode = checkCode;
        self.smsId = smsId;
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
    [params setObject:@"REGISTER_VALIDATE_SMS_ACK" forKey:@"service"];
    [params safeSetObject:self.cell forKey:@"cell"];
    [params safeSetObject:self.checkCode forKey:@"cellValidateCode"];
     [params safeSetObject:self.smsId forKey:@"smsId"];
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
            block(nil, resModel);
        }
        
        //mask
        if (mask) {
            [[CC_Mask getInstance] stop];
        }
    }];
}


@end
