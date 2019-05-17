//
//  KKAddFriendViewModel.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKAddFriendViewModel.h"
#import "KKAddFriendModel.h"
#import "JCUMServes.h"
#import "JCValidation.h"

@implementation KKAddFriendViewModel

-(void)triggerRequest{
    
    if(![JCValidation checkTelNumber:self.phoneNum]){
        [CC_NoticeView showError:@"请输入好友正确手机号"];
        return;
    }
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"SEARCH_BY_CELL"  forKey:@"service"];
    [params setValue:userId             forKey:@"authedUserId"];
    [params setValue:self.phoneNum?:@"" forKey:@"cell"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (!resModel.resultDic[@"response"][@"success"]){
            [CC_NoticeView showError:str];
        }else {
            if(resModel.resultDic[@"response"]){
                KKAddFriendModel *model = [KKAddFriendModel mj_objectWithKeyValues:resModel.resultDic[@"response"]];
                self.model = model;
                if(weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(layoutData:)]){
                    [weakSelf.delegate performSelector:@selector(layoutData:) withObject:model];
                }
            }
        }
    }];
}

/** request获取用户信息 */
-(void)requestUserInfoWithId:(NSString *)userId{
    //1.参数
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    [para setObject:@"MY_USER_INFO_QUERY" forKey:@"service"];
    [para setObject:userId forKey:@"authedUserId"];
    WS(weakSelf)
    //2.请求
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:para model:nil finishCallbackBlock:^void(NSString *error, ResModel *resmodel) {
        if (error) {
            [CC_NoticeView showError:error];
        }else{
            NSDictionary *responseDic = resmodel.resultDic[@"response"];
            
            NSMutableDictionary *clientDic = [NSMutableDictionary dictionaryWithDictionary:responseDic[@"userInfoClient"]];
            [clientDic safeSetObject:responseDic[@"userMemo"] forKey:@"userMemo"];
            [clientDic safeSetObject:responseDic[@"userLogoUrl"] forKey:@"userLogoUrl"];
            [clientDic safeSetObject:responseDic[@"location"] forKey:@"location"];
            [clientDic safeSetObject:responseDic[@"validateIdentity"] forKey:@"validateIdentity"];
            [clientDic safeSetObject:responseDic[@"userLogoUrl"] forKey:@"userLogoUrl"];
            if(weakSelf.delegate&&[weakSelf.delegate respondsToSelector:@selector(layoutData:)]){
                [weakSelf.delegate performSelector:@selector(layoutData:) withObject:[KKUserInfoModel mj_objectWithKeyValues:clientDic]];
            }
        }
    }];
}

-(void)triggerShareToWeChat{
    
    [[JCUMServes shareInstance] shareUserInfoToWeChat:@"KK部落邀请链接"
                                              content:@"加入KK，畅想世界"
                                               webUrl:self.model.weixin_url
                                              Success:^(UMSocialUserInfoResponse *success) {
//                                                  NSLog(success);
                                                [CC_NoticeView showError:@"分享成功"];
                                              } failure:^(NSString *failure) {
//                                                  NSLog(failure);
                                                  [CC_NoticeView showError:failure];
                                              }];
}
@end
