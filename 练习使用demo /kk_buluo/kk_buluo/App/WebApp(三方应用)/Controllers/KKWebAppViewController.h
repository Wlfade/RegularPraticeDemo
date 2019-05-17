//
//  KKWebAppViewController.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "KKApplicationInfo.h"
#import "KKContactUserInfo.h"



NS_ASSUME_NONNULL_BEGIN
typedef void(^pushChatVCBlock)(KKContactUserInfo *userInfo);

@interface KKWebAppViewController : BaseViewController
@property (nonatomic, strong) KKApplicationInfo *appInfo;
@property (nonatomic, copy) pushChatVCBlock pushChatVCBlock;


@end

NS_ASSUME_NONNULL_END
