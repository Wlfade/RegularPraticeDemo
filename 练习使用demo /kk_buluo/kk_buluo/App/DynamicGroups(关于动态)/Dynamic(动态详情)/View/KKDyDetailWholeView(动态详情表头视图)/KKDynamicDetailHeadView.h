//
//  KKDynamicDetailHeadView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKDyDetailWholeItem;

@interface KKDynamicDetailHeadView : UIView

@property(nonatomic,strong) KKDyDetailWholeItem *dyDetailWholeItem;

- (instancetype)initWithFrame:(CGRect)frame withDyDetailWholeItem:(KKDyDetailWholeItem *)dyDetailWholeItem;


- (void)makeSetDyDetailWholeItem:(KKDyDetailWholeItem *)dyDetailWholeItem;
@end

NS_ASSUME_NONNULL_END
