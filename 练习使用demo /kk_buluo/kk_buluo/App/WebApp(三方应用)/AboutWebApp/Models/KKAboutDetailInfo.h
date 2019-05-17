//
//  KKAboutDetailInfo.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/23.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKAboutDetailInfo : NSObject

/**
 {
 "guildName" : "修改工会名称",
 "guildLogoUrl" : "http:\/\/mapi1.kknew.net\/guildLogoUrl.htm?guildId=4004085104060816060000002838&sizeType=SMALL&timestamp=1556023746242",
 "guildNo" : "735701",
 "ownerId" : "1122221",
 "memo" : "修改简介",
 "creator" : "1122221",
 "guildId" : "4004085104060816060000002838"
 }
 */
@property (nonatomic, copy) NSString *guildName;
@property (nonatomic, copy) NSString *guildLogoUrl;
@property (nonatomic, copy) NSString *guildNo;
@property (nonatomic, copy) NSString *ownerId;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *guildId;
@property (nonatomic, copy) NSString *memo;

@end

NS_ASSUME_NONNULL_END
