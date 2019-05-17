//
//  KKRootContollerMgr.h
//  kk_buluo
//
//  Created by yaya on 2019/3/8.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRootContollerMgr : NSObject
+ (void)loadRootVC:(nullable NSDictionary *)launchOptions;
+ (void)loadLoginAsRootVC;
+ (void)loadLTabAsRootVC;
@end

NS_ASSUME_NONNULL_END
