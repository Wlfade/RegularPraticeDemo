//
//  KKDydeTransmitItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKDynamicHeadItem.h" //昵称视图
#import "KKDynamicCommentTextItem.h" //文本

NS_ASSUME_NONNULL_BEGIN

@class
KKDydeTransmitItem,
KKDynamicHeadItem, //头像
KKDynamicCommentTextItem;

@interface KKDydeTransmitItem : NSObject

@property (nonatomic,strong) NSString *transDyId;
/* 动态头像昵称模型 */
@property (nonatomic,strong) KKDynamicHeadItem *dynamicHeadItem;
/* 动态文本模型 */
@property (nonatomic,strong) KKDynamicCommentTextItem *dynamicTransmitTextItem;

//更新数据时间
@property (nonatomic,strong)NSString *nowDate;
/** 动态评论单元格高度 所用的子控件的高度计算完成后一一相加 */
@property (nonatomic,assign) CGFloat dyTranmitHeight;
//转发的动态字典管理
+ (instancetype)KKDydeTransmitItemWithDictionary:(NSDictionary *)dict;
//评论的回复的动态字典管理
+ (instancetype)KKDydeReplyWithDictionary:(NSDictionary *)dict;

+ (CGFloat)cellHeight:(KKDydeTransmitItem *)item;
@end

NS_ASSUME_NONNULL_END
