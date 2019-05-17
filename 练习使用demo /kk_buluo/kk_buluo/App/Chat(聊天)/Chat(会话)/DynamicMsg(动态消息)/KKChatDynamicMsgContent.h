//
//  KKChatDynamicMsgContent.h
//  kk_buluo
//
//  Created by david on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

/*! 消息的类型名 */
#define KKBLMsgIdDynamic  @"KKBL:DynamicMsg"

@interface KKChatDynamicMsgContent : RCMessageContent

///动态的Id
@property (nonatomic, copy) NSString *idStr;

///标题
@property(nonatomic, copy) NSString *title;

///概要介绍(内容)
@property(nonatomic, copy) NSString *summary;

///图片
@property(nonatomic, copy) NSString *imgUrl;

///类型(int,1=短文,2=长文)
@property(nonatomic, assign) NSInteger type;

///标签信息(作者)
@property(nonatomic, copy) NSString *tagStr;

///额外信息(预留字段)
@property(nonatomic, copy) NSString *extra;


@end

NS_ASSUME_NONNULL_END
