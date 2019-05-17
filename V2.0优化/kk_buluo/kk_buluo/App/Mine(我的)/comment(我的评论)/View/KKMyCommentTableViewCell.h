//
//  KKMyCommentTableViewCell.h
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMyCommentListModel.h"

@class KKMyCommentTableViewCell;
@protocol KKMyCommentTableViewCellDelegate <NSObject>
- (void)commentCell:(KKMyCommentTableViewCell *)cell withHeadViewPoint:(CGPoint)point;
@end

NS_ASSUME_NONNULL_BEGIN

@interface KKMyCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) KKMyCommentSimpleModel *model;
@property (nonatomic, weak) id<KKMyCommentTableViewCellDelegate> commentDelegate;
@end

NS_ASSUME_NONNULL_END
