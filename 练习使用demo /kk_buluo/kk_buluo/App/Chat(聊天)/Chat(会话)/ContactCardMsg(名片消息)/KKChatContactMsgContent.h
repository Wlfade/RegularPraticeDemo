//
//  KKChatContactMsgContent.h
//  kk_buluo
//
//  Created by david on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 消息的类型名
#define KKBLMsgIdContactCard  @"KKBL:ContactCardMsg"

@interface KKChatContactMsgContent : RCMessageContent

///名片Id
@property (nonatomic, copy) NSString *idStr;

///名字
@property(nonatomic, copy) NSString *name;

///图片
@property(nonatomic, copy) NSString *imgUrl;

///类型(int,1=个人,2=公众号,3=部落群)
@property(nonatomic, assign) NSInteger type;

///标签信息(名片类型)
@property(nonatomic, copy) NSString *tagStr;

///额外信息(预留字段)
@property(nonatomic, copy) NSString *extra;


@end

NS_ASSUME_NONNULL_END
