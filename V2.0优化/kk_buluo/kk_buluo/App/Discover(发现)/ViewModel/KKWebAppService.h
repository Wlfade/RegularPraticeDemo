//
//  KKDiscoverService.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKApplicationInfo;
@class KKWebAppMoreInfo;
NS_ASSUME_NONNULL_BEGIN

typedef void(^requestWebAppBlockSuccess)(NSMutableArray *applicationList);
typedef void(^requestDiscoverWebAppBlockSuccess)(NSMutableArray *applicationList);

typedef void(^requestWebAppBlockFail)(void);
typedef void(^requestWebAppAuthStatusBlockSuccess)(NSString *authorize, NSString *code, NSString *authorizeIntro);
typedef void(^requestWebAppAuthStatusBlockFail)(NSString *authorize);
typedef void(^requestWebAppAuthBlockSuccess)(NSString *code);
typedef void(^requestWebAppAddBlockSuccess)(void);
typedef void(^requestWebAppDeleteBlockSuccess)(void);
typedef void(^requestWebAppDetailDataBlockSuccess)(NSMutableArray *guildList, KKApplicationInfo *appInfo);
typedef void(^requestGuildRelevanceWebAppDataBlockSuccess)(KKApplicationInfo *appInfo);
typedef void(^requestGuildRelevanceWebAppDataBlockFail)(void);
typedef void(^requestWebAppMoreInfoDataBlockSuccess)(KKWebAppMoreInfo *moreInfo);
typedef void(^requestGuildAboutGroupBlockSuccess)(NSMutableArray *guildList);


@interface KKWebAppService : NSObject
@property (nonatomic, copy) requestWebAppBlockSuccess requestWebAppBlockSuccess;
@property (nonatomic, copy) requestDiscoverWebAppBlockSuccess requestDiscoverWebAppBlockSuccess;
@property (nonatomic, copy) requestWebAppBlockFail requestWebAppBlockFail;
@property (nonatomic, copy) requestWebAppAuthStatusBlockSuccess requestWebAppAuthStatusBlockSuccess;
@property (nonatomic, copy) requestWebAppAuthStatusBlockFail requestWebAppAuthStatusBlockFail;
@property (nonatomic, copy) requestWebAppAuthBlockSuccess requestWebAppAuthBlockSuccess;
@property (nonatomic, copy) requestWebAppAddBlockSuccess requestWebAppAddBlockSuccess;
@property (nonatomic, copy) requestWebAppDeleteBlockSuccess requestWebAppDeleteBlockSuccess;
@property (nonatomic, copy) requestWebAppDetailDataBlockSuccess requestWebAppDetailDataBlockSuccess;
@property (nonatomic, copy) requestGuildRelevanceWebAppDataBlockSuccess requestGuildRelevanceWebAppDataBlockSuccess;
@property (nonatomic, copy) requestGuildRelevanceWebAppDataBlockFail requestGuildRelevanceWebAppDataBlockFail;
@property (nonatomic, copy) requestWebAppMoreInfoDataBlockSuccess requestWebAppMoreInfoDataBlockSuccess;
@property (nonatomic, copy) requestGuildAboutGroupBlockSuccess requestGuildAboutGroupBlockSuccess;


/**
 应用ID
 */
@property (nonatomic, copy) NSString *appId;

/**
 公会ID
 */
@property (nonatomic, copy) NSString *guildId;

/**
 收藏的对象
 */
@property (nonatomic, copy) NSString *objectId;

/**
 收藏的类型
 SUBJECT => 话题
 APPLICATION => 应用
 */
@property (nonatomic, copy) NSString *objectType;

/**
 shareInstance

 @return 初始化
 */
+ (instancetype)shareInstance;

/**
 requestMyWebAppSuccess: 请求(MY)用户应用

 @param success 成功
 @param fail 失败
 */
+ (void)requestWebAppSuccess:(requestWebAppBlockSuccess)success Fail:(requestWebAppBlockFail)fail;

/**
 requestDiscoverListWebAppSuccess: 请求发现列表应用

 @param success 成功
 */
+ (void)requestDiscoverListWebAppSuccess:(requestDiscoverWebAppBlockSuccess)success;

/**
 requestMyWebAppUserAuthStatusSuccess: 请求用户是否授权

 @param success 成功
 */
+ (void)requestWebAppUserAuthStatusSuccess:(requestWebAppAuthStatusBlockSuccess)success Fail:(requestWebAppAuthStatusBlockFail)fail;

/**
 requestWebAppAuthSuccess: 请求webApp授权

 @param success 成功
 */
+ (void)requestWebAppAuthSuccess:(requestWebAppAuthBlockSuccess)success;


/**
 requestWebAppAddToMyCollecttionSuccess: 添加应用到我的收藏

 @param success 成功
 */
+ (void)requestWebAppAddToMyCollecttionSuccess:(requestWebAppAddBlockSuccess)success;


/**
 requestWebAppDeleteToMyCollecttionSuccess: 移除应用

 @param success 成功
 */
+ (void)requestWebAppDeleteToMyCollecttionSuccess:(requestWebAppDeleteBlockSuccess)success;


/**
 requestAboutWebAppdDetailDataSuccess: 应用详情

 @param success 成功
 */
+ (void)requestAboutWebAppDetailDataSuccess:(requestWebAppDetailDataBlockSuccess)success;


/**
 requestGuildRelevanceWebAppDataSuccess: 公会关联的应用 只有一个 1 To 1

 @param success 成功
 */
+ (void)requestGuildRelevanceWebAppDataSuccess:(requestGuildRelevanceWebAppDataBlockSuccess)success Fail:(requestGuildRelevanceWebAppDataBlockFail)fail;

/**
 requestGuildRelevanceWebAppDataSuccess: 请求关于应用的更多资料

 @param success 成功
 */
+ (void)requestWebAppMoreInfoDataSuccess:(requestWebAppMoreInfoDataBlockSuccess)success;

/**
 requestGuildAboutGroupDataSuccess: 请求公会号相关群

 @param success 成功
 */
+ (void)requestGuildAboutGroupDataSuccess:(requestGuildAboutGroupBlockSuccess)success;

@end

NS_ASSUME_NONNULL_END
