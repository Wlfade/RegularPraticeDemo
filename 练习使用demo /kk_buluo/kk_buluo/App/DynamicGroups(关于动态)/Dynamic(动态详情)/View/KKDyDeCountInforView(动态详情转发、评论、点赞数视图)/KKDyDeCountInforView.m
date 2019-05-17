//
//  KKDyDeCountInforView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDeCountInforView.h"
#import "KKDynamicOperationItem.h"
#import "KKRemakeCountTool.h"

static CGFloat const btnWidth = 70;
@interface KKDyDeCountInforView ()

@property (nonatomic,weak)UIButton *transmitBtn; //转发按钮

@property (nonatomic,weak)UIButton *commentBtn; //评论按钮

@property (nonatomic,weak)UIButton *likeBtn; //点赞按钮

@property (nonatomic,weak)UIButton *selectedBtn; //选中的按钮

@property (nonatomic,weak)UIImageView *imageView;

@property (nonatomic,strong)NSMutableArray *mutBtnArr; //按钮数组
@end

@implementation KKDyDeCountInforView
- (instancetype)initWithFrame:(CGRect)frame withOperationItem:(KKDynamicOperationItem *)dyOperationItem{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubView:dyOperationItem];
    }
    return self;
}

- (NSMutableArray *)mutBtnArr{
    if (!_mutBtnArr) {
        _mutBtnArr = [NSMutableArray array];
    }
    return _mutBtnArr;
}
- (void)creatSubView:(KKDynamicOperationItem *)dyOperationItem{
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 6)];
    topLineView.backgroundColor = COLOR_BG;
    [self addSubview:topLineView];
    
    UIButton *transmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatBtnProperty:transmitBtn];
    transmitBtn.frame = CGRectMake(10, 6, btnWidth, 30);
    transmitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    transmitBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    
    [transmitBtn setTitle:[NSString stringWithFormat:@"转发 %@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.transmitCount]] forState:UIControlStateNormal];
    [self addSubview:transmitBtn];
    
    transmitBtn.tag = 0;

    [transmitBtn addTarget:self action:@selector(infroClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.transmitBtn = transmitBtn;
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatBtnProperty:commentBtn];
    commentBtn.frame = CGRectMake(10 + btnWidth, 6, btnWidth, 30);
    commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    
    [commentBtn setTitle:[NSString stringWithFormat:@"评论 %@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.replyCount]] forState:UIControlStateNormal];
    [self addSubview:commentBtn];
    
    commentBtn.tag = 1;

    [commentBtn addTarget:self action:@selector(infroClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBtn = commentBtn;

    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatBtnProperty:likeBtn];
    likeBtn.frame = CGRectMake(self.width - 10 - btnWidth, 6, btnWidth, 30);
    likeBtn.titleLabel.textAlignment = NSTextAlignmentRight;

    likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    [likeBtn setTitle:[NSString stringWithFormat:@"赞 %@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.likeCount]] forState:UIControlStateNormal];
    [self addSubview:likeBtn];
    
    likeBtn.tag = 2;
    
    [likeBtn addTarget:self action:@selector(infroClickAction:) forControlEvents:UIControlEventTouchUpInside];

    self.likeBtn = likeBtn;
    
    [self.mutBtnArr addObject:transmitBtn];
    [self.mutBtnArr addObject:commentBtn];
    [self.mutBtnArr addObject:likeBtn];
    
    UIView *imageScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 36, self.width, 3)];
    [self addSubview:imageScrollView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 27, 3)];
    imageView.image = [UIImage imageNamed:@"item_scrollLine"];
    self.imageView = imageView;
    [imageScrollView addSubview:imageView];
    
    UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(10, self.height -1, self.width - 20, 1)];
    bottomLineView.backgroundColor = COLOR_BG;
    [self addSubview:bottomLineView];
    
    [self infroClickAction:commentBtn];
    
    
//    infroClickAction
}
- (void)creatBtnProperty:(UIButton *)sender{
    [sender setTitleColor:rgba(153, 153, 153, 1) forState:UIControlStateNormal];
    [sender setTitleColor:rgba(51, 51, 51, 1) forState:UIControlStateSelected];
    sender.titleLabel.font = [UIFont systemFontOfSize:13];
}
- (void)setDyOperationItem:(KKDynamicOperationItem *)dyOperationItem{
    _dyOperationItem = dyOperationItem;
    
    
    [self.transmitBtn setTitle:[NSString stringWithFormat:@"转发 %@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.transmitCount]] forState:UIControlStateNormal];
    
    [self.commentBtn setTitle:[NSString stringWithFormat:@"评论 %@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.replyCount]] forState:UIControlStateNormal];

    [self.likeBtn setTitle:[NSString stringWithFormat:@"赞 %@",[KKRemakeCountTool remakeCountFromeCount:dyOperationItem.likeCount]] forState:UIControlStateNormal];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)infroClickAction:(UIButton *)sender{
    _selectedBtn.selected = NO;
    sender.selected = YES;
    
    sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    _selectedBtn.transform = CGAffineTransformIdentity;
    
    _selectedBtn = sender;
    
//    CGRect labelFrame = sender.titleLabel.frame;
    
    NSString *titleStr = sender.titleLabel.text;
    
    CGFloat titleW = [titleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.width;
    
    CGRect labelFrame = [sender convertRect:sender.titleLabel.frame toView:self];
    labelFrame.size.width = titleW;
    
    [self moveTheLineToCenter:labelFrame];
    
    if ([self.delegate respondsToSelector:@selector(KKDyDeCountInforViewDidSelected:)]) {
        [self.delegate KKDyDeCountInforViewDidSelected:sender.tag];
    }
    
}
- (void)moveTheLineToCenter:(CGRect)btnFrame{
    CGFloat imagePointX = btnFrame.origin.x + ((btnFrame.size.width - 27)/2);
    [UIView animateWithDuration:0.4 animations:^{
        self.imageView.transform = CGAffineTransformMakeTranslation(imagePointX, 0);
    }];
}
@end
