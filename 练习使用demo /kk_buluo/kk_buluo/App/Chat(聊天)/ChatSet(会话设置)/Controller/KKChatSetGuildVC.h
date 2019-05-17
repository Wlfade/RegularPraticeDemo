//
//  KKChatSetGuildVC.h
//  kk_buluo
//
//  Created by david on 2019/4/28.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"
//融云
#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChatSetGuildVC : BaseViewController
@property(nonatomic, strong) NSString *targetId;
@property (nonatomic, assign) RCConversationType conversationType;
@end

NS_ASSUME_NONNULL_END
