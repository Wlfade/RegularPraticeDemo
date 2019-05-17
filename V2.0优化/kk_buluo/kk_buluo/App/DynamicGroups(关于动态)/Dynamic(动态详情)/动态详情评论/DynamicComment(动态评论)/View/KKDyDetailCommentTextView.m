//
//  KKDyDetailCommentTextView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailCommentTextView.h"

@interface KKDyDetailCommentTextView ()
/** 动态摘要 */
@property (nonatomic,weak)UITextView *summaryTextView;
@end

@implementation KKDyDetailCommentTextView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _creatSubView];
    }
    return self;
}

- (void)_creatSubView{
    
    UITextView *summaryTextView = [[UITextView alloc]init];
    [summaryTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    summaryTextView.textContainer.lineFragmentPadding = 0;
    summaryTextView.textContainerInset = UIEdgeInsetsZero;
    summaryTextView.font = [UIFont systemFontOfSize:16];
    summaryTextView.editable=NO;
    summaryTextView.scrollEnabled=NO;

    summaryTextView.textContainer.lineBreakMode=NSLineBreakByTruncatingTail;
    summaryTextView.userInteractionEnabled=NO;
    summaryTextView.backgroundColor = [UIColor clearColor];
    self.summaryTextView = summaryTextView;
    
    
    [self addSubview:summaryTextView];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.width;
    CGFloat selfHeight = self.height;
    self.summaryTextView.frame = CGRectMake(0, 0, selfWidth - 10, _dyTextItem.comSummaryHeight);
}
- (void)setDyTextItem:(KKDynamicCommentTextItem *)dyTextItem{
    _dyTextItem = dyTextItem;
    self.summaryTextView.attributedText = dyTextItem.outAttComSummary;
}

@end
