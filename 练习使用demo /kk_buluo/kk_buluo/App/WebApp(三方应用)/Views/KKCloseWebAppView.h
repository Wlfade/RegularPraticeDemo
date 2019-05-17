//
//  KKCloseWebAppView.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/23.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^webAppCloseBlock)(void);
typedef void(^webAppOperationBlock)(void);

@interface KKCloseWebAppView : UIView
@property (nonatomic, copy) webAppCloseBlock webAppCloseBlock;
@property (nonatomic, copy) webAppOperationBlock webAppOperationBlock;

@end

NS_ASSUME_NONNULL_END
