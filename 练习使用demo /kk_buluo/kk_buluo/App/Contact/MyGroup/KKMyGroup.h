//
//  KKMyGroup.h
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "groupId" : "10984003886384090000740980189019",
 "groupChatId" : "10984003886384051812260980180024",
 "groupName" : "Jttest",
 "status" : {
 "name" : "NORMAL",
 "message" : "正常"
 },
 "groupLogoUrl" : "http:\/\/mapi1.kknew.net\/groupLogoUrl.htm?groupId=10984003886384090000740980189019&sizeType=LARGE&timestamp=1553049061630",
 "ownerId" : "10984003867611813600290970025917"
 }
 */

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
/*
 "creator" : {
 "userLogoUrl" : "http:\/\/mapi1.kknew.net\/userLogoUrl.htm?userId=10984003867611813600290970025917&timestamp=1553133268792",
 "userId" : "10984003867611813600290970025917",
 "loginName" : "jingtian"
 }
 */
NS_ASSUME_NONNULL_BEGIN

@interface KKCrreator : NSObject
@property (nonatomic, copy) NSString *userLogoUrl;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *loginName;

@end

@interface KKStatus : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;

@end

@interface KKMyGroup : NSObject
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *groupChatId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, strong) KKStatus *status;
@property (nonatomic, copy) NSString *groupLogoUrl;
@property (nonatomic, copy) NSString *ownerId;
@property (nonatomic, strong) KKCrreator *creator;


@end

NS_ASSUME_NONNULL_END
