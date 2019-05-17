//
//  KKDiscoverService.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKDiscoverService.h"
#import "KKApplicationInfo.h"

@implementation KKDiscoverService
+ (void)requestMyWebAppSuccess:(requestWebAppBlockSuccess)success Fail:(requestWebAppBlockFail)fail {

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
            }else {            
                [applicationList addObjectsFromArray:[KKApplicationInfo mj_objectArrayWithKeyValuesArray:temp]];
                success(applicationList);
            }
        }
    }];
}
@end
