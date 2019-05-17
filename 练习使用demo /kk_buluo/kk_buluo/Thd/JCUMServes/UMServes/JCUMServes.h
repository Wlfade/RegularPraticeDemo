//
//  JCUMServes.h
//  ToCLittleCircle
//
//  Created by 樊星 on 2017/12/14.
//  Copyright © 2017年 trioly.com. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>

@interface JCUMServes : NSObject

+ (id)shareInstance;

- (void)authWithPlatform:(UMSocialPlatformType)platformType
                 success:(void(^)(UMSocialUserInfoResponse *success)) successBlock
                 failure:(void(^)(NSString *failure)) failureBlock;

- (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType
                       success:(void(^)(UMSocialUserInfoResponse *success)) successBlock
                       failure:(void(^)(NSString *failure)) failureBlock;

- (void)shareUserInfoToWeChat:(NSString *)title
                      content:(NSString *)content
                       webUrl:(NSString *)webUrl
                      Success:(void(^)(UMSocialUserInfoResponse *success)) successBlock
                      failure:(void(^)(NSString *failure)) failureBlock;
@end
