//
//  KKDynamicTextView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicTextView.h"

#import "KKDynamicTextItem.h"

#import "NSAttributedString+YYText.h"
#import "YYLabel.h"

@interface KKDynamicTextView ()<UITextViewDelegate>
/** 标题 */
@property (nonatomic,strong)UITextView *titleTextView;
/** 动态摘要 */
@property (nonatomic,strong)UITextView *summaryTextView;

//@property (nonatomic,strong)YYLabel *summaryTextView;



@end

@implementation KKDynamicTextView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self _creatSubView];
    }
    return self;
}
- (void)_creatSubView{
    

    [self addSubview:self.titleTextView];
    
    [self addSubview:self.summaryTextView];
}
//- (YYLabel *)summaryTextView{
//    if (!_summaryTextView) {
//        _summaryTextView = [[YYLabel alloc]init];
////        [_summaryTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
////        _summaryTextView.textContainer.lineFragmentPadding = 0;
//        _summaryTextView.textContainerInset = UIEdgeInsetsZero;
////        _summaryTextView.font = [UIFont systemFontOfSize:16];
////        _summaryTextView.editable=NO;
////        _summaryTextView.scrollEnabled=NO;
////        _summaryTextView.textContainer.lineBreakMode=NSLineBreakByTruncatingTail;
//
////        _summaryTextView.userInteractionEnabled=NO;
//        _summaryTextView.userInteractionEnabled=YES;
//        _summaryTextView.numberOfLines = 0;
//
//
//    }
//    return _summaryTextView;
//}


- (UITextView *)summaryTextView{
    if (!_summaryTextView) {
        _summaryTextView = [[UITextView alloc]init];
        _summaryTextView.text = @"内容";
        [_summaryTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _summaryTextView.textContainer.lineFragmentPadding = 0;
        _summaryTextView.textContainerInset = UIEdgeInsetsZero;
        _summaryTextView.font = [UIFont systemFontOfSize:16];
        _summaryTextView.editable=NO;
        _summaryTextView.scrollEnabled=NO;
        _summaryTextView.delegate = self;
        
        _summaryTextView.textContainer.lineBreakMode=NSLineBreakByTruncatingTail;

//        _summaryTextView.userInteractionEnabled=NO;
        _summaryTextView.userInteractionEnabled=YES;

    }
    return _summaryTextView;
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
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.width;
    CGFloat selfHeight = self.height;
    
    self.titleTextView.frame = CGRectMake(10, 0, selfWidth - 20, _dyTextItem.titleHeight);
    
    
    self.summaryTextView.frame = CGRectMake(10, self.titleTextView.bottom, selfWidth - 20, _dyTextItem.summaryHeight);
}
- (void)setDyTextItem:(KKDynamicTextItem *)dyTextItem{
    _dyTextItem = dyTextItem;
//    self.summaryTextView. = dyTextItem.summary;
    
    self.titleTextView.attributedText =  dyTextItem.outAttTitle;

    
    self.summaryTextView.attributedText = dyTextItem.outAttSummary;
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"checkbox"]) {
//        self.view.backgroundColor = [UIColor whiteColor];
//        self.select = !self.select;
//        [self setLinkText];//设置文本
        return NO;
    }else if ([[URL scheme] isEqualToString:@"login"]) {
//        self.view.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor redColor];
        return NO;
    }else if ([[URL scheme] isEqualToString:@"register"]) {
//        self.view.backgroundColor = [UIColor greenColor];
        return NO;
    }
    return YES;
}
@end
