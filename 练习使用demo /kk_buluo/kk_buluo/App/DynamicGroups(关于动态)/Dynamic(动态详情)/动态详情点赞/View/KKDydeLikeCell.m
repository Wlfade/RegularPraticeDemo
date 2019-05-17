//
//  KKDydeLikeCell.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDydeLikeCell.h"
#import "KKDydeLikeHeadView.h"
@interface KKDydeLikeCell ()
/** 横线 */
@property (nonatomic, weak) UIView *lineView;

@property (nonatomic, weak) KKDydeLikeHeadView *dyTransmitHeadView;
@end

@implementation KKDydeLikeCell

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
    KKDydeLikeHeadView *dyCommentHeadView = [[KKDydeLikeHeadView alloc]init];
    self.dyTransmitHeadView = dyCommentHeadView;
    [self.contentView addSubview:dyCommentHeadView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = COLOR_BG;
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
    
}
- (void)setDydeLikeItem:(KKDydeLikeItem *)dydeLikeItem{
    _dydeLikeItem = dydeLikeItem;
    //头像昵称
    _dyTransmitHeadView.dyHeadItem = dydeLikeItem.dynamicHeadItem;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    //头像
    self.dyTransmitHeadView.frame = CGRectMake(0, 0, selfWidth, _dydeLikeItem.dynamicHeadItem.dynamicHeadHeight);
    
    self.lineView.frame = CGRectMake(10, selfHeight - 1, selfWidth - 20, 1);
}
@end
