//
//  KKRCloudMgr.m
//  kk_buluo
//
//  Created by david on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKRCloudMgr.h"
#import <RongIMKit/RongIMKit.h>
//工具
#import "JKEncrypt.h"
#import "KKChatDbMgr.h"

//融云相关
#define kRcUserId         @"rcUserId"
#define kRcUserToken      @"rcUserToken"
#define kRcAppSdkId       @"rcAppSdkId"
#define kRcCanPushNotification      @"rcCanPushNotification"
#define kRcCanPlayAlertSound        @"rcCanPlayAlertSound"

//融云自定义消息
#import "KKChatDynamicMsgContent.h"
#import "KKChatContactMsgContent.h"
#import "KKChatAppMsgContent.h"

@interface KKRCloudMgr ()
<RCIMConnectionStatusDelegate,
RCIMUserInfoDataSource,
RCIMGroupInfoDataSource,
RCIMGroupMemberDataSource,
RCIMPublicServiceProfileDataSource>
//用于清空
@property (nonatomic,strong) NSMutableArray *keyMutArr;

@property (nonatomic, assign) BOOL rcConnectSuccess;//是否连接成功
@property (nonatomic, assign) NSInteger rcConnectCount;//尝试连接次数
@end

@implementation KKRCloudMgr

static KKRCloudMgr *rCloudMgr = nil;
static dispatch_once_t onceToken;

#pragma mark - lazy load
-(NSMutableArray *)keyMutArr {
    if (!_keyMutArr) {
        _keyMutArr = [NSMutableArray array];
    }
    return _keyMutArr;
}


#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        rCloudMgr = [[KKRCloudMgr alloc] init];
    });
    return rCloudMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rcConnectSuccess = NO;
        self.rcConnectCount = 0;
        [self setupInfo];
    }
    return self;
}

/** 清空 */
- (void)remove{
    //1.删除userDefault中的用户信息
    for (NSInteger i=0; i<self.keyMutArr.count; i++) {
        [ccs saveDefaultKey:self.keyMutArr[i] andV:nil];
    }
    
    //2.断开融云服务器
    [self rcDisconnect:NO];
    
    //3.释放self的属性
    self.rcUserId = nil;
    self.rcAppSdkId = nil;
    self.rcUserToken = nil;
    self.canPlayAlertSound = YES;
    self.canPushNotification = YES;
}



- (void)setupInfo{
    
    self.rcUserId = [ccs getDefault:kRcUserId];
    [self.keyMutArr addObject:kRcUserId];
    
    self.rcUserToken = [ccs getDefault:kRcUserToken];
    [self.keyMutArr addObject:kRcUserToken];
    
    self.rcAppSdkId = [ccs getDefault:kRcAppSdkId];
    [self.keyMutArr addObject:kRcAppSdkId];
    
    self.canPushNotification = [[ccs getDefault:kRcCanPushNotification] boolValue];
    self.canPlayAlertSound = [[ccs getDefault:kRcCanPlayAlertSound] boolValue];
}


#pragma mark - 配置
/** 融云初始化 */
-(void)rcConfig {
    //1.初始化
    [[RCIM sharedRCIM] initWithAppKey:RCIM_AppKey_dev];//测试
//    [[RCIM sharedRCIM] initWithAppKey:RCIM_AppKey_pro];//正式

    
    //2.注册自定义消息
    [self rcRegisterDefinedMsg];
    
    
    //3.设置代理
    [self rcSetDelegate];
    
    //4.配置融云
    //-----------------------消息通知提醒----------------------
    //是否在会话页面和会话列表界面显示未注册的消息类型，默认值是NO
    //[RCIM sharedRCIM].showUnkownMessage = YES;
    //未注册的消息类型是否显示本地通知，默认值是NO
    //[RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    
    //-----------------------消息通知提醒----------------------
    [RCIM sharedRCIM].disableMessageNotificaiton = ![KKRCloudMgr shareInstance].canPushNotification;
    [RCIM sharedRCIM].disableMessageAlertSound = ![KKRCloudMgr shareInstance].canPlayAlertSound;
    
    //是否开启发送输入状态
    [RCIM sharedRCIM].enableTypingStatus = YES;
    //开启发送已读回执,目前仅支持单聊、群聊和讨论组。
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),
                                                                 @(ConversationType_DISCUSSION),
                                                                 @(ConversationType_GROUP)];
    //是否开启多端同步未读状态的功能，默认值是NO
    [RCIM sharedRCIM].enableSyncReadStatus = YES;
    //是否开启消息@提醒功能
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    
    //是否开启消息撤回功能，默认值是NO。
    [RCIM sharedRCIM].enableMessageRecall = YES;
    //消息可撤回的最大时间，单位是秒，默认值是120s。
    //[RCIM sharedRCIM].maxRecallDuration = YES;
    
    //消息可撤回的最大时间，单位是秒，默认值是60s，有效值为不小于5秒，不大于60秒
    //[RCIM sharedRCIM].maxVoiceDuration = 60;
    //APP是否独占音频 默认是NO
    //[RCIM sharedRCIM].isExclusiveSoundPlayer = NO;
    
    
    //-------------------用户信息、群组信息相关---------------------
    //是否将用户信息和群组信息在本地持久化存储，默认值为NO
    //[RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //是否在发送的所有消息中携带当前登录的用户信息，默认值为NO
    //[RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
    //-----------------------网页展示模式-------------------------
    //点击Cell中的URL时，优先使用WebView(YES)还是SFSafariViewController(NO)打开。默认为NO
    [RCIM sharedRCIM].embeddedWebViewPreferred = NO;
    
    //-------------------------头像显示---------------------------
    //SDK中全局的导航按钮字体颜色
    [RCIM sharedRCIM].globalNavigationBarTintColor = COLOR_BLACK_TEXT;
    
    //会话列表界面中显示的头像形状
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    //会话列表界面中显示的头像大小，高度必须大于或者等于36
    //[RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40, 40);
    
    //会话页面中显示的头像形状
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    //会话页面中显示的头像大小，默认值为40*40
    //[RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(40, 40);
    
    //会话列表界面和会话页面的头像的圆角曲率半径   默认值为4，只有当头像形状设置为矩形时才会生效
    //[RCIM sharedRCIM].portraitImageViewCornerRadius = 4.0;
}

-(void)rcRegisterDefinedMsg {
    // 注册自定义测试消息
    [[RCIM sharedRCIM] registerMessageType:[KKChatDynamicMsgContent class]];
    [[RCIM sharedRCIM] registerMessageType:[KKChatContactMsgContent class]];
    [[RCIM sharedRCIM] registerMessageType:[KKChatAppMsgContent class]];
}


-(void)rcSetDelegate {
    
    //监听连接状态的delegate
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    
    //-------------------------数据获取---------------------------
    //用户信息源
    [RCIM sharedRCIM].userInfoDataSource = self;
    //群组信息源
    [RCIM sharedRCIM].groupInfoDataSource = self;
    //群组成员信息源
    [RCIM sharedRCIM].groupMemberDataSource = self;
    //公众号信息源
    [RCIM sharedRCIM].publicServiceInfoDataSource = self;
    
}


/** 是否是公会号 */
-(BOOL)isGuild:(NSString *)targetId {
    if (targetId==nil || targetId.length < 1) {
        return NO;
    }
    return [targetId containsString:@"K_"];
}

#pragma mark - 连接
-(BOOL)rcConectSuccess {
    RCConnectionStatus status = [[RCIM sharedRCIM] getConnectionStatus];
    if (status == ConnectionStatus_Connected ||
        status == ConnectionStatus_Cellular_2G ||
        status == ConnectionStatus_Cellular_3G_4G  ||
        status == ConnectionStatus_WIFI ) {
        return YES;
    }
    return NO;
}

/** 检查连接,如果连接失败会再次请求连接 */
-(void)rcCheckConnectStatus {
    RCConnectionStatus status = [[RCIM sharedRCIM] getConnectionStatus];
    if (status == ConnectionStatus_Unconnected ||
        status == ConnectionStatus_SignUp || 
        status == ConnectionStatus_TOKEN_INCORRECT ||
        status == ConnectionStatus_DISCONN_EXCEPTION ) {
        self.rcConnectSuccess = 0;
        self.rcConnectCount = 0;
        [self rcConnectService];
    }
}

/** 连接融云服务器 */
-(void)rcConnectService {
    
    //1.  发条通知,做未读消息更新 (用来切换用户 或 重新登录时,更改tab的小红点)
    if(self.rcConnectCount < 1){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RCKitDispatchMessageNotification" object:nil];
        });
    }
    

    //2.过滤(未登录)
    if (![KKUserInfoMgr isLogin]) { return; }
    
    //过滤(已连接)
    if ([self rcConnectSuccess]) {
        return;
    }
    
    //过滤(次数)
    if (self.rcConnectSuccess == YES ||
        self.rcConnectCount >= 3) {
        return;
    }
    
    //3.获取融云userToken
    WS(weakSelf);
    [[KKRCloudMgr shareInstance] requestRcUserToken:^(BOOL hasError) {
        
        if (hasError) {
            weakSelf.rcConnectCount += 1;
            [weakSelf rcConnectService];
            return ;
        }
        
        //4.主线程执行 连接融云
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.rcConnectCount += 1;
            NSString *rcUserToken = [KKRCloudMgr shareInstance].rcUserToken;
            NSString *cryptKey = [KKNetworkConfig shareInstance].user_cryptKey;
            //解密
            JKEncrypt * encryptObj = [[JKEncrypt alloc]init];
            NSString *decUserToken = [encryptObj doDecEncryptStr:rcUserToken withKey:cryptKey];
            
            [[RCIM sharedRCIM] connectWithToken:decUserToken success:^(NSString *userId) {
                weakSelf.rcConnectSuccess = 1;
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                
            } error:^(RCConnectErrorCode status) {
                weakSelf.rcConnectSuccess = 0;
                [weakSelf rcConnectService];
                NSLog(@"登陆的错误码为:%ld", (long)status);
                
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                weakSelf.rcConnectSuccess = 0;
                [weakSelf rcConnectService];
                NSLog(@"token错误,即将尝试重新连接");
            }];
        });
    }];
}

/** 断开融云服务器, isReceivePush代表是否接收远程推送*/
-(void)rcDisconnect:(BOOL)isReceivePush {
    [[RCIM sharedRCIM] disconnect:isReceivePush];
    self.rcConnectCount = 0;
    self.rcConnectSuccess = NO;
}

/** 请求融云userToken */
-(void)requestRcUserToken:(void (^)(BOOL))finish {
    //1.参数
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:@"RCLOUD_TLS_USER_TOKEN_GET" forKey:@"service"];
    
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^(NSString *error, ResModel *resmodel) {
        
        BOOL hasError = NO;
        if (error) {
            //[CC_NoticeView showError:error];
            hasError = YES;
        }else{
            NSDictionary *responseDic = resmodel.resultDic[@"response"];
            NSDictionary *rcInfoDic = responseDic[@"rCloudInfo"];
            [KKRCloudMgr shareInstance].rcUserId = rcInfoDic[@"userId"];
            [KKRCloudMgr shareInstance].rcAppSdkId = rcInfoDic[@"appSdkId"];
            [KKRCloudMgr shareInstance].rcUserToken = rcInfoDic[@"userToken"];
        }
        
        if (finish) {
            finish(hasError);
        }
    }];
}

#pragma mark - 更新,缓存
/** 清空所有缓存(userInfo,groupInfo,groupUserInfo) */
-(void)rcClearAllCache{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[RCIM sharedRCIM] clearUserInfoCache];
        [[RCIM sharedRCIM] clearGroupInfoCache];
        [[RCIM sharedRCIM] clearGroupUserInfoCache];
        //chatDb
        [[KKChatDbMgr shareInstance] clearAllTableData];
    });
    
}

/** 更新群信息 的本地缓存 */
-(void)updateGroupInfo:(NSString *)groupId {
    
    [self requestGroupInfo:groupId finishBlock:^(ResModel *resModel, KKChatDbModel *dbModel) {
        if (dbModel) {
            //更新本地数据库
            [[KKChatDbMgr shareInstance] saveGroupInfo:dbModel];
            //融云
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = groupId;
            group.groupName = dbModel.name;
            group.portraitUri = dbModel.logoUrl;
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
        }
    }];
    
}

/** 更新user信息 的本地缓存(包括公会号,公会号没"K_"前缀要加上) */
-(void)updateUserInfo:(NSString *)userId {
    
    [self requestUserInfo:userId finishBlock:^(ResModel *resModel, KKChatDbModel *dbModel) {
        if (dbModel) {
            //更新本地数据库
            [[KKChatDbMgr shareInstance] saveUserInfo:dbModel];
            //融云
            RCUserInfo *userInfo = [[RCUserInfo alloc]init];
            userInfo.userId = userId;
            userInfo.name = dbModel.name;
            userInfo.portraitUri =  dbModel.logoUrl;
            [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userId];
        }
    }];
}


#pragma mark - delegate
#pragma mark RCIMConnectionStatusDelegate
/** IMKit连接状态的的监听器 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    CCLOG(@"onRCIMConnectionStatusChanged");
}

#pragma mark user信息源
/** IMKit获user信息 RCIMUserInfoDataSource*/
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {

    CCLOG(@"getUserInfoWithUserId:%@", userId);
    RCUserInfo *user = [RCUserInfo new];
    
    //1.userId错误
    if (userId == nil || [userId length] == 0) {
        user.userId = userId;
        user.portraitUri = @"";
        user.name = @"";
        completion(user);
        return;
    }
    
    //2.查本地数据库
    KKChatDbModel *model = [[KKChatDbMgr shareInstance] getDbUserInfo:userId];
    if(model){
        user.userId = userId;
        user.name = model.name;
        user.portraitUri = model.logoUrl;
        completion(user);
        return;
    }
    
    //3.请求
    [self requestUserInfo:userId finishBlock:^(ResModel *resModel, KKChatDbModel *dbModel) {
        if (dbModel) {
            //保存本地数据库
             [[KKChatDbMgr shareInstance] saveUserInfo:dbModel];
            //赋值
            user.userId = userId;
            user.name = dbModel.name;
            user.portraitUri = dbModel.logoUrl;
            //block
            completion(user);
        }else {
            //赋值
            user.userId = userId;
            user.name = @"";
            user.portraitUri = @"";
            //block
            completion(user);
        }
    }];
}

#pragma mark group信息源
/** IMKit获取群信息 GroupInfoFetcherDelegate */
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    
    RCGroup *group = [RCGroup new];
    
    //1.groupId错误
    if (groupId == nil || [groupId length] == 0) {
        group.groupId = groupId;
        group.portraitUri = @"";
        group.groupName = @"";
        completion(group);
        return;
    }
    
    //2.查本地数据库
    KKChatDbModel *model = [[KKChatDbMgr shareInstance] getDbGroupInfo:groupId];
    if(model){
        group.groupId = groupId;
        group.groupName = model.name;
        group.portraitUri = model.logoUrl;
        completion(group);
        return;
    }
    
    //3.请求
    [self requestGroupInfo:groupId finishBlock:^(ResModel *resModel, KKChatDbModel *dbModel) {
        if (dbModel) {
            //保存本地数据库
            [[KKChatDbMgr shareInstance] saveGroupInfo:dbModel];
            //赋值
            group.groupId = groupId;
            group.groupName = dbModel.name;
            group.portraitUri = dbModel.logoUrl;
            //block
            completion(group);
        }else{
            //赋值
            group.groupId = groupId;
            group.groupName = @"";
            group.portraitUri = @"";
            //block
            completion(group);
        }
    }];
}

/** IMKit获取群成员 */
- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *userIdList))resultBlock {
    
    //1.请求获取userInfo
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GROUP_MEMBER_QUERY" forKey:@"service"];
    [params safeSetObject:groupId forKey:@"groupId"];
    
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        if (!error) {
            //3.请求成功,保存
            NSMutableArray *idArr = [NSMutableArray array];
            NSArray *userArr = resModel.resultDic[@"response"][@"groupUserSimples"];
            for (NSDictionary *userDic in userArr) {
                NSString *idStr = userDic[@"userId"];
                if (idStr.length > 0) {
                    [idArr addObject:idStr];
                }
            }
            
            //4.block
            resultBlock(idArr);
            
        }else {
            //4.block
            resultBlock(nil);
        }
    }];
}

#pragma mark公众号信息源
/** IMKit获取公众号信息 */
- (void)getPublicServiceProfile:(NSString*)accountId completion:(void(^)(RCPublicServiceProfile* profile))completion {
    
    CCLOG(@"getUserInfoWithUserId ----- %@", accountId);
    
    RCPublicServiceProfile *pubInfo = [RCPublicServiceProfile new];
    if (accountId == nil || [accountId length] == 0) {
        completion(pubInfo);
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GUILD_SIMPLE_INFO_QUERY" forKey:@"service"];
    [params safeSetObject:accountId forKey:@"guildId"];
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (!error) {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            pubInfo.publicServiceId = responseDic[@"guildId"];
            pubInfo.name = responseDic[@"guildName"];
            pubInfo.portraitUrl = responseDic[@"guildLogoUrl"];
            //pubInfo.publicServiceId = responseDic[@"guildNo"];
            completion(pubInfo);
            return;
        }
    }];
}

/** 同步返回公众号信息 */
- (RCPublicServiceProfile*)publicServiceProfile:(NSString*)accountId {
    
    RCPublicServiceProfile *pubInfo = [RCPublicServiceProfile new];
    if (accountId == nil || [accountId length] == 0) {
        return pubInfo;
    }
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GUILD_SIMPLE_INFO_QUERY" forKey:@"service"];
    [params safeSetObject:accountId forKey:@"guildId"];
    
    //2.请求
//    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
//        if (!error) {
//            NSDictionary *responseDic = resModel.resultDic[@"response"];
//            pubInfo.publicServiceId = responseDic[@"guildId"];
//            pubInfo.name = responseDic[@"guildName"];
//            pubInfo.portraitUrl = responseDic[@"guildLogoUrl"];
//            //pubInfo.publicServiceId = responseDic[@"guildNo"];
//        }
//        return pubInfo;
//    }];
    
    return pubInfo;
    
}


#pragma mark - request
-(void)requestUserInfo:(NSString *)userId finishBlock:(void (^)(ResModel *resModel, KKChatDbModel *dbModel))block{
    
    //1.是公会号
    BOOL isGuild = [[KKRCloudMgr shareInstance] isGuild:userId];
    NSString *requestUserId = [NSString stringWithFormat:@"%@",userId];
    if (isGuild) {
        requestUserId = [requestUserId substringFromIndex:2];
    }
    
    //2.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (isGuild) {
        [params setObject:@"GUILD_SIMPLE_INFO_QUERY" forKey:@"service"];
        [params safeSetObject:requestUserId forKey:@"guildId"];
    }else{
        [params setObject:@"USER_SIMPLE_INFO_QUERY" forKey:@"service"];
        [params safeSetObject:requestUserId forKey:@"userId"];
    }
    
    //3.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        if (!error) {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            //3.1保存数据库
            KKChatDbModel *model = [[KKChatDbModel alloc]init];
            model.idStr = userId;
            if (isGuild) {
                NSDictionary *infoDic = responseDic;
                model.name = infoDic[@"guildName"];
                model.logoUrl = infoDic[@"guildLogoUrl"];
            }else{
                NSDictionary *infoDic = responseDic[@"userSimple"];
                model.name = infoDic[@"loginName"];
                model.logoUrl = infoDic[@"userLogoUrl"];
            }
           
            //4.block
            block(resModel, model);
            
        }else {
            //4.block
            block(resModel, nil);
        }
        
    }];
}

-(void)requestGroupInfo:(NSString *)groupId finishBlock:(void (^)(ResModel *resModel, KKChatDbModel *dbModel))block{
    
    //1.请求获取userInfo
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GROUP_CHAT_INFO_QUERY" forKey:@"service"];
    [params safeSetObject:groupId forKey:@"groupId"];
    
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        if (!error) {
            //3.请求成功,保存
            NSDictionary *groupDic = resModel.resultDic[@"response"][@"groupChatSimple"];
            KKChatDbModel *model = [[KKChatDbModel alloc]init];
            model.idStr = groupId;
            model.name = groupDic[@"groupName"];
            model.logoUrl = groupDic[@"groupLogoUrl"];
            model.groupMemberNumber = groupDic[@"groupMembers"];
            [[KKChatDbMgr shareInstance] saveGroupInfo:model];
            
            //4.block
            block(resModel, model);
            
        }else {
            //4.block
            block(resModel, nil);
        }
    }];
}


#pragma mark - setter
-(void)setRcUserId:(NSString *)rcUserId {
    _rcUserId = rcUserId;
    [ccs saveDefaultKey:kRcUserId andV:rcUserId];
}

-(void)setRcAppSdkId:(NSString *)rcAppSdkId {
    _rcAppSdkId = rcAppSdkId;
    [ccs saveDefaultKey:kRcAppSdkId andV:rcAppSdkId];
}

-(void)setRcUserToken:(NSString *)rcUserToken {
    _rcUserToken = rcUserToken;
    [ccs saveDefaultKey:kRcUserToken andV:rcUserToken];
}


#pragma mark 工具属性
-(void)setCanPushNotification:(BOOL)canPushNotification {
    _canPushNotification = canPushNotification;
    [RCIM sharedRCIM].disableMessageNotificaiton = !canPushNotification;
    [ccs saveDefaultKey:kRcCanPushNotification andV:@(canPushNotification)];
}

-(void)setCanPlayAlertSound:(BOOL)canPlayAlertSound {
    _canPlayAlertSound = canPlayAlertSound;
    [RCIM sharedRCIM].disableMessageAlertSound = !canPlayAlertSound;
    [ccs saveDefaultKey:kRcCanPlayAlertSound andV:@(canPlayAlertSound)];
}


@end
