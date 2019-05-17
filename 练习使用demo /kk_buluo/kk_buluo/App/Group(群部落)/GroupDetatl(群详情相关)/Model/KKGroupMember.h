//
//  KKGroupMember.h
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 {
 "joined" : 1,
 "commonObjectLogoUrl" : "http:\/\/mapi1.kknew.net\/userLogoUrl.htm?userId=10984003867611813600290970025917&timestamp=1552807315000",
 "id" : "10984003886547370500740980183247",
 "commonObjectName" : "jingtian",
 "groupId" : "10984003886547367800740980188804",
 "sequenceValue" : 0,
 "forbidden" : 0
 }
 */
@interface KKGroupMember : NSObject
@property (nonatomic, assign) CGFloat joined; /// 是否在组内
@property (nonatomic, copy) NSString *userLogoUrl; /// 对象头像
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *loginName; /// 对象名字
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *forbidden; /// 是否被禁言
@property (nonatomic, copy) NSString *sequenceValue; /// 排序值，值越小，越靠前
@property (nonatomic, assign) BOOL isExist; /// 是群成员

/*
 loginName=commonObjectName
 userId=commonObjectId
 userLogoUrl=commonObjectLogoUrl
 */

- (BOOL)isEqualToModel:(KKGroupMember *)model;
@end

NS_ASSUME_NONNULL_END
