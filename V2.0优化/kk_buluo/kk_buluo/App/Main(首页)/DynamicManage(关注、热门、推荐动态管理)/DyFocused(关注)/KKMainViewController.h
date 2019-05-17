//
//  KKMainViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface KKMainViewController : UIViewController
/** 子视图frame */
@property(nonatomic,assign)CGRect subViewFrame;

@property(nonatomic,strong)UIViewController *showingVC;

@end

NS_ASSUME_NONNULL_END
