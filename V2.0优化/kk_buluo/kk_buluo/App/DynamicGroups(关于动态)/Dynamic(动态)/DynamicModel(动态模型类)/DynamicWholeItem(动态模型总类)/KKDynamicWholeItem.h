//
//  KKDynamicWholeItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKDynamicHeadItem.h" //昵称视图
#import "KKDynamicTextItem.h" //文本
#import "BBDynamicImageItem.h" //动态图片
#import "KKDynamicCardItem.h" //名片
#import "KKDynamicOperationItem.h" //操作


#import "KKDynamicArticleItem.h"  //长文动态

NS_ASSUME_NONNULL_BEGIN
@class
KKDynamicWholeItem,
KKDynamicHeadItem,
KKDynamicTextItem,
BBDynamicImageItem,
KKDynamicCardItem,
KKDynamicOperationItem;

@interface KKDynamicWholeItem : NSObject

@property (nonatomic,strong)NSDictionary *dynamicDictionary;

/*这个动态的id*/
@property (nonatomic,strong)NSString *subjectId;

/*这个动态的类型*/
@property (nonatomic,strong)NSString *objectType;

//更新数据时间
@property (nonatomic,strong)NSString *nowDate;

/* 动态头像昵称模型 */
@property (nonatomic,strong)KKDynamicHeadItem *dynamicHeadItem;
/* 动态文本模型 */
@property (nonatomic,strong)KKDynamicTextItem *dynamicTextItem;
/* 这个动态是存在图片数组 */
@property (nonatomic,assign) BOOL isImages;
/* 这个动态的第一张图片 */
@property (nonatomic,strong) NSString *firstImageUrl;

/* 动态图片模型 */
@property (nonatomic,strong)BBDynamicImageItem *dynamicImageitem;
/* 这个动态是否为转发 */
@property (nonatomic,assign) BOOL isTransmitSubject;


/* 动态名片模型 */
@property (nonatomic,strong)KKDynamicCardItem *dynamicCardItem;


/* 动态操作模型 */
@property (nonatomic,strong)KKDynamicOperationItem *dynamicOperationItem;

/* 长文数据模型 */
@property (nonatomic,strong) KKDynamicArticleItem *dynamicArticleItem;

/** 动态单元格高度 所用的子控件的高度计算完成后一一相加 */
@property (nonatomic,assign) CGFloat cellHeight;

+ (CGFloat)cellHeight:(KKDynamicWholeItem *)item;

//处理获取到的动态的模型数据
/**
 将动态的所有数据的字典分组成对应的控件所需要的字典
 */
+ (instancetype)makeTheDynamicItemWithDictionary:(NSDictionary *)dict;



@end

NS_ASSUME_NONNULL_END
