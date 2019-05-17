//
//  KKPwdMgrVC.h
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSUInteger, KKPwdMgrType) {
    KKPwdMgrTypeForPwd = 0,
    KKPwdMgrTypeForPayPwd
};

NS_ASSUME_NONNULL_BEGIN

@interface KKPwdMgrVC : BaseViewController
-(instancetype)initWithType:(KKPwdMgrType)type;
@end

NS_ASSUME_NONNULL_END
