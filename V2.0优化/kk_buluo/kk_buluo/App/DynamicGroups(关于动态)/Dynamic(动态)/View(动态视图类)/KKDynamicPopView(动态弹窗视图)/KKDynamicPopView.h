//
//  KKDynamicPopView.h
//  KKTribe
//
//  Created by 单车 on 2019/2/19.
//  Copyright © 2019 杭州鼎代. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKDynamicPopView;
@protocol KKDynamicPopViewDelegate <NSObject>

/**
 按钮点击选中后的视图
 */
- (void)KKDynamicPopViewClicked:(KKDynamicPopView *)screenView withSelectedSting:(NSString *)selectString;
/**
 筛选视图被关闭
 */
- (void)KKDynamicPopViewClosed:(KKDynamicPopView *)screenView;


@end

@interface KKDynamicPopView : UIView

+ (instancetype)KKDynamicPopViewShow:(NSArray * _Nonnull )inforTextArr witSelectedPoint:(CGPoint)selectedPoint;

+ (void)hide:(void(^)(void))completion;

@property (nonatomic, weak)id <KKDynamicPopViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
