//
//  COMMENT_CREATE_BEFORE_QUERY.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/1.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "COMMENT_CREATE_BEFORE_QUERY.h"

@implementation COMMENT_CREATE_BEFORE_QUERY
+ (void)requestCommentCountComplete:(void(^)(NSInteger))complete{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"COMMENT_CREATE_BEFORE_QUERY" forKey:@"service"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            
//            resultModel
            NSNumber *commentContentLength = resultModel.resultDic[@"response"][@"commentContentLength"];
            
//            return commentContentLength.integerValue;
            complete(commentContentLength.integerValue);
        }
    }];
}
@end
