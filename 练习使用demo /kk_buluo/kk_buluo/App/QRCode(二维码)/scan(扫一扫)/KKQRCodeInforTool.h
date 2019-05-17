//
//  KKQRCodeInforTool.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKQRCodeInforTool : NSObject

/**
 将二维码扫描到的数据 转出字典

 @param urlStr 二维码扫描的 结果字符串
 @return 可变的字典
 */
+(NSMutableDictionary*)seperateURLIntoDictionary:(NSString*)urlStr;
@end

NS_ASSUME_NONNULL_END
