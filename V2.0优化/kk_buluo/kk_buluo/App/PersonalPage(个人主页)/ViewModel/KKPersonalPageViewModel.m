//
//  KKPersonalPageViewModel.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKPersonalPageViewModel.h"
#import "KKPersonalPageModel.h"
#import "KKDynamicWholeItem.h"

@interface KKPersonalPageViewModel()
@property (nonatomic, strong) NSMutableArray *topicList;
@end

@implementation KKPersonalPageViewModel

-(NSMutableArray *)topicList{
    if(!_topicList){
        _topicList = [NSMutableArray array];
    }
    return _topicList;
}

-(instancetype)init{
    if(self = [super init]){
        self.pageNum = 1;
    }
    return self;
}

-(void)requestUserInfo{
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.personalPageType == PERSONAL_PAGE_OTHER
       ||self.personalPageType == PERSONAL_PAGE_OWNER){//个人主页
        [params setValue:@"USER_HOME_INDEX" forKey:@"service"];
        [params safeSetObject:self.userId   forKey:@"userId"];
    }else if(self.personalPageType == PERSONAL_PAGE_GUILD){//公会号主页
        [params setValue:@"GUILD_HOME_QUERY" forKey:@"service"];
        [params safeSetObject:self.userId forKey:@"guildId"];
    }else if(self.personalPageType == PERSONAL_PAGE_GROUP){//群主页
        [params setValue:@"GROUP_CHAT_HOME_QUERY" forKey:@"service"];
        [params safeSetObject:self.userId forKey:@"groupId"];
    }
    [params setValue:userId forKey:@"authedUserId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            if(self.personalPageType != PERSONAL_PAGE_GUILD){            
                [CC_NoticeView showError:str];
            }else {
                if ([weakSelf.delegate respondsToSelector:@selector(getGuildHomeSubjectQueryFail)]) {
                    [weakSelf.delegate getGuildHomeSubjectQueryFail];
                }
            }
        }else {
            if(resModel.resultDic[@"response"]){
                
                KKPersonalPageModel *model = [KKPersonalPageModel mj_objectWithKeyValues:resModel.resultDic[@"response"]];
                if(self.personalPageType == PERSONAL_PAGE_GUILD){
                    model.userName = resModel.resultDic[@"response"][@"guildSimple"][@"guildName"];
                    model.memo = resModel.resultDic[@"response"][@"guildSimple"][@"memo"];
                    model.userLogoUrl = resModel.resultDic[@"response"][@"guildSimple"][@"guildLogoUrl"];
                    model.guildCert = resModel.resultDic[@"response"][@"guildSimple"][@"guildCert"];
                    
                }else if(self.personalPageType == PERSONAL_PAGE_GROUP){
                    model.userName = resModel.resultDic[@"response"][@"groupChatSimple"][@"groupName"];
                    model.memo = resModel.resultDic[@"response"][@"groupChatSimple"][@"memo"];
                    model.userLogoUrl = resModel.resultDic[@"response"][@"groupChatSimple"][@"groupLogoUrl"];
                }
                if(weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(layoutUserInfoData:)]){
                    [weakSelf.delegate performSelector:@selector(layoutUserInfoData:) withObject:model];
                }
            }
        }
    }];
}

-(void)addFriendRequest{
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
//    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"ADD_FRIEND" forKey:@"service"];
    [params setValue:userId forKey:@"authedUserId"];
    [params setValue:userId forKey:@"applyUserId"];
    [params setValue:self.userId forKey:@"recieveUserId"];
    [params setValue:@"你好"             forKey:@"validateMessage"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            if(resModel.resultDic[@"response"][@"success"]){
                [CC_NoticeView showError:@"发送成功"];
            }
        }
    }];
}

-(void)deleteFriendRequest{
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    //    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"DELETE_FRIEND" forKey:@"service"];
    [params setValue:userId forKey:@"authedUserId"];
    [params setValue:self.userId forKey:@"friendId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            if(resModel.resultDic[@"response"][@"success"]){
                [CC_NoticeView showError:@"删除成功"];
            }
        }
    }];
}

-(void)addAttentionRequest{
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
    if(self.personalPageType == PERSONAL_PAGE_OTHER
       ||self.personalPageType == PERSONAL_PAGE_OWNER){
        [params setValue:@"USER" forKey:@"subscribeType"];
    }else if(self.personalPageType == PERSONAL_PAGE_GUILD){
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }
    [params setValue:userId forKey:@"authedUserId"];
    [params setValue:self.userId forKey:@"objectId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            if(resModel.resultDic[@"response"][@"success"]){
                [CC_NoticeView showError:@"关注成功"];
                [weakSelf requestUserInfo];
            }
        }
    }];
}

-(void)cancelAttentionRequest{
    
//    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CANCEL" forKey:@"service"];
    if(self.personalPageType == PERSONAL_PAGE_OTHER
       ||self.personalPageType == PERSONAL_PAGE_OWNER){
        [params setValue:@"USER" forKey:@"subscribeType"];
    }else if(self.personalPageType == PERSONAL_PAGE_GUILD){
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }
    [params setValue:self.userId forKey:@"objectId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            if(resModel.resultDic[@"response"][@"success"]){
                [CC_NoticeView showError:@"取消成功"];
                KKPersonalPageModel *model = [[KKPersonalPageModel alloc] init];
                model.focus = 0;
                if(weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(layoutUserInfoData:)]){
                    [weakSelf.delegate performSelector:@selector(layoutUserInfoData:) withObject:model];
                }
                [weakSelf requestUserInfo];
            }
        }
    }];
}

-(void)applyInGroup{
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
//    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_APPLY_JOIN_GROUP" forKey:@"service"];
    [params setValue:userId forKey:@"authedUserId"];
    [params setValue:self.userId forKey:@"groupId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            if(resModel.resultDic[@"response"][@"success"]){
//                [CC_NoticeView showError:@"取消成功"];
//                [weakSelf requestUserInfo];
            }
        }
    }];
}

-(void)requestDynamicList{
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.personalPageType == PERSONAL_PAGE_OTHER){//如果是他人个人主页
        [params setValue:@"MY_FOLLOW_TOPIC_QUERY" forKey:@"service"];
        [params setValue:self.userId forKey:@"userId"];
    }else if(self.personalPageType == PERSONAL_PAGE_OWNER){//如果是自己个人主页
         [params setValue:@"MY_FOLLOW_TOPIC_QUERY" forKey:@"service"];
        [params setValue:userId forKey:@"userId"];
    }else if(self.personalPageType == PERSONAL_PAGE_GUILD){
        [params setValue:@"GUILD_HOME_SUBJECT_QUERY" forKey:@"service"];
        [params setValue:self.userId forKey:@"guildId"];
    }else if(self.personalPageType == PERSONAL_PAGE_GROUP){
        [params setObject:@"GROUP_CHAT_CHANNEL_SUBJECT_QUERY" forKey:@"service"];
        [params setObject:self.userId forKey:@"groupId"];
    }
    [params setValue:userId forKey:@"authedUserId"];
    [params setValue:self.userId forKey:@"objectId"];
    
    [params setObject:@(self.pageNum?:1) forKey:@"currentPage"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resultModel) {
        if (str) {
            if (self.personalPageType == PERSONAL_PAGE_GUILD) {
//                if ([weakSelf.delegate respondsToSelector:@selector(getGuildHomeSubjectQueryFail)]) {
//                    [weakSelf.delegate getGuildHomeSubjectQueryFail];
//                }
            }else {
                [CC_NoticeView showError:str];
            }
        }else {
           
            if(weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(layoutTopicListData:)]){
                [weakSelf.delegate performSelector:@selector(layoutTopicListData:) withObject:resultModel];
            }
        }
    }];
}
@end
