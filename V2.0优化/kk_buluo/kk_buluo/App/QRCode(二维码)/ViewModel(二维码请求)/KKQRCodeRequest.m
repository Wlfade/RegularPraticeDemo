//
//  KKQRCodeRequest.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/26.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKQRCodeRequest.h"
#import "KKQRCodeItem.h"
#import "KKWriteDateToPath.h"

@implementation KKQRCodeRequest
#pragma mark - USER_QRCODE_QUERY 个人二维码数据请求
/* 个人用户的 二维码数据请求 */
+ (void)myQRCoderequest:(void(^)(KKQRCodeItem *))complete{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"USER_QRCODE_QUERY" forKey:@"service"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            NSDictionary *response = resultModel.resultDic[@"response"];
//            [KKWriteDateToPath writeDataToFilePath:@"/Users/danche/Desktop/数据Plist文件夹/USER_QRCODE_QUERY.plist" withData:response];
            
            KKQRCodeItem *codeItem = [KKQRCodeItem QRCodeWithDictionary:response withTypeStr:@"USER"];
            
            complete(codeItem);
        }
    }];
}
#pragma mark - GROUP_QRCODE_QUERY 群二维码数据请求
/* 个人用户的 二维码数据请求 */
+ (void)QRCoderequestGroupId:(NSString *)groupId complete: (void(^)(KKQRCodeItem *))complete{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"GROUP_QRCODE_QUERY" forKey:@"service"];
//    [params setObject:@"10984003886384090000740980189019" forKey:@"groupId"];
    [params setObject:groupId forKey:@"groupId"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            NSDictionary *response = resultModel.resultDic[@"response"];
//            [KKWriteDateToPath writeDataToFilePath:@"/Users/danche/Desktop/数据Plist文件夹/GROUP_QRCODE_QUERY.plist" withData:response];
            
            KKQRCodeItem *codeItem = [KKQRCodeItem QRCodeWithDictionary:response withTypeStr:@"GROUP"];
            
            complete(codeItem);
        }
    }];
}
#pragma mark - GUILD_QRCODE_QUERY 工会二维码数据请求
+ (void)QRCoderequestGuildId:(NSString *)groupId complete:(void(^)(KKQRCodeItem *))complete{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"GUILD_QRCODE_QUERY" forKey:@"service"];
//    [params setObject:@"4004090960923116060000006890" forKey:@"guildId"];
    [params setObject:groupId forKey:@"guildId"];

    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            NSDictionary *response = resultModel.resultDic[@"response"];
//            [KKWriteDateToPath writeDataToFilePath:@"/Users/danche/Desktop/数据Plist文件夹/GUILD_QRCODE_QUERY.plist" withData:response];
            
            KKQRCodeItem *codeItem = [KKQRCodeItem QRCodeWithDictionary:response withTypeStr:@"GUILD"];
            
            complete(codeItem);
        }
    }];
}
@end
