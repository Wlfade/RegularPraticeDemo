//
//  KKChatSearchHistoryMsgVC.h
//  kk_buluo
//
//  Created by david on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChatSearchHistoryMsgVC : BaseViewController

/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;

/*!
 目标会话ID
 */
@property(nonatomic, copy) NSString *targetId;

@end

NS_ASSUME_NONNULL_END
