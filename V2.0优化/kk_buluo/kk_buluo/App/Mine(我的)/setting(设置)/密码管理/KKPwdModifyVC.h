//
//  KKPwdModifyVC.h
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, KKPwdModifyType) {
    KKPwdModifyTypeForPwd = 0,  // 修改登录密码
    KKPwdModifyTypeForPayPwd,   // 修改支付密码
};

NS_ASSUME_NONNULL_BEGIN

@interface KKPwdModifyVC : BaseViewController
-(instancetype)initWithType:(KKPwdModifyType)type;
@end

NS_ASSUME_NONNULL_END
