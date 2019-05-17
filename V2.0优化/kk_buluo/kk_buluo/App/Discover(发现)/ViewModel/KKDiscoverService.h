//
//  KKDiscoverService.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^requestWebAppBlockSuccess)(NSMutableArray *applicationList);
typedef void(^requestWebAppBlockFail)(void);

@interface KKDiscoverService : NSObject
@property (nonatomic, copy) requestWebAppBlockSuccess requestWebAppBlockSuccess;
@property (nonatomic, copy) requestWebAppBlockFail requestWebAppBlockFail;
+ (void)requestMyWebAppSuccess:(requestWebAppBlockSuccess)success Fail:(requestWebAppBlockFail)fail;
@end

NS_ASSUME_NONNULL_END
