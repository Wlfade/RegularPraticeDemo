//
//  KKDyDeBottomOperationView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDeBottomOperationView.h"
#import "KKDynamicOperationItem.h"
#import "KKRemakeCountTool.h"

@interface KKDyDeBottomOperationView ()
/** 信息视图 */
@property (nonatomic,weak)UIView *inforView;
/** 灰色背景视图 */
@property (nonatomic,weak)UIView *grayView;

/** 占位Label */
@property (nonatomic,weak) UILabel *placeholderLabel;

/** 评论数 */
@property (nonatomic,weak) UILabel *commentCountLabel;

@property (nonatomic,weak) UIImageView* likeBtn;

/** 点赞数 */
@property (nonatomic,weak) UILabel *likeCountLabel;

@property (nonatomic,weak) UIImageView* collectBtn;

@end
static const CGFloat viewHeight = 29;
@implementation KKDyDeBottomOperationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubView];
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView{
    self.backgroundColor = [UIColor whiteColor];
    UIView *inforView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 49)];
    inforView.backgroundColor = [UIColor whiteColor];
    [self addSubview:inforView];
    
    UIView *grayLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    grayLineView.backgroundColor = RGB(239, 239, 239);
    [inforView addSubview:grayLineView];
    
    UIView *grayView = [[UIView alloc]init];
    
    grayView.layer.cornerRadius = 3;
    
    grayView.backgroundColor = RGB(239, 239, 239);
    self.grayView = grayView;
    [inforView addSubview:grayView];
    
    //评论
    UIView *commentView = [[UIView alloc]init];
    commentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:commentView];
    //点赞
    UIView *likeView = [[UIView alloc]init];
    likeView.backgroundColor = [UIColor whiteColor];

    [self addSubview:likeView];
    //收藏
    UIView *collectView = [[UIView alloc]init];
    collectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectView];
    //分享
    UIView *shareView = [[UIView alloc]init];
    shareView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareView];

    //布局
    CGFloat commentWidth = (SCREEN_WIDTH - 180)/4;
//    CGFloat likeWidth = (SCREEN_WIDTH - 180)/4 + 10;
//    CGFloat collectWidth = (SCREEN_WIDTH - 180)/4 - 5;
//    CGFloat shareWidth = (SCREEN_WIDTH - 180)/4 - 5;
    CGFloat likeWidth = (SCREEN_WIDTH - 180)/4 ;
    CGFloat collectWidth = (SCREEN_WIDTH - 180)/4;
    CGFloat shareWidth = (SCREEN_WIDTH - 180)/4;
    
    grayView.frame = CGRectMake(5, 10, 160, viewHeight);
    commentView.frame = CGRectMake(170, 10, commentWidth, viewHeight);
    likeView.frame = CGRectMake(170+commentWidth, 10, likeWidth, viewHeight);
    collectView.frame = CGRectMake(170+commentWidth+likeWidth, 10, collectWidth, viewHeight);
    shareView.frame = CGRectMake(170+commentWidth+likeWidth+collectWidth, 10, shareWidth, viewHeight);
    
 //创建对应的子视图
    [self creatGrayView:grayView];
    [self creatCommentView:commentView];
    [self creatLikeView:likeView];
    [self creatCollectView:collectView];
    [self creatShareView:shareView];
}
/**
 创建发表页面元素评论页面
 */
- (void)creatGrayView:(UIView *)grayView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(writeAction:)];
    [grayView addGestureRecognizer:tapGesture];
    
    UIImageView *writeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wirite_comment_icon"]];
    [grayView addSubview:writeImageView];
    
    UILabel *placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.text = @"我来说一说";
    placeholderLabel.font = [UIFont systemFontOfSize:15];
    placeholderLabel.textColor = RGB(153, 153, 153);
    self.placeholderLabel = placeholderLabel;
    [grayView addSubview:placeholderLabel];
    
    [writeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(grayView.mas_left).offset(4);
        make.centerY.mas_equalTo(grayView.mas_centerY);
    }];
    
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(writeImageView.mas_right);
        make.centerY.mas_equalTo(grayView.mas_centerY);
    }];

}
/**
 创建评论视图页面元素
 @param commentView 评论页面
 */
- (void)creatCommentView:(UIView *)commentView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CommentAction:)];
    [commentView addGestureRecognizer:tapGesture];
    
    UIImageView *commentBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamic_detail_comment_icon"]];
    commentBtn.userInteractionEnabled = YES;
    [commentView addSubview:commentBtn];
    
    UILabel *commentCountLabel = [[UILabel alloc]init];
    commentCountLabel.textAlignment = NSTextAlignmentCenter;
    commentCountLabel.textColor = [UIColor whiteColor];
    CGFloat font = 10;
    commentCountLabel.font = [UIFont systemFontOfSize:font];
    commentCountLabel.backgroundColor = rgba(255, 59, 48, 1);
    commentCountLabel.layer.cornerRadius = (font + 2)/2;
    commentCountLabel.clipsToBounds = YES;
    self.commentCountLabel = commentCountLabel;
    [commentView addSubview:commentCountLabel];
    
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentView.mas_centerY);
        make.left.equalTo(commentView.mas_left).offset(10);
    }];
    
    [commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentBtn.mas_right).offset(-10);
        make.top.equalTo(commentBtn.mas_top).offset(-2);
        make.height.mas_equalTo(font+2);
//        make.width.mas_greaterThanOrEqualTo(font + 2);
//        make.width.mas_lessThanOrEqualTo(50);
    }];
}
- (void)creatLikeView:(UIView *)likeView{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeAction:)];
    [likeView addGestureRecognizer:tapGesture];
    
    UIImageView *likeBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamic_detail_like_icon"] highlightedImage:[UIImage imageNamed:@"dynamic_detail_liked_icon"]];
    self.likeBtn = likeBtn;
    likeBtn.userInteractionEnabled = YES;
    [likeView addSubview:likeBtn];
    
    UILabel *likeCountLabel = [[UILabel alloc]init];
    likeCountLabel.textAlignment = NSTextAlignmentCenter;
    likeCountLabel.textColor = RGB(0, 0, 51);
    CGFloat font = 10;
    likeCountLabel.font = [UIFont systemFontOfSize:font];
    likeCountLabel.clipsToBounds = YES;
    self.likeCountLabel = likeCountLabel;
    [likeView addSubview:likeCountLabel];
    
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(likeView.mas_centerY);
        make.left.equalTo(likeView.mas_left).offset(8);
    }];
    
    [likeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(likeBtn.mas_right).offset(-5);
        make.top.equalTo(likeBtn.mas_top).offset(-2);
        make.height.mas_equalTo(font+2);
        make.width.mas_greaterThanOrEqualTo(font + 2);
        make.width.mas_lessThanOrEqualTo(50);
    }];
}
- (void)creatCollectView:(UIView *)collectView{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectAction:)];
    [collectView addGestureRecognizer:tapGesture];
    
    UIImageView *collectionBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamic_detail_uncollect_icon"] highlightedImage:[UIImage imageNamed:@"dynamic_detail_collected_icon"]];
    self.collectBtn = collectionBtn;
    collectionBtn.userInteractionEnabled = YES;
    [collectView addSubview:collectionBtn];
    
    [collectView addSubview:collectionBtn];
    
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(collectView.mas_centerY);
        make.centerX.equalTo(collectView.mas_centerX);
    }];
}
- (void)creatShareView:(UIView *)shareView{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transmitAction:)];
    [shareView addGestureRecognizer:tapGesture];
    
    UIImageView *shareBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dynamic_detail_transmit_icon"]];
    
    [shareView addSubview:shareBtn];

    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareView.mas_centerY);
        make.centerX.equalTo(shareView.mas_centerX);
    }];
}
- (void)writeAction:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(KKDyDeBottomOperationWriteAction:)]) {
        [self.delegate KKDyDeBottomOperationWriteAction:self];
    }
}

- (void)CommentAction:(UITapGestureRecognizer *)tap{
    
    NSLog(@"%@",[tap.view class]);
    if ([self.delegate respondsToSelector:@selector(KKDyDeBottomOperationCommentAction:withOperationItem:)]) {
        [self.delegate KKDyDeBottomOperationCommentAction:self withOperationItem:self.OperationItem];
    }
}
- (void)likeAction:(UITapGestureRecognizer *)tap{
//    _likeBtn.highlighted = !_likeBtn.highlighted;

    if ([self.delegate respondsToSelector:@selector(KKDyDeBottomOperationLikeAction:withOperationItem:)]) {
        [self.delegate KKDyDeBottomOperationLikeAction:self withOperationItem:self.OperationItem];
    }
}
- (void)collectAction:(UITapGestureRecognizer *)tap{

    if ([self.delegate respondsToSelector:@selector(KKDyDeBottomOperationCollectAction:withOperationItem:)]) {
        [self.delegate KKDyDeBottomOperationCollectAction:self withOperationItem:self.OperationItem];

    }
}
- (void)transmitAction:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(KKDyDeBottomOperationTransmitAction:withOperationItem:)]) {
        [self.delegate KKDyDeBottomOperationTransmitAction:self withOperationItem:self.OperationItem];
    }
}
- (void)setOperationItem:(KKDynamicOperationItem *)OperationItem{
    _OperationItem = OperationItem;
    
    if ([[KKRemakeCountTool remakeCountFromeCount:OperationItem.replyCount]integerValue] > 0) {

        _commentCountLabel.text = [NSString stringWithFormat:@"%@      ",[KKRemakeCountTool remakeCountFromeCount:OperationItem.replyCount]];
        NSString *countStr = [KKRemakeCountTool remakeCountFromeCount:OperationItem.replyCount];
        
        CGFloat nameWidth = [countStr boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} context:nil].size.width + 4;
        
        if (nameWidth < 12) {
            nameWidth = 12;
        }

        [_commentCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth);
            make.width.mas_greaterThanOrEqualTo(10 + 2);
            make.width.mas_lessThanOrEqualTo(50);
        }];
        
        _commentCountLabel.hidden = NO;
    }else{
        _commentCountLabel.hidden = YES;
    }
    
    _likeBtn.highlighted = OperationItem.liked;

//    _likeCountLabel.text = [KKRemakeCountTool remakeCountFromeCount:OperationItem.likeCount];
    if ([[KKRemakeCountTool remakeCountFromeCount:OperationItem.likeCount] integerValue] > 0) {
        _likeCountLabel.text = [KKRemakeCountTool remakeCountFromeCount:OperationItem.likeCount];
        _likeCountLabel.hidden = NO;
    }else{
        _likeCountLabel.hidden = YES;
    }

    _collectBtn.highlighted = OperationItem.collected;
}
@end
