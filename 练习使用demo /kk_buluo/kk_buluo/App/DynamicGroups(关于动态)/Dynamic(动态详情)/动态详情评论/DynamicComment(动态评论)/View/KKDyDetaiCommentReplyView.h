//
//  KKDyDetaiCommentReplyView.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKDyDetaiCommentReplyView;

@protocol KKDyDetaiCommentReplyViewDelegate <NSObject>

- (void)KKDyDetaiCommentReplyViewTouched:(KKDyDetaiCommentReplyView *)replyView;

@end

@interface KKDyDetaiCommentReplyView : UIView
@property (nonatomic,strong)NSArray *replyList;

@property (nonatomic,weak) id <KKDyDetaiCommentReplyViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
