//
//  KKDynamicCardView.h
//  KKTribe
//
//  Created by 单车 on 2018/7/16.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKDynamicCardItem;
@interface KKDynamicCardView : UIView
/** 动态模型 */
@property (nonatomic,strong) KKDynamicCardItem *dyCardItem;

@property (nonatomic,strong)void(^tapBlock)(void);

@end
