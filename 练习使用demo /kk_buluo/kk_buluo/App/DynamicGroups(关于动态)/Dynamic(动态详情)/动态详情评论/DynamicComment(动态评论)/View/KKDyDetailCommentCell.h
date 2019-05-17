//
//  KKDyDetailCommentCell.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKDynamicCommentItem.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ReplyTouchBlock)(KKDynamicCommentItem*);

@interface KKDyDetailCommentCell : UITableViewCell
@property(nonatomic,strong) KKDynamicCommentItem *dyCommentItem;

@property(nonatomic,strong) ReplyTouchBlock block;
@end

NS_ASSUME_NONNULL_END
