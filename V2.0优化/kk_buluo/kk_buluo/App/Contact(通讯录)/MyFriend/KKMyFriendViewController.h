//
//  KKMyFriendViewController.h
//  kk_buluo
//
//  Created by 景天 on 2019/3/26.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "KKContactUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKMyFriendViewController : BaseViewController
@property (nonatomic, copy) void(^selectedBlock)(KKContactUserInfo *userInfo);
@end

NS_ASSUME_NONNULL_END
