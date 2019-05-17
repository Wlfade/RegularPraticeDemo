//
//  KKDiscoverService.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKWebAppService.h"
#import "KKApplicationInfo.h"
#import "KKWepAppAboutDetailInfo.h"
#import "KKWebAppMoreInfo.h"

@interface KKWebAppService()

@end

@implementation KKWebAppService

static KKWebAppService *webAppService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        webAppService = [[KKWebAppService alloc] init];
    });
    return webAppService;
}

+ (void)requestWebAppSuccess:(requestWebAppBlockSuccess)success Fail:(requestWebAppBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"MY_APPLICATION_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSMutableArray *applicationList = [NSMutableArray array];
            NSMutableArray *temp = [NSMutableArray array];
            temp = responseDic[@"applicationList"];
            if (temp.count == 0) {
                [CC_NoticeView showError:@"暂无应用"];
                fail();
            }else {            
                [applicationList addObjectsFromArray:[KKApplicationInfo mj_objectArrayWithKeyValuesArray:temp]];
                success(applicationList);
            }
        }
    }];
}
+ (void)requestDiscoverListWebAppSuccess:(requestDiscoverWebAppBlockSuccess)success{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"APPLICATION_LIST_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSMutableArray *applicationList = [NSMutableArray array];
            NSMutableArray *temp = [NSMutableArray array];
            temp = responseDic[@"applicationList"];
            if (temp.count == 0) {
                [CC_NoticeView showError:@"暂无应用"];
            }else {
                [applicationList addObjectsFromArray:[KKApplicationInfo mj_objectArrayWithKeyValuesArray:temp]];
                success(applicationList);
            }
        }
    }];
}

+ (void)requestWebAppUserAuthStatusSuccess:(requestWebAppAuthStatusBlockSuccess)success Fail:(requestWebAppAuthStatusBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_AUTHORIZE_QUERY" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].appId forKey:@"appId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSString *authorize = responseDic[@"authorize"];
        NSString *code = responseDic[@"code"];
        NSString *authorizeIntro = responseDic[@"authorizeIntro"];

        if (str) {
            fail(authorize); /// 用户没有授权
        }else {
            success(authorize, code, authorizeIntro);
        }
    }];
}

+ (void)requestWebAppAuthSuccess:(requestWebAppAuthBlockSuccess)success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_AUTHORIZE" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].appId forKey:@"appId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            /// 用户没有授权
            NSString *code = responseDic[@"code"];
            success(code);
        }
    }];
}

+ (void)requestWebAppAddToMyCollecttionSuccess:(requestWebAppAddBlockSuccess)success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"CREATE_COLLECT" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].objectId forKey:@"objectId"];
    [params setValue:[KKWebAppService shareInstance].objectType forKey:@"objectType"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            [CC_NoticeView showError:@"添加成功"];
            if (success != nil) {
                success();
            }
        }
    }];
}

+ (void)requestWebAppDeleteToMyCollecttionSuccess:(requestWebAppDeleteBlockSuccess)success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"CANCEL_COLLECT" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].objectId forKey:@"objectId"];
    [params setValue:[KKWebAppService shareInstance].objectType forKey:@"objectType"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            [CC_NoticeView showError:@"移除成功"];
            if (success != nil) {
                success();
            }
        }
    }];
}

+ (void)requestAboutWebAppDetailDataSuccess:(requestWebAppDetailDataBlockSuccess)success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"APPLICATION_DETAILS_QUERY" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].appId forKey:@"applicationId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSMutableArray *guildList = [NSMutableArray array];
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            [guildList addObjectsFromArray:[KKWepAppAboutDetailInfo mj_objectArrayWithKeyValuesArray:responseDic[@"guildList"]]];
            KKApplicationInfo *appInfo = [KKApplicationInfo mj_objectWithKeyValues:responseDic[@"application"]];
            success(guildList, appInfo);
        }
    }];
}

+ (void)requestGuildRelevanceWebAppDataSuccess:(requestGuildRelevanceWebAppDataBlockSuccess)success Fail:(requestGuildRelevanceWebAppDataBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GUILD_APPLICATION_QUERY" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].guildId forKey:@"guildId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            KKApplicationInfo *appInfo = [KKApplicationInfo mj_objectWithKeyValues:responseDic[@"application"]];
            if (appInfo) {
                success(appInfo);
            }else {
                if (fail != nil) {
                    fail();
                }
            }
        }
    }];
}

+ (void)requestWebAppMoreInfoDataSuccess:(requestWebAppMoreInfoDataBlockSuccess)success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"APPLICATION_INFORMATION_QUERY" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].appId forKey:@"applicationId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            KKWebAppMoreInfo *moreInfo = [KKWebAppMoreInfo mj_objectWithKeyValues:responseDic];
            success(moreInfo);
        }
    }];
}

+ (void)requestGuildAboutGroupDataSuccess:(requestGuildAboutGroupBlockSuccess)success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"GUILD_GROUP_QUERY" forKey:@"service"];
    [params setValue:[KKWebAppService shareInstance].guildId forKey:@"guildId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSMutableArray *guildList = [NSMutableArray array];
            [guildList addObjectsFromArray:[KKWepAppAboutDetailInfo mj_objectArrayWithKeyValuesArray:responseDic[@"groups"]]];
            success(guildList);
        }
    }];
}
@end
