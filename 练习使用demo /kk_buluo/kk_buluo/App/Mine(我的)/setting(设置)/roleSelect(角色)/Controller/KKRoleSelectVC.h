//
//  KKRoleSelectVC.h
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKRoleSelectVC : BaseViewController

/**
 选择角色登录
 
 @param userId 选择登录的角色Id
 @param asDefault 是否重置默认角色
 */
+ (void)requestLoginWithUserId:(NSString *)userId asDefault:(BOOL)asDefault;

@end

NS_ASSUME_NONNULL_END
