//
//  KKDynamicWholeCell.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKDynamicWholeCell,KKDynamicWholeItem;
NS_ASSUME_NONNULL_BEGIN
@protocol KKDynamicWholeCellDelegate <NSObject>

@optional
//头部的更多的按钮点击事件代理方法
- (void)KKDynamicWholeCell:(KKDynamicWholeCell *)dynamicWholeCell withHeadViewPoint:(CGPoint )thePoint;

//头部的关注按钮点击事件代理方法
- (void)KKDynamicWholeCellfocusActionFocus:(KKDynamicWholeCell *)dynamicWholeCell;

@end
@interface KKDynamicWholeCell : UITableViewCell

@property(nonatomic,weak)id <KKDynamicWholeCellDelegate> delegate;


@property(nonatomic,strong) KKDynamicWholeItem *dynamicWholeItem;

//- (void)setTheInforItem:(NSObject *)item;

@end

NS_ASSUME_NONNULL_END
