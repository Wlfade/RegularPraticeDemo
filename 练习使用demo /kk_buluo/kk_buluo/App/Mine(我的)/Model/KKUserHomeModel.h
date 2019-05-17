//
//  KKUserHomeModel.h
//  kk_buluo
//
//  Created by david on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKUserHomeModel : NSObject
/** 用户号 */
@property (nonatomic, copy) NSString *userId;

/** 用户名 */
@property (nonatomic, copy) NSString *userName;

/** 会员头像url */
@property (nonatomic, copy) NSString *userLogoUrl;

/** 简介 */
@property (nonatomic, copy) NSString *memo;

/** 我的群 */
@property (nonatomic, strong) NSArray *myGroups;

/** 是否是好友关系 */
@property (nonatomic, assign) BOOL friend;

/** 是否被拉黑 */
@property (nonatomic, assign) BOOL existMyBlacklist;

/** 是否是本人 */
@property (nonatomic, assign) BOOL mySelf;

/** 是否关注 */
@property (nonatomic, assign) BOOL focus;

/** 关注数量 */
@property (nonatomic, assign) NSInteger myFollowers;

/** 粉丝数 */
@property (nonatomic, assign) NSInteger followMyUsers;

/** 获赞数 */
@property (nonatomic, assign) NSInteger likeMyUsers;

/** 获评论数 */
@property (nonatomic, assign) NSInteger commentMyUsers;

/** 获转发数 */
@property (nonatomic, assign) NSInteger transmitMyUsers;


@end

NS_ASSUME_NONNULL_END
