//
//  KKDyHeadView.m
//  KKTribe
//
//  Created by 单车 on 2018/7/14.
//  Copyright © 2018年 杭州鼎代. All rights reserved.
//

#import "KKDyHeadView.h"

#import "YYText.h"
#import "KKDynamicHeadItem.h"

#import "KKPersonalPageController.h"

#define cellWH 35
@interface KKDyHeadView ()
/** 头像 */
@property (nonatomic,weak)UIImageView *headImage;
/** 昵称 */
@property (nonatomic, weak)YYLabel *nickName;
/** 简介 */
@property (nonatomic,weak)UILabel *fromeLabel;

@property (nonatomic,weak)UIButton *functionBtn;

@property (nonatomic, weak) UIButton *attentionButton;
@end
@implementation KKDyHeadView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self _creatSubView];
    }
    return self;
}
- (void)_creatSubView{
    //头像
    UIImageView *headImage = ({
        UIImageView *headImage =[[UIImageView alloc]init];
        headImage.layer.cornerRadius = cellWH/2;
        headImage.clipsToBounds = YES;
        headImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *headImagetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
        [headImage addGestureRecognizer:headImagetap];
        
        self.headImage = headImage;
        headImage;
    });
    [self addSubview:headImage];

    

    //昵称
    YYLabel *nickName = ({
        YYLabel *nickName = [[YYLabel alloc]init];
        nickName.text = @"昵称";
        nickName.textColor = COLOR_BLACK_TEXT;
        nickName.font = [UIFont systemFontOfSize:13];
//        nickName.userInteractionEnabled = YES;
//        UITapGestureRecognizer *nickNametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
//        [nickName addGestureRecognizer:nickNametap];
        self.nickName = nickName;
        nickName;
    });
    [self addSubview:nickName];

    //简介 时间+（来源）
    UILabel *fromeLabel =({
        UILabel *fromeLabel =[[UILabel alloc]init];
        fromeLabel.text = @"简介";
        fromeLabel.textColor = RGB(200, 200, 200);
        fromeLabel.font = [UIFont systemFontOfSize:11];
        self.fromeLabel = fromeLabel;
        fromeLabel;
    });
    [self addSubview:fromeLabel];

   
    
    
    ///关注按钮
    UIButton *attentionButton = ({
        UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
        attentionButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        attentionButton.hidden = YES;
        [attentionButton setTitleColor:RGB(43, 63, 255) forState:UIControlStateNormal];
        [attentionButton addTarget:self action:@selector(attentionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.attentionButton = attentionButton;
        attentionButton;
    });
    [self addSubview:attentionButton];
    
    UIButton *functionBtn =({
        UIButton *functionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [functionBtn setImage:[UIImage imageNamed:@"dynamic_more_icon"] forState:UIControlStateNormal];
        [functionBtn addTarget:self action:@selector(functionAction:) forControlEvents:UIControlEventTouchUpInside];
        functionBtn;
    });
    [self addSubview:functionBtn];


    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(@12);
        make.width.height.mas_equalTo(@cellWH);
    }];

    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).offset(5);
        make.bottom.mas_equalTo(headImage.mas_centerY);

    }];
    
    [fromeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).offset(5);
        make.top.mas_equalTo(nickName.mas_bottom).offset(2);
        make.bottom.mas_equalTo(headImage.mas_bottom).offset(-2);
    }];
    [functionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.width.height.mas_equalTo(@30);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(functionBtn.mas_left).offset(-5);
//        make.width.mas_equalTo(@47);
        make.height.mas_equalTo(@24);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];

}

-(void)setDyHeadItem:(KKDynamicHeadItem *)dyHeadItem{
    _dyHeadItem = dyHeadItem;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dyHeadItem.userLogoUrl] placeholderImage:[UIImage imageNamed:@"userLogo_defualt"]];
    
    self.nickName.text = dyHeadItem.userName;
    
    self.fromeLabel.text = dyHeadItem.showDate;
    
    self.attentionButton.hidden= dyHeadItem.focus;
}

- (void)functionAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(KKDyHeadView:didClickFunction:)]) {
        [self.delegate KKDyHeadView:self didClickFunction:sender];
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
- (void)attentionButtonAction {
    if ([self.delegate respondsToSelector:@selector(KKDyHeadView:didClickFocus:)]) {
        [self.delegate KKDyHeadView:self didClickFocus:_dyHeadItem];
    }
}
@end
