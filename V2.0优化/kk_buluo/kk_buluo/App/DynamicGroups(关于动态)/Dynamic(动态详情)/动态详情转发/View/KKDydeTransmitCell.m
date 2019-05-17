//
//  KKDydeTransmitCell.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDydeTransmitCell.h"
//#import "KKDyDetailCommentHeadView.h"
#import "KKDydeTransmitItem.h"

#import "KKDyDetailTransmitHeadView.h"
#import "KKDyDetailCommentTextView.h" //内容视图


@interface KKDydeTransmitCell ()
@property (nonatomic, weak) KKDyDetailTransmitHeadView *dyTransmitHeadView;
/** 内容信息视图 */
@property (nonatomic, weak) KKDyDetailCommentTextView *dyTransmitTextView;
/** 横线 */
@property (nonatomic, weak) UIView *lineView;

@end
@implementation KKDydeTransmitCell

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
    KKDyDetailTransmitHeadView *dyCommentHeadView = [[KKDyDetailTransmitHeadView alloc]init];
    self.dyTransmitHeadView = dyCommentHeadView;
    [self.contentView addSubview:dyCommentHeadView];
    //2.内容
    KKDyDetailCommentTextView *dynamicTextView = [[KKDyDetailCommentTextView alloc]init];
    self.dyTransmitTextView = dynamicTextView;
    [self.contentView addSubview:dynamicTextView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = COLOR_BG;
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}
- (void)setTransmitItem:(KKDydeTransmitItem *)transmitItem{
    _transmitItem = transmitItem;
    //头像昵称
    _dyTransmitHeadView.dyHeadItem = transmitItem.dynamicHeadItem;
    //文本内容
    _dyTransmitTextView.dyTextItem = transmitItem.dynamicTransmitTextItem;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    //头像
    self.dyTransmitHeadView.frame = CGRectMake(0, 0, selfWidth, _transmitItem.dynamicHeadItem.dynamicHeadHeight);
    //文本
    self.dyTransmitTextView.frame = CGRectMake(52, self.dyTransmitHeadView.bottom , selfWidth - 52, _transmitItem.dynamicTransmitTextItem.dyComTextHeight);
    
    self.lineView.frame = CGRectMake(10, selfHeight - 1, selfWidth - 20, 1);
}

@end
