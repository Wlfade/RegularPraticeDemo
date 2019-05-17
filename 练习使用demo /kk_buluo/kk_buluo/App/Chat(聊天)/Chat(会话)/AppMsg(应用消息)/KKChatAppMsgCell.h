//
//  KKChatAppMsgCell.h
//  kk_buluo
//
//  Created by david on 2019/3/30.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChatAppMsgCell : RCMessageCell
///图片
@property (nonatomic, weak) UIImageView *imgView;
///名字
@property (nonatomic, weak) UILabel *nameLabel;
///概要介绍
@property (nonatomic, weak) UILabel *summaryLabel;
///标签信息(“推荐应用”)
@property (nonatomic, weak) UILabel *tagLabel;
///灰线
@property (nonatomic, weak) UIView *grayLine;

///背景View
@property(nonatomic, strong) UIImageView *bubbleBgImageView;

@end

NS_ASSUME_NONNULL_END
