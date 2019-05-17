//
//  KKQRCodeRequest.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/26.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class KKQRCodeItem;
@interface KKQRCodeRequest : NSObject
//我的二维码请求
+ (void)myQRCoderequest:(void(^)(KKQRCodeItem *))complete;
//群二维码请求
+ (void)QRCoderequestGroupId:(NSString *)groupId complete:(void(^)(KKQRCodeItem *))complete;
//工会二维码请求
+ (void)QRCoderequestGuildId:(NSString *)groupId complete:(void(^)(KKQRCodeItem *))complete;

@end

NS_ASSUME_NONNULL_END
