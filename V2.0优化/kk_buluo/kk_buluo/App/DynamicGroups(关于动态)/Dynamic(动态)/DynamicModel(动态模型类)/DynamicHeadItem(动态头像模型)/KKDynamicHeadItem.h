//
//  KKDynamicHeadItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDynamicHeadItem : NSObject

@property (nonatomic,strong)void(^HeadViewClickBlock)(void);
/** 用户类型字典 */
@property (nonatomic,strong)NSDictionary *commonObjectType;
/** 用户类型 */
@property (nonatomic,strong)NSString *commonObjectTypeName;
/** 评论的id */
@property (nonatomic,strong)NSString *commentId;
/** 用户id */
@property (nonatomic,strong) NSString *userId;
/** 头像地址 */
@property (nonatomic,strong) NSString *userLogoUrl;
/** 用户昵称 */
@property (nonatomic,strong) NSString *userName;

/** 用户认证 */
@property (nonatomic,strong) NSString *commonObjectCert;

/** 申请时间 */
@property (nonatomic, copy) NSString *gmtCreate;
/** 请求数据的时间 */
@property (nonatomic, copy) NSString *nowDate;
/** 显示的时间 */
@property (nonatomic, copy) NSString *showDate;


/** 是否已经关注了(动态详情 头部 关注/已关注) */
@property (nonatomic,assign) BOOL focus;

/** 是否点赞了(动态详情 评论 头部 关注/已关注) */
@property (nonatomic,assign) BOOL liked;
/** 评论点赞数(动态详情 评论) */
@property (nonatomic,assign) NSInteger likeCount;

/** 动态头像高度 */
@property (nonatomic,assign) CGFloat dynamicHeadHeight;
@end

NS_ASSUME_NONNULL_END
