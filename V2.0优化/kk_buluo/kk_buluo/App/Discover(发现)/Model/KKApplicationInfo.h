//
//  KKApplicationInfo.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/23.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKApplicationInfo : NSObject

/**
 {
 "logoUrl" : "http:\/\/mapi1.kknew.net\/applicationLogoUrl.htm?applicationLogoId=10984004178778622808890970019843&sizeType=SMALL&timestamp=1556001270639",
 "inside" : 0,
 "id" : "4004126373101816060000009949",
 "descs" : "undefined",
 "name" : "测试未通过",
 "collect": 0
 "cdnUrl" : "http:\/\/www.baidu.com"
 }
 */
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *descs;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cdnUrl;
@property (nonatomic, copy) NSString *collect;
@property (nonatomic, copy) NSString *inside;

@end

NS_ASSUME_NONNULL_END
