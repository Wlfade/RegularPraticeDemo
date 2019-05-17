//
//  KKRecommend.m
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyRecommend.h"

@implementation KKMyObjectType


@end

@implementation KKMyRecommend

//@property (nonatomic, copy) NSString *cell;
//@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, copy) NSString *loginName;
//@property (nonatomic, copy) NSString *userLogoUrl;
//
/////
//
//@property (nonatomic, copy) NSString *commonObjectId;
//@property (nonatomic, copy) NSString *commonObjectName;
//@property (nonatomic, copy) NSString *commonObjectLogoUrl;
//@property (nonatomic, copy) NSString *commonObjectCert;
//@property (nonatomic, copy) NSString *commonObjectMemo;




/**
 "guildName" : "修改工会名称",
 "guildLogoUrl" : "http:\/\/mapi1.kknew.net\/guildLogoUrl.htm?guildId=4004085104060816060000002838&sizeType=SMALL&timestamp=1556181714512",
 "guildNo" : "735701",
 "ownerId" : "1122221",
 "memo" : "修改简介",
 "creator" : "1122221",
 "guildId" : "4004085104060816060000002838"
 */

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    
    return @{
        @"userId":@"commonObjectId",
        @"loginName":@"commonObjectName",
        @"userLogoUrl":@"commonObjectLogoUrl",
        @"objectType":@"commonObjectType",
        @"loginName":@"guildName",
        @"userLogoUrl":@"guildLogoUrl",
        @"commonObjectMemo":@"memo",
    };
}
@end
