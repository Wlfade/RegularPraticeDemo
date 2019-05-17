//
//  KKAboutWebAppFooterView.h
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^toOpenWebAppBlock)(void);
@interface KKAboutWebAppFooterView : UIView
@property (nonatomic, copy) toOpenWebAppBlock toOpenWebAppBlock;

@end

NS_ASSUME_NONNULL_END
