//
//  KKDynamicCardView.m
//  KKTribe
//
//  Created by 单车 on 2018/7/16.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "KKDynamicCardView.h"
#import "KKDynamicCardItem.h"
@interface KKDynamicCardView ()

/** bgView */
@property (nonatomic,strong)UIView *bgView;
/** 图片视图 */
@property (nonatomic,strong)UIImageView *cardImageView;
/** 动态标题 */
@property (nonatomic,strong)UITextView *titleTextView;
/** 动态摘要 */
@property (nonatomic,strong)UITextView *summaryTextView;


///** 动态标题 */
//@property (nonatomic,weak)UILabel *titleTextView;
///** 动态摘要 */
//@property (nonatomic,weak)UILabel *summaryTextView;


/** 信息被删除视图 */
@property (nonatomic,strong)UIView *noContentView;

@end
@implementation KKDynamicCardView
#pragma mark init
- (instancetype)init{
    self = [super init];
    if(self){
        [self _creatSubView];
    }
    return self;
}
#pragma mark UI
- (void)_creatSubView{
    [self cretBgInforView];
    [self creatDeletedInforView];
}
/* 创建带有内容的视图 */
- (void)cretBgInforView{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGB(241, 241, 241);
    self.bgView = bgView;
    [self addSubview:bgView];

    UIImageView *cardImageView = [[UIImageView alloc]init];
    cardImageView.backgroundColor = [UIColor whiteColor];
    self.cardImageView = cardImageView;
    [bgView addSubview:cardImageView];

    UITextView *titleTextView = [[UITextView alloc]init];
    [self setTheTextViewProperty:titleTextView withTextColor:RGB(51, 51, 51) withFont:[UIFont boldSystemFontOfSize:13]];
    self.titleTextView = titleTextView;
//    titleTextView.backgroundColor = [UIColor redColor];
    [bgView addSubview:titleTextView];
    
//    UILabel *titleTextView = [[UILabel alloc]init];
//    [self setTheTextViewProperty:titleTextView withTextColor:RGB(51, 51, 51) withFont:[UIFont boldSystemFontOfSize:13]];
//    self.titleTextView = titleTextView;
//    [bgView addSubview:titleTextView];
    

    UITextView *summaryTextView = [[UITextView alloc]init];
    [self setTheTextViewProperty:summaryTextView withTextColor:RGB(153, 153, 153) withFont:[UIFont boldSystemFontOfSize:13]];
    summaryTextView.textContainer.maximumNumberOfLines=2;
    self.summaryTextView = summaryTextView;
//    summaryTextView.backgroundColor = [UIColor blueColor];
    [bgView addSubview:summaryTextView];
    
//    UILabel *summaryTextView = [[UILabel alloc]init];
//    [self setTheTextViewProperty:summaryTextView withTextColor:RGB(153, 153, 153) withFont:[UIFont boldSystemFontOfSize:13]];
//    self.summaryTextView = summaryTextView;
//    [bgView addSubview:summaryTextView];
    
}
/* 创建无数据的视图 */
- (void)creatDeletedInforView{
    UIView *noContentView = [[UIButton alloc] init];
    noContentView.backgroundColor = RGB(242, 242, 242);
    self.noContentView = noContentView;
    [self addSubview:noContentView];
    
//    UIImageView *imageView2=[[UIImageView alloc]init];
//    imageView2.image=[UIImage imageNamed:@"dyInfor_deleted_icon"];
//    [noContentView addSubview:imageView2];
    
    UILabel *errorLabel = [[UILabel alloc] init];
//    errorLabel.text = @"抱歉，该内容已删除";
    errorLabel.text = @"抱歉，该动态已被删除";

//    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.textAlignment = NSTextAlignmentLeft;

    errorLabel.font=[UIFont systemFontOfSize:13];
    errorLabel.textColor=[UIColor grayColor];
    [noContentView addSubview:errorLabel];
    
    [noContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];

    [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(noContentView.mas_centerX);
        make.left.mas_equalTo(noContentView.mas_left).offset(20);

        make.centerY.mas_equalTo(noContentView.mas_centerY);
        make.height.mas_equalTo(@30);
    }];

//    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(@25);
//        make.right.mas_equalTo(errorLabel.mas_left).offset(-5);
//        make.centerY.mas_equalTo(noContentView.mas_centerY);
//    }];
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

    textView.textContainer.maximumNumberOfLines=1;

    textView.textContainer.lineBreakMode=NSLineBreakByTruncatingTail;
    textView.userInteractionEnabled=NO;
}

//- (void)setTheTextViewProperty:(UILabel *)textView
//                 withTextColor:(UIColor *)textColor
//                      withFont:(UIFont *)textFont
//{
//    textView.backgroundColor = [UIColor clearColor];
//    textView.textColor=textColor;
//    textView.font = textFont;
//    textView.lineBreakMode = NSLineBreakByTruncatingTail;
//    textView.userInteractionEnabled=NO;
//}

#pragma mark SetDyCardItem
- (void)setDyCardItem:(KKDynamicCardItem *)dyCardItem{
    _dyCardItem = dyCardItem;
    
    if (_dyCardItem.deleted == NO) {
        self.bgView.hidden = NO;
        self.noContentView.hidden = YES;
        
        [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:dyCardItem.firstUrlStr] placeholderImage:dyCardItem.placeHoldImage];
        self.titleTextView.attributedText = dyCardItem.outAttTitle;
        self.summaryTextView.attributedText = _dyCardItem.outAttSummary;
    }else{
        self.bgView.hidden = YES;
        self.noContentView.hidden = NO;
    }
}
#pragma mark ResetFrame
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    if (_dyCardItem.deleted == NO) {
        self.bgView.hidden = NO;
        self.noContentView.hidden = YES;
        
        self.bgView.frame = CGRectMake(12, 0, selfWidth - 24, selfHeight - 5);
        self.cardImageView.frame = CGRectMake(0, 0, selfHeight - 5, selfHeight - 5);
        
//        self.titleTextView.frame = CGRectMake(self.cardImageView.right + 5, 5, (selfWidth - 24) -(selfHeight - 5) - 10, 15);
        self.titleTextView.frame = CGRectMake(self.cardImageView.right + 5, _dyCardItem.topGapH, (selfWidth - 24) -(selfHeight - 5) - 10, _dyCardItem.titleHeight);


        self.summaryTextView.frame = CGRectMake(self.cardImageView.right + 5, self.titleTextView.bottom , (selfWidth - 24) -(selfHeight - 5) - 10, _dyCardItem.summaryHeight);

        
        //有标题
//        if (_dyCardItem.title) {
//            self.titleTextView.hidden = NO;
////            self.titleTextView.numberOfLines = 1;
//            self.titleTextView.frame = CGRectMake(self.cardImageView.right + 5, 5, (selfWidth - 24) -(selfHeight - 5) - 10, selfHeight/2 - 5);
////            self.summaryTextView.numberOfLines = 1;
//            self.summaryTextView.frame = CGRectMake(self.cardImageView.right + 5, selfHeight/2, (selfWidth - 24) -(selfHeight - 5) - 10, selfHeight/2 - 5);
//        }else{
//            self.titleTextView.hidden = YES;
////            self.summaryTextView.numberOfLines = 2;
//
//            CGFloat summaryTextViewHeight = _dyCardItem.summaryHeight;
//
//            self.summaryTextView.frame = CGRectMake(self.cardImageView.right + 5, (selfHeight - summaryTextViewHeight)/2, (selfWidth - 24) -(selfHeight - 5) - 10, summaryTextViewHeight);
//        }
        
    }
    else{
        self.bgView.hidden = YES;
        self.noContentView.hidden = NO;
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_dyCardItem.deleted == NO) {
        if (self.tapBlock) {
            self.tapBlock();
        }
    }
}
@end
