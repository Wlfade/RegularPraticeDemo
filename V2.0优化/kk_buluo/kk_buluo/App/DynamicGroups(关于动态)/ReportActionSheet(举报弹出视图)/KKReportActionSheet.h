//
//  KKReportActionSheet.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKReportActionSheet : NSObject
//+ (void)reportActionSheet:(UIViewController *)viewController;
+ (void)KKReportActionSheetPersent:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
