//
//  KKPersonalPageModel.h
//  kk_buluo
//
//  Created by 樊星 on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKApplicationInfo.h"
/*
 "guildSimple" : {
 "guildName" : "公会1",
 "guildLogoUrl" : "http:\/\/mapi1.kknew.net\/guildLogoUrl.htm?guildId=10944004309969237916060980186000&sizeType=SMALL&timestamp=1557454052980",
 "guildNo" : "249522",
 "memo" : "花花覆盖天赋和人员混入用户提供",
 "guildCert" : "KK部落官方认证",
 "creator" : "10944004309893299116060980183552",
 "guildId" : "10944004309969237916060980186000"
 }
 */
@interface KKguildSimpleModel : NSObject
@property (nonatomic, copy) NSString *guildId;
@end
@interface KKPersonalPageModel : NSObject

//个人主页
@property (nonatomic, assign) long commentMyUsers;
@property (nonatomic, assign) BOOL existMyBlacklist;
@property (nonatomic, assign) BOOL focus;
@property (nonatomic, assign) long followMyUsers;
@property (nonatomic, assign) BOOL friend;
@property (nonatomic, assign) BOOL jumpLogin;
@property (nonatomic, assign) long likeMyUsers;
@property (nonatomic, assign) long myFollowers;
@property (nonatomic, assign) BOOL mySelf;
@property (nonatomic, assign) long nowTimestamp;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) long transmitMyUsers;
@property (nonatomic, strong) NSString * nowDate;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userLogoUrl;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * memo;

//@property (nonatomic, retain) NSMutableArray *myGroups;
@property (nonatomic, strong) NSArray *myGroups;


//公会号主页
@property (nonatomic, strong) NSString * detailMessage;
@property (nonatomic, strong) NSString * guildSimple;
@property (nonatomic, strong) NSString * roleCode;
@property (nonatomic, strong) NSString * error;
@property (nonatomic, strong) NSString * guildCert;
@property (nonatomic, strong) KKApplicationInfo * applicationSimple;
@property (nonatomic, retain) NSMutableArray *guildGroups;


//群主页
@property (nonatomic, assign) BOOL joined;

@end


@interface KKPersonalPageGroupModel : NSObject
/*
 {
 "status" : {
 "name" : "NORMAL",
 "message" : "正常"
 },
 "notice" : "啊啊啊啊啊天啊",
 "groupLogoUrl" : "http:\/\/mapi1.kknew.net\/groupLogoUrl.htm?groupId=10984003953771910900740980186935&sizeType=SMALL&timestamp=1556531630375",
 "groupCode" : "GROUP_CHAT-10984003953771897712260980182467",
 "groupName" : "团子群聊4",
 "gmtNoticeModified" : "2019-03-29 16:50:29",
 "userJoined" : 0,
 "groupId" : "10984003953771910900740980186935",
 "groupMembers" : 2
 }
 */
@property (nonatomic, strong) NSString * groupId;
@property (nonatomic, strong) NSString * groupLogoUrl;
@property (nonatomic, strong) NSString * groupName;
@property (nonatomic, strong) NSString * groupChatId;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * ownerId;
@property (nonatomic, strong) NSString * groupMembers;
@property (nonatomic, strong) NSString * userJoined;
@property (nonatomic, strong) NSString * memo;

@end
