//
//  AppDelegate.m
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "AppDelegate.h"
#import "KKRootContollerMgr.h"
#import "KKNetworkConfig.h"
#import <UMSocialCore/UMSocialCore.h>
#import <RongIMKit/RongIMKit.h>
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSURLProtocol registerClass:NSClassFromString(@"CustomURLProtocol")];
    
    //如果有小红点,就去掉
    application.applicationIconBadgeNumber = 0;
    
    //1.rootVC
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [KKRootContollerMgr loadRootVC:launchOptions];
    
    //2.tableV在iOS11以上的设置
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    UITableView.appearance.separatorColor = COLOR_GRAY_LINE;
    
    //3.定标准尺寸
    [[CC_UIHelper getInstance]initUIDemoWidth:375 andHeight:667];
    
    //4.域名和网络配置
    [self getDomainConfigure];
    
    //5.配置融云
    [[KKRCloudMgr shareInstance] rcConfig];
    
    //6.配置友盟分享
    [self confiUMSDK];
    
    //7.配置bugly
    [Bugly startWithAppId:@"52690e52ff"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //关闭通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // 登陆状态下为消息分享保存会话信息
    if([RCIMClient sharedRCIMClient].getConnectionStatus == ConnectionStatus_Connected){
        [self saveConversationInfoForMessageShare];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] == ConnectionStatus_Connected) {
        // 插入分享消息
        [self insertSharedMessageIfNeed];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //1.通知
    //1.1 需要签名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationLoginStatusAbnormal:) name:NOTIFICATION_PRESENT_LOGINVC_SIGN_REQUIRED object:nil];
    //1.2 异地登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacationLoginStatusAbnormal:) name:NOTIFICATION_PRESENT_LOGINVC_LOGIN_ELSE object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}

#pragma mark - 融云

//插入分享消息
- (void)insertSharedMessageIfNeed {
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    
    NSArray *sharedMessages = [shareUserDefaults valueForKey:@"sharedMessages"];
    if (sharedMessages.count > 0) {
        for (NSDictionary *sharedInfo in sharedMessages) {
            RCRichContentMessage *richMsg = [[RCRichContentMessage alloc] init];
            richMsg.title = [sharedInfo objectForKey:@"title"];
            richMsg.digest = [sharedInfo objectForKey:@"content"];
            richMsg.url = [sharedInfo objectForKey:@"url"];
            richMsg.imageURL = [sharedInfo objectForKey:@"imageURL"];
            richMsg.extra = [sharedInfo objectForKey:@"extra"];
            //      long long sendTime = [[sharedInfo objectForKey:@"sharedTime"] longLongValue];
            //      RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:[[sharedInfo
            //      objectForKey:@"conversationType"] intValue] targetId:[sharedInfo objectForKey:@"targetId"]
            //      sentStatus:SentStatus_SENT content:richMsg sentTime:sendTime];
            RCMessage *message = [[RCIMClient sharedRCIMClient]
                                  insertOutgoingMessage:[[sharedInfo objectForKey:@"conversationType"] intValue]
                                  targetId:[sharedInfo objectForKey:@"targetId"]
                                  sentStatus:SentStatus_SENT
                                  content:richMsg];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RCDSharedMessageInsertSuccess" object:message];
        }
        [shareUserDefaults removeObjectForKey:@"sharedMessages"];
        [shareUserDefaults synchronize];
    }
}

//为消息分享保存会话信息
- (void)saveConversationInfoForMessageShare {
    NSArray *conversationList =
    [[RCIMClient sharedRCIMClient] getConversationList:@[ @(ConversationType_PRIVATE), @(ConversationType_GROUP) ]];
    
    NSMutableArray *conversationInfoList = [[NSMutableArray alloc] init];
    if (conversationList.count > 0) {
        for (RCConversation *conversation in conversationList) {
            NSMutableDictionary *conversationInfo = [NSMutableDictionary dictionary];
            [conversationInfo setValue:conversation.targetId forKey:@"targetId"];
            [conversationInfo setValue:@(conversation.conversationType) forKey:@"conversationType"];
            if (conversation.conversationType == ConversationType_PRIVATE) {
                RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:conversation.targetId];
                [conversationInfo setValue:user.name forKey:@"name"];
                [conversationInfo setValue:user.portraitUri forKey:@"portraitUri"];
            } else if (conversation.conversationType == ConversationType_GROUP) {
                RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:conversation.targetId];
                [conversationInfo setValue:group.groupName forKey:@"name"];
                [conversationInfo setValue:group.portraitUri forKey:@"portraitUri"];
            }
            [conversationInfoList addObject:conversationInfo];
        }
    }
    NSURL *sharedURL = [[NSFileManager defaultManager]
                        containerURLForSecurityApplicationGroupIdentifier:@"group.cn.rongcloud.im.share"];
    NSURL *fileURL = [sharedURL URLByAppendingPathComponent:@"rongcloudShare.plist"];
    [conversationInfoList writeToURL:fileURL atomically:YES];
    
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.rongcloud.im.share"];
    [shareUserDefaults setValue:[RCIM sharedRCIM].currentUserInfo.userId forKey:@"currentUserId"];
    [shareUserDefaults setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"] forKey:@"Cookie"];
    [shareUserDefaults synchronize];
}

#pragma mark - 友盟
-(void)confiUMSDK{
    //友盟配置
    [[UMSocialManager defaultManager] openLog:YES]; //打开日志
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO; //打开图片水印
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO; //关闭https
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5c94c8da61f5647fa1000045"]; //设置友盟appkey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7a375905493d4be9" appSecret:@"b923f78beab716e42ed8be588790e3d3" redirectURL:nil]; //微信
    //   [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APP_ID appSecret:QQ_APP_KEY redirectURL:nil]; //QQ
}


#pragma mark - 域名,网络配置
-(void)getDomainConfigure {
    //1.域名
    [KKNetworkConfig shareInstance].domainStr = @"http://mapi1.kknew.net";//测试
//    [KKNetworkConfig shareInstance].domainStr = @"http://mapi.newkk.kkbuluo.com";//正式
    
    //2.网络配置 (在配置user签名时会 请求连接融云)
    [KKNetworkConfig configNetWork];
}

#pragma mark - 通知(需登录)
/** 登录状态异常 通知 */
-(void)notifacationLoginStatusAbnormal:(NSNotification *)notification {
    
    //登录alert在某段时间已提醒过了
    static BOOL alertedInDuration = NO;
    //该时段的长度
    static int alertDuration = 30;
    
    //1.重复判断 (oneAuth和user签名,都会触发这些通知,避免重复alert)
    if(alertedInDuration){
        return;
    }
    
    //2.alert
    NSString *msg = @"";
    if ([notification.name isEqualToString:NOTIFICATION_PRESENT_LOGINVC_LOGIN_ELSE]) {
        msg = @"账号已在其他设备登录";
    }else if ([notification.name isEqualToString:NOTIFICATION_PRESENT_LOGINVC_SIGN_REQUIRED]){
        msg = @"请登录";
    }
    if (msg.length < 1) {
        return ;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
    //3.倒计时
    alertedInDuration = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(alertDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        alertedInDuration = NO;
    });
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //清除数据
    [[KKUserInfoMgr shareInstance] logoutAndSetNil:nil];
}

@end
