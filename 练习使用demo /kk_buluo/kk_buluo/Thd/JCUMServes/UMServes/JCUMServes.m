//
//  JCUMServes.m
//  ToCLittleCircle
//
//  Created by 樊星 on 2017/12/14.
//  Copyright © 2017年 trioly.com. All rights reserved.
//

#import "JCUMServes.h"

@implementation JCUMServes

static  JCUMServes *_service;

+ (id)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _service = [[self alloc] init];
    });
    return _service;
}

- (void)authWithPlatform:(UMSocialPlatformType)platformType
                 success:(void(^)(UMSocialUserInfoResponse *success)) successBlock
                 failure:(void(^)(NSString *failure)) failureBlock{

    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:@"" completion:^(id result, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"Get info fail:\n%@", error];
            UMSocialLogInfo(@"Get info fail with error %@",error);
            failureBlock(message);
        }else{
            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                UMSocialUserInfoResponse *resp = result;
                successBlock(resp);
            }else{
                message = @"Get info fail";
                failureBlock(message);
            }
        }
    }];
}

- (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType
                 success:(void(^)(UMSocialUserInfoResponse *success)) successBlock
                 failure:(void(^)(NSString *failure)) failureBlock{
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        NSString *message = nil;
        successBlock(result);
//        if (error) {
//            message = [NSString stringWithFormat:@"Get info fail:\n%@", error];
//            UMSocialLogInfo(@"Get info fail with error %@",error);
//            failureBlock(message);
//        }else{
//            if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
//                UMSocialUserInfoResponse *resp = result;
//                successBlock(resp);
//            }else{
//                message = @"Get info fail";
//                failureBlock(message);
//            }
//        }
        
        
        
    
    }];
}

- (void)shareUserInfoToWeChat:(NSString *)title
                      content:(NSString *)content
                       webUrl:(NSString *)webUrl
                      Success:(void(^)(UMSocialUserInfoResponse *success)) successBlock
                      failure:(void(^)(NSString *failure)) failureBlock{
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title
                                                                             descr:content
                                                                         thumImage:[UIImage imageNamed:@"share_logo_image"]];
    //设置网页地址
    shareObject.webpageUrl = webUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession  messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            if([error.userInfo[@"message"] isEqualToString:@"APP Not Install"]){
                failureBlock(@"您未安装微信");
            }
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (NSString *)authInfoString:(UMSocialUserInfoResponse *)resp{
    
    NSMutableString *string = [NSMutableString new];
    if (resp.uid) {
        [string appendFormat:@"uid = %@\n", resp.uid];
    }
    if (resp.openid) {
        [string appendFormat:@"openid = %@\n", resp.openid];
    }
    if (resp.unionId) {
        [string appendFormat:@"unionId = %@\n", resp.unionId];
    }
    if (resp.usid) {
        [string appendFormat:@"usid = %@\n", resp.usid];
    }
    if (resp.accessToken) {
        [string appendFormat:@"accessToken = %@\n", resp.accessToken];
    }
    if (resp.refreshToken) {
        [string appendFormat:@"refreshToken = %@\n", resp.refreshToken];
    }
    if (resp.expiration) {
        [string appendFormat:@"expiration = %@\n", resp.expiration];
    }
    if (resp.name) {
        [string appendFormat:@"name = %@\n", resp.name];
    }
    if (resp.iconurl) {
        [string appendFormat:@"iconurl = %@\n", resp.iconurl];
    }
    if (resp.unionGender) {
        [string appendFormat:@"gender = %@\n", resp.unionGender];
    }
    return string;
}
@end
