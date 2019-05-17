//
//  KKAddFriendViewModel.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKAddFriendViewModel.h"

@implementation KKAddFriendViewModel

-(void)triggerRequest{
    
    NSString *userId = [KKUserInfoMgr shareInstance].userId?:@"";
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"SEARCH_BY_CELL"  forKey:@"service"];
//    [params setValue:userId             forKey:@"authedUserId"];6201807200000021
//    [params setValue:self.phoneNum?:@"" forKey:@"cell"];
    //测试数据
    [params setValue:@"6201807200000021" forKey:@"authedUserId"];
    [params setValue:@"13330000000" forKey:@"cell"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else {
            if(resModel.resultDic[@"response"][@"userId"]){
                [weakSelf requestUserInfoWithId:resModel.resultDic[@"response"][@"userId"]];
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
@end
