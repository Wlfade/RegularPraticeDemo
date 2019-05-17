//
//  KKDynamicArticleCell.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicArticleCell.h"
#import "KKDynamicWholeItem.h"
#import "KKDynamicArticleItem.h"

@interface KKDynamicArticleCell ()
/** 图片视图 */
@property (nonatomic,strong)UIImageView *cardImageView;

@property (nonatomic,strong)UIView *titleBGView;

/** 标题 */
@property (nonatomic,strong)UITextView *titleTextView;

//@property (nonatomic,strong)UILabel *titleTextView;



/** 认证、时间、阅读数 */
@property (nonatomic,weak)UILabel *fromeLabel;

@property (nonatomic,weak)UIButton *functionBtn;

@property (nonatomic,strong)KKDynamicArticleItem *articlItem;
@end

@implementation KKDynamicArticleCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    
    UIImageView *cardImageView = [[UIImageView alloc]init];
    cardImageView.backgroundColor = [UIColor whiteColor];

    self.cardImageView = cardImageView;
    [self.contentView addSubview:cardImageView];
    
    
    UIView *titleBGView = [[UIView alloc]init];
//    titleBGView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:titleBGView];
    
    
    UITextView *titleTextView = [[UITextView alloc]init];
    [self setTheTextViewProperty:titleTextView withTextColor:RGB(51, 51, 51) withFont:[UIFont boldSystemFontOfSize:13]];
//    titleTextView.backgroundColor = [UIColor orangeColor];
    self.titleTextView = titleTextView;
    [titleBGView addSubview:titleTextView];
    
//    UILabel *titleTextView = [[UILabel alloc]init];
////    [self setTheTextViewProperty:titleTextView withTextColor:RGB(51, 51, 51) withFont:[UIFont boldSystemFontOfSize:13]];
//    titleTextView.textColor = RGB(51, 51, 51);
//    titleTextView.font = [ccui getRFS:13];
//    titleTextView.lineBreakMode = NSLineBreakByTruncatingTail;
//    titleTextView.numberOfLines = 2;
//    titleTextView.backgroundColor = [UIColor orangeColor];
//    self.titleTextView = titleTextView;
//    [self.contentView addSubview:titleTextView];
    
    
    UILabel *fromeLabel = [[UILabel alloc]init];
    fromeLabel.text = @"简介";
    fromeLabel.textColor = RGB(200, 200, 200);
    fromeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:fromeLabel];
    self.fromeLabel = fromeLabel;
    
    UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [functionBtn setImage:[UIImage imageNamed:@"dynamic_more_icon"] forState:UIControlStateNormal];
    [functionBtn addTarget:self action:@selector(functionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:functionBtn];
    
    UIView *grayLineView = [[UIView alloc]init];
    grayLineView.backgroundColor = COLOR_BG;
    [self addSubview:grayLineView];
    
    [grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(@5);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.mas_left);
    }];
    
    [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(@10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);

        make.width.mas_equalTo(@111);
        make.height.mas_equalTo(@76);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [titleBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cardImageView.mas_top).offset(6);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(cardImageView.mas_left).offset(-8);
        make.bottom.mas_equalTo(cardImageView.mas_bottom).offset(-20);
    }];

    [titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleBGView.mas_left);
//        make.right.mas_equalTo(titleBGView.mas_right);
        make.centerY.mas_equalTo(titleBGView.centerY);
    }];

    [fromeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleBGView.mas_bottom);
        make.left.mas_equalTo(titleBGView.mas_left);
        make.right.mas_equalTo(titleBGView.mas_right).offset(-30);
        make.bottom.mas_equalTo(cardImageView.mas_bottom);
    }];

    [functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(titleBGView.mas_right);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
        make.centerY.mas_equalTo(fromeLabel.mas_centerY);
    }];

}
//设置textView的属性
- (void)setTheTextViewProperty:(UITextView *)textView
                 withTextColor:(UIColor *)textColor
                      withFont:(UIFont *)textFont
{
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor=textColor;
    textView.font = textFont;
    textView.editable=NO;
    textView.scrollEnabled=NO;
    textView.textContainer.lineFragmentPadding = 0;
    
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 3, 0);
    
//    textView.textContainer.maximumNumberOfLines=2;
    
    textView.textContainer.lineBreakMode=NSLineBreakByTruncatingTail;
    textView.userInteractionEnabled=NO;
}
- (void)functionAction:(UIButton *)sender{
    
    CGPoint p = [self convertPoint:sender.frame.origin toView:self.window];
    p.x += sender.frame.size.width / 2;
    p.y += sender.frame.size.height / 2;
    
    if ([self.delegate respondsToSelector:@selector(KKDynamicArticleCell:withfunctionBtnPoint:)]) {
        [self.delegate KKDynamicArticleCell:self withfunctionBtnPoint:p];
    }
}

- (void)setDynamicWholeItem:(KKDynamicWholeItem *)dynamicWholeItem{
    _dynamicWholeItem = dynamicWholeItem;
    
    self.articlItem = dynamicWholeItem.dynamicArticleItem;
    
}

- (void)setArticlItem:(KKDynamicArticleItem *)articlItem{
    _articlItem = articlItem;
    
    [_cardImageView sd_setImageWithURL:[NSURL URLWithString:_articlItem.firstUrlStr] placeholderImage:_articlItem.placeHoldImage];
    
    _titleTextView.attributedText = _articlItem.outAttTitle;
    
    [_titleTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self->_articlItem.titleHeight);
        make.width.mas_equalTo(self->_articlItem.titleWidth);
    }];
    
    _fromeLabel.text = _articlItem.fromeStr;
    
}

#pragma mark ResetFrame
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
