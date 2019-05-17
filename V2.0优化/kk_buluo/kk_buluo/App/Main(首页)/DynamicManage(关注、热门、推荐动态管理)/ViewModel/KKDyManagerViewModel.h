//
//  KKDyManagerViewModel.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDyManagerViewModel : NSObject



/**
 //首页-关注 动态数据的请求

 @param currentPage 当前页码
 @param completeBlock 结果 
 */
+ (void)requestMyFollowTopicQuery:(NSNumber *)currentPage complete:(void(^)(NSString *, ResModel *, NSMutableArray *))completeBlock;


/**
 //首页-推荐 动态数据的请求
 
 @param currentPage 当前页码
 @param completeBlock 结果
 */
+ (void)requestAllGuileSubjectQuery:(NSNumber *)currentPage complete:(void(^)(NSString *, ResModel *, NSMutableArray *))completeBlock;


/**
 //首页-热门 动态数据的请求
 
 @param currentPage 当前页码
 @param completeBlock 结果
 */
+ (void)requestHotSubjectQuery:(NSNumber *)currentPage complete:(void(^)(NSString *, ResModel *, NSMutableArray *))completeBlock;



/**
 //关注用户
 @param typeName 用户类型
 @param userId 用户id
 @param complete 结果 成功 BOOL YES
 */
+ (void)requstToAttentionTypeName:(NSString *)typeName withUserId:(NSString *)userId withComplete:(void(^)(bool))complete;


/**
 删除(自己)动态

 @param subjectId 动态id
 @param complete 结果
 */
+ (void)requstDeleteDynamicSubjectId:(NSString *)subjectId complete:(void(^)(void))complete;
@end

NS_ASSUME_NONNULL_END
