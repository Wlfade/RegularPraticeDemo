//
//  KKLikeOrCancelLikeQuery.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/28.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKLikeOrCancelLikeQuery.h"

@implementation KKLikeOrCancelLikeQuery
+ (void)requestIsClickLike:(BOOL)liked withLikeCount:(NSInteger)likeCount withObjectId:(NSString *)objectId withType:(NSString *)typeStr withFinish:(void(^)(BOOL,NSInteger))complete{
    NSString *serviceStr = @"";
    if (liked == YES) {
        serviceStr = @"CANCEL_LIKE";
    }else{
        serviceStr = @"LIKE";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:objectId forKey:@"objectId"];
    [params setObject:serviceStr forKey:@"service"];
    [params safeSetObject:typeStr forKey:@"likeObjectType"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            complete(!liked,likeCount);
        }
    }];
}


@end
