//
//  KKDyManagerViewModel.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyManagerViewModel.h"
#import "KKDynamicWholeItem.h"

#import "KKWriteDateToPath.h"

@implementation KKDyManagerViewModel
+ (void)requestMyFollowTopicQuery:(NSNumber *)currentPage complete:(void(^)(NSString *, ResModel *, NSMutableArray *))completeBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params setObject:@"MY_FOLLOW_TOPIC_QUERY" forKey:@"service"];
    [params safeSetObject:@"1" forKey:@"showFollowers"];
    
    [params setObject:currentPage forKey:@"currentPage"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        if (errorStr) {
//            [CC_NoticeView showError:errorStr];
            completeBlock(errorStr,resultModel,nil);
        }else{
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];

//            [KKWriteDateToPath writeDataToFilePath:@"/Users/danche/Desktop/数据Plist文件夹/MY_FOLLOW_TOPIC_QUERY.plist" withData:resultDic];
            
            //取出动态数组
            NSArray *topicSimpleList = [NSArray arrayWithArray:responseDic[@"topicSimpleList"]];
            
            
            NSMutableArray *listTempArr = [NSMutableArray arrayWithCapacity:topicSimpleList.count];
            for (int i = 0; i<topicSimpleList.count; i ++) {
                NSDictionary *dynamicDict = topicSimpleList[i];
                KKDynamicWholeItem *dynamicWholeItem = [KKDynamicWholeItem makeTheDynamicItemWithDictionary:dynamicDict];
                [listTempArr addObject:dynamicWholeItem];
            }
            
            completeBlock(nil,resultModel,listTempArr);
        }
    }];
}

+ (void)requestAllGuileSubjectQuery:(NSNumber *)currentPage complete:(void(^)(NSString *, ResModel *, NSMutableArray *))completeBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ALL_GUILD_SUBJECT_QUERY" forKey:@"service"];
    
    [params setObject:currentPage forKey:@"currentPage"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        if (errorStr) {
            //            [CC_NoticeView showError:errorStr];
            completeBlock(errorStr,resultModel,nil);
        }else{
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
//            [KKWriteDateToPath writeDataToFilePath:@"/Users/danche/Desktop/数据Plist文件夹/ALL_GUILD_SUBJECT_QUERY.plist" withData:resultDic];
            
            //取出动态数组
            NSArray *topicSimpleList = [NSArray arrayWithArray:responseDic[@"topicSimpleList"]];
            
            
            NSMutableArray *listTempArr = [NSMutableArray arrayWithCapacity:topicSimpleList.count];
            for (int i = 0; i<topicSimpleList.count; i ++) {
                NSDictionary *dynamicDict = topicSimpleList[i];
                KKDynamicWholeItem *dynamicWholeItem = [KKDynamicWholeItem makeTheDynamicItemWithDictionary:dynamicDict];
                [listTempArr addObject:dynamicWholeItem];
            }
            
            completeBlock(nil,resultModel,listTempArr);
        }
    }];
}
+ (void)requestHotSubjectQuery:(NSNumber *)currentPage complete:(void(^)(NSString *, ResModel *, NSMutableArray *))completeBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"HOT_SUBJECT_QUERY" forKey:@"service"];
    
    [params setObject:currentPage forKey:@"currentPage"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        if (errorStr) {
            //            [CC_NoticeView showError:errorStr];
            completeBlock(errorStr,resultModel,nil);
        }else{
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
//            [KKWriteDateToPath writeDataToFilePath:@"/Users/danche/Desktop/数据Plist文件夹/HOT_SUBJECT_QUERY.plist" withData:resultDic];
            
            //取出动态数组
            NSArray *topicSimpleList = [NSArray arrayWithArray:responseDic[@"topicSimpleList"]];
            
            
            NSMutableArray *listTempArr = [NSMutableArray arrayWithCapacity:topicSimpleList.count];
            for (int i = 0; i<topicSimpleList.count; i ++) {
                NSDictionary *dynamicDict = topicSimpleList[i];
                KKDynamicWholeItem *dynamicWholeItem = [KKDynamicWholeItem makeTheDynamicItemWithDictionary:dynamicDict];
                [listTempArr addObject:dynamicWholeItem];
            }
            
            completeBlock(nil,resultModel,listTempArr);
        }
    }];

}

+ (void)requstToAttentionTypeName:(NSString *)typeName withUserId:(NSString *)userId withComplete:(void(^)(bool))complete{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_FOLLOW_CREATE" forKey:@"service"];
    if ([typeName isEqualToString:@"GUILD_INDEX"]) {
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }else {
        [params setValue:@"USER" forKey:@"subscribeType"];
    }
    [params setValue:userId forKey:@"objectId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_NoticeView showError:str];
        }else{
            [CC_NoticeView showError:@"关注成功"];
            complete(YES);
        }
    }];
}

+ (void)requstDeleteDynamicSubjectId:(NSString *)subjectId complete:(void(^)(void))complete{
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"SUBJECT_DELETE" forKey:@"service"];
    [params safeSetObject:subjectId forKey:@"subjectId"];
    
    //2.请求
    //    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        //        [HUD stop];
        
        if (error) {
            [CC_NoticeView showError:error];
        }else{
            complete();
        }
    }];
}
@end
