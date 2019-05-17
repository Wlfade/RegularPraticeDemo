//
//  KKDynamicArticleCell.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class KKDynamicWholeItem,KKDynamicArticleCell;

@protocol KKDynamicArticleCellDelegate <NSObject>

- (void)KKDynamicArticleCell:(KKDynamicArticleCell *)dynamicArticleCell withfunctionBtnPoint:(CGPoint )thePoint;

@end

@interface KKDynamicArticleCell : UITableViewCell

/** 单元格数据模型 */
@property(nonatomic,strong)KKDynamicWholeItem *dynamicWholeItem;

@property(nonatomic,weak)id <KKDynamicArticleCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
