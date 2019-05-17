//
//  KKDydeLikeHeadView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDydeLikeHeadView.h"
#import "YYText.h"
#import "KKDynamicHeadItem.h"
#import "KKPersonalPageController.h"
#define cellWH 35

@interface KKDydeLikeHeadView ()
/** 头像 */
@property (nonatomic,weak)UIImageView *headImage;
/** 昵称 */
@property (nonatomic, weak)YYLabel *nickName;
/** 简介 */
@property (nonatomic,weak)UILabel *fromeLabel;
@end

@implementation KKDydeLikeHeadView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _creatSubView];
    }
    return self;
}
- (void)_creatSubView{
    //头像
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.layer.cornerRadius = cellWH/2;
    headImage.clipsToBounds = YES;
    headImage.userInteractionEnabled = YES;
    [self addSubview:headImage];
    self.headImage = headImage;
    
    UITapGestureRecognizer *headImagetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [self.headImage addGestureRecognizer:headImagetap];
    
    //昵称
    YYLabel *nickName = [[YYLabel alloc]init];
    nickName.text = @"昵称";
    nickName.textColor = COLOR_BLACK_TEXT;
    nickName.font = [UIFont systemFontOfSize:13];
    [self addSubview:nickName];
    self.nickName = nickName;

    //简介 时间+（来源）
    UILabel *fromeLabel = [[UILabel alloc]init];
    fromeLabel.text = @"简介";
    fromeLabel.textColor = RGB(200, 200, 200);
    fromeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:fromeLabel];
    self.fromeLabel = fromeLabel;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(@12);
        make.width.height.mas_equalTo(@cellWH);
    }];
    
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(fromeLabel.mas_top);
        make.left.mas_equalTo(headImage.mas_right).offset(5);
        
    }];
    
    [fromeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).offset(5);
        make.top.mas_equalTo(nickName.mas_bottom).offset(2);
        make.bottom.mas_equalTo(headImage.mas_bottom).offset(-2);
    }];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setDyHeadItem:(KKDynamicHeadItem *)dyHeadItem{
    _dyHeadItem = dyHeadItem;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dyHeadItem.userLogoUrl] placeholderImage:[UIImage imageNamed:@"userLogo_defualt"]];
    
    self.nickName.text = dyHeadItem.userName;
    self.fromeLabel.text = dyHeadItem.showDate;
    
    if (dyHeadItem.showDate) {
        
    }else{
        [self.nickName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.headImage.mas_centerY);
        }];
    }
}
- (void)clickAction:(UITapGestureRecognizer *)tap{
    KKPersonalPageController *personalPageVC = [[KKPersonalPageController alloc]init];
    if ([_dyHeadItem.commonObjectTypeName isEqualToString:@"USER"]) {
        personalPageVC.personalPageType = PERSONAL_PAGE_OTHER;
        
    }else if([_dyHeadItem.commonObjectTypeName isEqualToString:@"GUILD_INDEX"]){
        personalPageVC.personalPageType = PERSONAL_PAGE_GUILD;
        
    }
    
    personalPageVC.userId = _dyHeadItem.userId;
    [self.viewController.navigationController pushViewController:personalPageVC animated:YES];
}

@end
