//
//  LoginKitRoleServiceTool.m
//  LoginKit
//
//  Created by david on 2019/3/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "LoginKitRoleServiceTool.h"

#import "MAPI_USER_CREATE.h"
#import "MAPI_USER_LIST_QUERY.h"
#import "MAPI_SELECT_USER_AUTH_LOGIN.h"


@interface LoginKitRoleServiceTool ()
/**
 * @brief 额外参数,会添加到http请求的params中
 *
 * 其key是后台定的字段, value是要设置的值
 */
@property (nonatomic,copy) NSDictionary *extraParamDic;
@end

@implementation LoginKitRoleServiceTool

- (instancetype)initWithExtraParamDic:(nullable NSDictionary *)extraParamDic {
    self = [super init];
    if (self) {
        self.extraParamDic = extraParamDic;
    }
    return self;
}

-(void)roleCreateWithLoginName:(NSString *)loginName asDefaultUser:(BOOL)asDefaultUser asCurrentUser:(BOOL)asCurrentUser atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    MAPI_USER_CREATE *reqObj = [[MAPI_USER_CREATE alloc]initWithLoginName:loginName asDefaultUser:asDefaultUser asCurrentUser:asCurrentUser];
    reqObj.extraParamDic = self.extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}

- (void)roleListAtView:(UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block {
    
    MAPI_USER_LIST_QUERY *reqObj = [[MAPI_USER_LIST_QUERY alloc]init];
    reqObj.extraParamDic = self.extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}

-(void)roleLoginWithUserId:(NSString *)userId asDefaultUser:(BOOL)asDefaultUser atView:(UIView *)view mask:(BOOL)mask block:(LoginKitBlock)block {
    
    MAPI_SELECT_USER_AUTH_LOGIN *reqObj = [[MAPI_SELECT_USER_AUTH_LOGIN alloc]initWithUserId:userId asDefaultUser:asDefaultUser];
    reqObj.extraParamDic = self.extraParamDic;
    [reqObj requestAtView:view mask:mask block:block];
}


@end
