//
//  KKDyComReplyCell.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyComReplyCell.h"

@interface KKDyComReplyCell ()
/** 时间Label */
@property (nonatomic,weak)UILabel *replyUserName;

/** 动态摘要 */
@property (nonatomic,weak)UITextView *summaryTextView;
@end

@implementation KKDyComReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *replyUserName = [[UILabel alloc]init];
    replyUserName.font = [UIFont systemFontOfSize:13];
    replyUserName.textColor = RGBA(87, 107, 149, 1);
    replyUserName.frame = CGRectMake(0, 0, 100, 50);
    self.replyUserName = replyUserName;
    [self.contentView addSubview:replyUserName];
    
    UITextView *summaryTextView = [[UITextView alloc]init];
    summaryTextView.backgroundColor = [UIColor clearColor];
    [summaryTextView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    summaryTextView.textContainer.lineFragmentPadding = 0;
    summaryTextView.textContainerInset = UIEdgeInsetsZero;
    summaryTextView.font = [UIFont systemFontOfSize:13];
    summaryTextView.editable=NO;
    summaryTextView.scrollEnabled=NO;
    summaryTextView.textContainer.lineBreakMode=NSLineBreakByTruncatingTail;
    summaryTextView.userInteractionEnabled=NO;
    self.summaryTextView = summaryTextView;
    [self.contentView addSubview:summaryTextView];
    
    
    [replyUserName setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [replyUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(5);
        
        make.top.equalTo(self.contentView.mas_top).offset(3);

        make.right.mas_equalTo(summaryTextView.mas_left).offset(0);
    }];
    
    [summaryTextView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [summaryTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(3);

        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);

        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}
- (void)setReplyItem:(KKDynamicCommentReplyItem *)replyItem{
    _replyItem = replyItem;
    
    _replyUserName.text = replyItem.replyUserName;
    
    _summaryTextView.attributedText = replyItem.mutContent;
}
@end
