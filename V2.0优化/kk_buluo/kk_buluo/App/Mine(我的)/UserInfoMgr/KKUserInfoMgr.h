//
//  KKUserInfoMgr.h
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKUserInfoMgr : NSObject

#pragma mark - life circle
+ (instancetype)shareInstance;
- (void)remove;


#pragma mark - 用户信息
/** request获取用户信息 */
-(void)requestUserInfo:(nullable void(^)(void))finish;

#pragma mark - login
/** 是否已登录 */
+ (BOOL)isLogin;

/** 登出 */
- (void)logoutAndSetNil:(nullable void(^)(void))finish;

/** preset跳转logoinVC*/
- (void)presentLoginVC;



#pragma mark - 属性
/** 储存userInfo */
@property (nonatomic, strong) KKUserInfoModel *userInfoModel;

/** 用户Id */
@property (nonatomic,copy) NSString *userId;


@end

NS_ASSUME_NONNULL_END
