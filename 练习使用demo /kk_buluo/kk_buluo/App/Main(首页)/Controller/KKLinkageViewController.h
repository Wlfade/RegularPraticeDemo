//
//  KKLinkageViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLinkageViewController : UIViewController

/** 标题按钮数组 */
@property (nonatomic,strong) NSMutableArray *titleBtnMutArr;

/** 标题scrollView */
@property (nonatomic,strong) UIScrollView *titleScrollView;

/** 内容视图的高度 */
@property(nonatomic,assign)CGFloat contentScrollViewHeigh;
/** titleScrollView 的Y值 */
@property(nonatomic,assign)CGFloat topY;

- (void)titleClick:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
