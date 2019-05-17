//
//  KKDyDeCountInforView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@class KKDynamicOperationItem,KKDyDeCountInforView;

@protocol KKDyDeCountInforViewDelegate <NSObject>

- (void)KKDyDeCountInforViewDidSelected:(NSInteger)SelectedIndex;

@end

@interface KKDyDeCountInforView : UIView
@property (nonatomic,strong)KKDynamicOperationItem *dyOperationItem;
@property (nonatomic,weak)id <KKDyDeCountInforViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withOperationItem:(KKDynamicOperationItem *)dyOperationItem;
@end

NS_ASSUME_NONNULL_END
