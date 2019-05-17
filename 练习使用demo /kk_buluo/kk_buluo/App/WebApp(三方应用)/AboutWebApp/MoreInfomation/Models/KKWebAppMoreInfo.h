//
//  KKWebAppMoreInfo.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKWebAppMoreInfo : NSObject

/**
 {
 "response" : {
 "record" : "2019年04月24日 注册测试应用",
 "statement" : " 本服务由开发者向KK用户提供，开发者对本服务信息内容、数据资料及其运营行为等的真实性、合法性及有效性承担全部责任。KK向开发者提供技术支持服务。 ",
 "applicationUrl" : "https:\/\/1230.com",
 "jumpLogin" : 0,
 "nowTimestamp" : 1556450934677,
 "userPrivacy" : " 开发者收集、存储、处理或使用用户隐私及数据，应当遵守小程序服务条款“四、用户个人信息保护”及运营规范“15.用户隐私及数据规范”等规定。若你认为开发者未遵守上述规定或存在其他侵害用户隐私或数据的情况，可进行投诉。 ",
 "success" : 1,
 "catagor" : "游戏",
 "nowDate" : "2019-04-28 19:28:54",
 "creator" : "施爷测试"
 }
 }
 */
@property (nonatomic, copy) NSString *record;
@property (nonatomic, copy) NSString *applicationUrl;
@property (nonatomic, copy) NSString *jumpLogin;
@property (nonatomic, copy) NSString *nowTimestamp;
@property (nonatomic, copy) NSString *success;
@property (nonatomic, copy) NSString *nowDate;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *userPrivacy;
@property (nonatomic, copy) NSString *catagor;
@property (nonatomic, copy) NSString *statement;

@end

NS_ASSUME_NONNULL_END
