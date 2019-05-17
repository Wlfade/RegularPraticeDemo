//
//  KKDyDetailTitleView.m
//  KKTribe
//
//  Created by 单车 on 2018/8/6.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "KKDyDetailTitleView.h"

@interface KKDyDetailTitleView ()
/** 标题 */
@property (nonatomic,strong)UITextView *titleTextView;
@end
@implementation KKDyDetailTitleView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self _creatSubView];
    }
    return self;
}
- (UITextView *)titleTextView{
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc]init];
//        _titleTextView.text = @"标题";
        [_titleTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _titleTextView.textContainer.lineFragmentPadding = 0;
        _titleTextView.textContainerInset = UIEdgeInsetsZero;
        _titleTextView.font = [UIFont systemFontOfSize:16];
        _titleTextView.editable=NO;
        _titleTextView.scrollEnabled=NO;
        _titleTextView.textContainer.lineBreakMode=NSLineBreakByTruncatingTail;
        
        _titleTextView.userInteractionEnabled=NO;
    }
    return _titleTextView;
}
- (void)_creatSubView{
    [self addSubview:self.titleTextView];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.width;
    self.titleTextView.frame = CGRectMake(10, 10, selfWidth - 20, _titleItem.titleHeight - 10);
}

-(void)setTitleItem:(KKDyDetailTitleItem *)titleItem{
    _titleItem = titleItem;
    
    self.titleTextView.attributedText =  titleItem.outAttTitle;

    
}


@end
