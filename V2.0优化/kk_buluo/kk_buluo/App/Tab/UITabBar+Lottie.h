//
//  UITabBar+Lottie.h
//  kk_buluo
//
//  Created by david on 2019/4/10.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (Lottie)

- (void)addLottieImage:(int)index lottieName:(NSString *)lottieName;

- (void)animationLottieImage:(int)index;

@end

NS_ASSUME_NONNULL_END
