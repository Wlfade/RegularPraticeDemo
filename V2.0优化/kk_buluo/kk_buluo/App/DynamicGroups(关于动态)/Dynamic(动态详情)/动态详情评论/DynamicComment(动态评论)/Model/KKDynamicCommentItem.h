//
//  KKDynamicCommentItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKDynamicHeadItem.h" //昵称视图
#import "KKDynamicCommentTextItem.h" //文本
#import "KKDynamicCommentReplyItem.h" //评论的回复
//#import "BBDynamicImageItem.h"
#import "KKDyCommentImageItem.h"

NS_ASSUME_NONNULL_BEGIN

@class
KKDynamicCommentItem;

@interface KKDynamicCommentItem : NSObject

@property (nonatomic,strong)NSString *commentId;
/* 动态头像昵称模型 */
@property (nonatomic,strong) KKDynamicHeadItem *dynamicHeadItem;
/* 动态文本模型 */
@property (nonatomic,strong) KKDynamicCommentTextItem *dynamicComTextItem;

//是否有评论图片
@property (nonatomic,assign) BOOL isImages;
//评论图片数据
@property (nonatomic,strong) KKDyCommentImageItem *dynamicImageitem;
//评论图片高度
@property (nonatomic,assign) CGFloat dyImageHeight;

@property (nonatomic,assign) BOOL hasReply; //是否有评论
/* 评论的回复数组 */
@property (nonatomic,strong) NSArray *replyList;
@property (nonatomic,strong) NSString *replyCount;
@property (nonatomic,assign) CGFloat dyReplyHeight; //评论的回复的高度

//更新数据时间
@property (nonatomic,strong)NSString *nowDate;

/** 动态评论单元格高度 所用的子控件的高度计算完成后一一相加 */
@property (nonatomic,assign) CGFloat dyCommentHeight;

//评论数据的处理返回个存放了模型的数组
+ (NSMutableArray *)makeTheDynamicCommentItem:(NSDictionary *)dict;


+ (CGFloat)cellHeight:(KKDynamicCommentItem *)item;
@end

NS_ASSUME_NONNULL_END
