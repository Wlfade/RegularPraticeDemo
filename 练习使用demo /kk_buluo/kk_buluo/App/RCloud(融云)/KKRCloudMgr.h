//
//  KKRCloudMgr.h
//  kk_buluo
//
//  Created by david on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRCloudMgr : NSObject

#pragma mark - life circle
+ (instancetype)shareInstance;
- (void)remove;


#pragma mark - 融云相关
/** 融云初始化配置 */
-(void)rcConfig;

/** 是否是公会号 */
-(BOOL)isGuild:(NSString *)targetId;

#pragma mark - 连接

/** 是否连接成功 */
-(BOOL)rcConectSuccess;

/** 检查连接,如果连接失败会再次请求连接 (有很多状态) */
-(void)rcCheckConnectStatus;

/** 连接融云服务器 */
-(void)rcConnectService;

/** 断开融云服务器, isReceivePush代表是否接收远程推送*/
-(void)rcDisconnect:(BOOL)isReceivePush;

/** 请求融云userToken */
-(void)requestRcUserToken:(void(^)(BOOL hasError))finish;


#pragma mark - 更新,缓存
/** 清空所有缓存(userInfo,groupInfo,groupUserInfo) */
-(void)rcClearAllCache;

/** 更新群信息 的本地缓存 */
-(void)updateGroupInfo:(NSString *)groupId;

/** 更新user信息 的本地缓存(包括公会号,公会号没"K_"前缀要加上) */
-(void)updateUserInfo:(NSString *)userId;

#pragma mark - 属性
/** 融云用户账户 */
@property (nonatomic, copy) NSString *rcUserId;
@property (nonatomic, copy) NSString *rcUserToken;
@property (nonatomic, copy) NSString *rcAppSdkId;


#pragma mark 工具属性
/** 可以接收推送 */
@property (nonatomic, assign) BOOL canPushNotification;

/** 可以播放消息提示音 */
@property (nonatomic, assign) BOOL canPlayAlertSound;



@end

NS_ASSUME_NONNULL_END
