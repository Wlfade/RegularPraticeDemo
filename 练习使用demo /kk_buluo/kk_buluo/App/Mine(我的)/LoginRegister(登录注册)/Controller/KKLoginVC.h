//
//  KKLoginVC.h
//  kk_buluo
//
//  Created by david on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"



NS_ASSUME_NONNULL_BEGIN

@interface KKLoginVC : BaseViewController

/**
@brief登录成功处理
@param needSelectRole 是否需要选择角色,如果是,oneAuth签名之后就算处理成功
@return 代表处理是否成功
*/
+(BOOL)handleLoginSuccess:(NSDictionary *)responseDic needSelectRole:(BOOL)needSelectRole ;

@end

NS_ASSUME_NONNULL_END
