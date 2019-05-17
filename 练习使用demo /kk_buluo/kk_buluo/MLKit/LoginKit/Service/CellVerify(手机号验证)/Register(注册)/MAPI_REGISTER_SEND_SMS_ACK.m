//
//  MAPI_REGISTER_SEND_SMS_ACK.m
//  LoginKit
//
//  Created by david on 2019/2/20.
//  Copyright © 2019 david. All rights reserved.
//

#import "MAPI_REGISTER_SEND_SMS_ACK.h"

@interface MAPI_REGISTER_SEND_SMS_ACK ()
/** 手机号 */
@property (nonatomic,copy) NSString *cell;
@end


@implementation MAPI_REGISTER_SEND_SMS_ACK

- (instancetype)initWithCell:(NSString *)cell {
    self = [super init];
    if (self) {
        self.cell = cell;
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
    [params setObject:@"REGISTER_SEND_SMS_ACK" forKey:@"service"];
    [params safeSetObject:self.cell forKey:@"cell"];
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
            if ([error isEqualToString:@"手机号格式错误"]) {
                [CC_Notice showNoticeStr:@"请输入正确的手机号" atView:view];
            }else{
                [CC_Notice showNoticeStr:error atView:view];
            }
            
        }else {
            block(nil,resModel);
        }
        
        //mask
        if (mask) {
            [[CC_Mask getInstance] stop];
        }
    }];
}


@end
