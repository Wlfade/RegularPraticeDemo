//
//  KKDyDetailCommentCell.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailCommentCell.h"
#import "KKDyDetailCommentHeadView.h"
#import "KKDyDetailCommentTextView.h" //内容视图
#import "KKDyDetailCommentImageView.h" //评论的图片内容
#import "KKDyDetaiCommentReplyView.h" //评论的回复
#import "KKComDeViewController.h"

@interface KKDyDetailCommentCell ()<KKDyDetaiCommentReplyViewDelegate>
@property (nonatomic, weak) KKDyDetailCommentHeadView *dyCommentHeadView;

/** 内容信息视图 */
@property (nonatomic, weak) KKDyDetailCommentTextView *dynamicTextView;

@property (nonatomic, weak) KKDyDetailCommentImageView *commentImageView;

@property (nonatomic, weak) KKDyDetaiCommentReplyView *replyView;

/** 横线 */
@property (nonatomic, weak) UIView *lineView;

@end

@implementation KKDyDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _creatSubView];
    }
    return self;
}
- (void)_creatSubView{
    //1.头像
    KKDyDetailCommentHeadView *dyCommentHeadView = [[KKDyDetailCommentHeadView alloc]init];
    self.dyCommentHeadView = dyCommentHeadView;
    [self.contentView addSubview:dyCommentHeadView];
    //2.内容
    KKDyDetailCommentTextView *dynamicTextView = [[KKDyDetailCommentTextView alloc]init];
    self.dynamicTextView = dynamicTextView;
    [self.contentView addSubview:dynamicTextView];
    
    //3.图片
    KKDyDetailCommentImageView *commentImageView = [[KKDyDetailCommentImageView alloc]init];
    self.commentImageView = commentImageView;
    [self.contentView addSubview:commentImageView];
    
    //4.评论的回复
    KKDyDetaiCommentReplyView *replyView = [[KKDyDetaiCommentReplyView alloc]init];
    replyView.delegate = self;
    replyView.layer.cornerRadius = 3;
    replyView.layer.masksToBounds = YES;
    replyView.backgroundColor = COLOR_BG;
    self.replyView = replyView;
    [self.contentView addSubview:replyView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = COLOR_BG;
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)setDyCommentItem:(KKDynamicCommentItem *)dyCommentItem{
    _dyCommentItem = dyCommentItem;
    //头像昵称
    _dyCommentHeadView.dyHeadItem = dyCommentItem.dynamicHeadItem;
    //文本内容
    _dynamicTextView.dyTextItem = dyCommentItem.dynamicComTextItem;
    
    if(dyCommentItem.isImages){
        _commentImageView.dynamicImageItem = _dyCommentItem.dynamicImageitem;
        _commentImageView.hidden = NO;
    }else{
        _commentImageView.hidden = YES;
    }
    
    if (dyCommentItem.replyList) {
        _replyView.replyList = dyCommentItem.replyList;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    //头像
    self.dyCommentHeadView.frame = CGRectMake(0, 0, selfWidth, _dyCommentItem.dynamicHeadItem.dynamicHeadHeight);
    //文本
    self.dynamicTextView.frame = CGRectMake(52, self.dyCommentHeadView.bottom, selfWidth - 52, _dyCommentItem.dynamicComTextItem.dyComTextHeight);
    //图片
    self.commentImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfHeight, _dyCommentItem.dyImageHeight);
    
    self.replyView.frame =  CGRectMake(52, self.commentImageView.bottom, selfWidth - 62, _dyCommentItem.dyReplyHeight);
    
    self.lineView.frame = CGRectMake(10, selfHeight - 1, selfWidth - 20, 1);
}
- (void)KKDyDetaiCommentReplyViewTouched:(KKDyDetaiCommentReplyView *)replyView{
    if (self.block) {
        self.block(_dyCommentItem);
    }
}
@end
