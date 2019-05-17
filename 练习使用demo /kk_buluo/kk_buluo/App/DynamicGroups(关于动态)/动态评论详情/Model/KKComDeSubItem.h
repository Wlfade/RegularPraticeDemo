//
//  KKComDeSubItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKDynamicHeadItem.h" //昵称视图
#import "KKDynamicCommentTextItem.h" //文本
#import "KKDyCommentImageItem.h" //图片
NS_ASSUME_NONNULL_BEGIN
@class
KKComDeSubItem;

@interface KKComDeSubItem : NSObject

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


@property (nonatomic,strong) NSString *nowDate;
@property (nonatomic,strong) NSString *nowTimestamp;
@property (nonatomic,strong) NSDictionary *commentObject;

/** 动态评论单元格高度 所用的子控件的高度计算完成后一一相加 */
@property (nonatomic,assign) CGFloat dyCommentHeight;


//评论数据的处理返回个存放了模型的数组
+ (instancetype)KKComDeSubItemWithDictionary:(NSDictionary *)dict;

+ (CGFloat)cellHeight:(KKComDeSubItem *)item;
@end

NS_ASSUME_NONNULL_END
