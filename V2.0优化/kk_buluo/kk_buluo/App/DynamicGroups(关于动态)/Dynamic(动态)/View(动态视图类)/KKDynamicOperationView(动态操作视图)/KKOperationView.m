//
//  KKOperationView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/16.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKOperationView.h"
#import "KKDynamicOperationItem.h"
#import "KKRemakeCountTool.h"
#import "LFButton.h"

@interface KKOperationView ()

//分享视图
@property (nonatomic,weak) UIView *shareView;
@property (nonatomic,weak) UIButton *shareBtn;

//评论视图
@property (nonatomic,weak) UIView *commentView;
@property (nonatomic,weak) UIButton *commentBtn;
//点赞视图
@property (nonatomic,weak) UIView *likeView;
@property (nonatomic,weak) UIButton *likeBtn;

/** 底部灰色的线条 */
@property (nonatomic, weak) UIView *grayLineView;

@end

@implementation KKOperationView

- (instancetype)init{
    if (self = [super init]) {
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    //分享视图
    UIView *shareView = [[UIView alloc]init];
    self.shareView = shareView;
    [self addSubview:shareView];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"share_gray_icon"] forState:UIControlStateNormal];
    [shareBtn setTitle:@"12" forState:UIControlStateNormal];
    [shareBtn setTitleColor:rgba(153, 153, 153, 1) forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = shareBtn;
    [shareView addSubview:shareBtn];
    
    UIView *commentView = [[UIView alloc]init];
    self.commentView = commentView;
    [self addSubview:commentView];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setImage:[UIImage imageNamed:@"comment_gray_icon"] forState:UIControlStateNormal];
    [commentBtn setTitle:@"50" forState:UIControlStateNormal];
    [commentBtn setTitleColor:rgba(153, 153, 153, 1) forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn = commentBtn;
    [commentView addSubview:commentBtn];
    
    UIView *likeView = [[UIView alloc]init];
    self.likeView = likeView;
    [self addSubview:likeView];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:[UIImage imageNamed:@"like_gray_icon"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"like_red_icon"] forState:UIControlStateSelected];

    [likeBtn setTitle:@"50" forState:UIControlStateNormal];
    [likeBtn setTitleColor:rgba(153, 153, 153, 1) forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.likeBtn = likeBtn;
    [likeView addSubview:likeBtn];
    
    UIView *grayLineView = [[UIView alloc]init];
    grayLineView.backgroundColor = COLOR_BG;
    [self addSubview:grayLineView];
    
    [grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(@5);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left);
    }];
    
    NSArray *viewArr = @[shareView,commentView,likeView];

    /* 数组中的控件水平等宽显示 fixedSpacing:控件之间的间隔 leadSpace:头部间隔 tailSpacing:尾部间隔 */
    [viewArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:10 tailSpacing:10];
 
    [viewArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.mas_height).offset(-10);
    }];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareView.mas_left);
        make.top.bottom.mas_equalTo(shareView);
        make.width.mas_lessThanOrEqualTo(shareView.mas_width);
    }];
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(commentView);
        make.top.bottom.mas_equalTo(commentView);
    }];
    
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(likeView.mas_right);
        make.top.bottom.mas_equalTo(likeView);
        make.width.mas_lessThanOrEqualTo(likeView.mas_width);
    }];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setDyOperationItem:(KKDynamicOperationItem *)dyOperationItem{
    _dyOperationItem = dyOperationItem;
    [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.transmitCount]] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.replyCount]] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.likeCount]] forState:UIControlStateNormal];
    self.likeBtn.selected = dyOperationItem.liked;
}

/** 分享 */
- (void)shareAction{
    if ([self.delegate respondsToSelector:@selector(KKOperationViewDidShare:)]) {
        [self.delegate KKOperationViewDidShare:self];
    }
}
/** 评论 */
- (void)commentAction{
    if ([self.delegate respondsToSelector:@selector(KKOperationViewDidComment:)]) {
        [self.delegate KKOperationViewDidComment:self];
    }
}
/** 点赞 */
- (void)likeAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(KKOperationViewDidLike:withLiked:)]) {
        [self.delegate KKOperationViewDidLike:self withLiked:sender.selected];
    }
}
@end
