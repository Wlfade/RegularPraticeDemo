//
//  KKChatAppMsgContent.h
//  kk_buluo
//
//  Created by david on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 消息的类型名
#define KKBLMsgIdApp  @"KKBL:AppMsg"

@interface KKChatAppMsgContent : RCMessageContent

///应用的Id
@property (nonatomic, copy) NSString *idStr;

///应用的url
@property (nonatomic, copy) NSString *appUrl;

///标题
@property(nonatomic, copy) NSString *name;

///介绍
@property(nonatomic, copy) NSString *summary;

///图片
@property(nonatomic, copy) NSString *imgUrl;

///标签信息(“推荐应用”)
@property(nonatomic, copy) NSString *tagStr;

///额外信息(预留字段)
@property(nonatomic, copy) NSString *extra;


@end

NS_ASSUME_NONNULL_END
