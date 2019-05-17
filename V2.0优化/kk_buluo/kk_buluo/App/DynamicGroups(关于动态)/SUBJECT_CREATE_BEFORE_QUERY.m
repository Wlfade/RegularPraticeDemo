//
//  SUBJECT_CREATE_BEFORE_QUERY.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "SUBJECT_CREATE_BEFORE_QUERY.h"
#import "KKSubjectLengthConfig.h"

@implementation SUBJECT_CREATE_BEFORE_QUERY
+ (void)requestSubjectComplete:(void(^)(KKSubjectLengthConfig *))complete{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"SUBJECT_CREATE_BEFORE_QUERY" forKey:@"service"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:resultModel.resultDic[@"response"][@"subejctContentLengthConfigMap"]];
            [mutDict setValue:resultModel.resultDic[@"response"][@"transmitContentLength"] forKey:@"transmitContentLength"];
            
            KKSubjectLengthConfig *configModel = [KKSubjectLengthConfig mj_objectWithKeyValues:mutDict];
            
            NSInteger max = configModel.personal.maxTitleLength;
            
            NSLog(@"%ld",max);
            complete(configModel);
        }
    }];
}

@end
