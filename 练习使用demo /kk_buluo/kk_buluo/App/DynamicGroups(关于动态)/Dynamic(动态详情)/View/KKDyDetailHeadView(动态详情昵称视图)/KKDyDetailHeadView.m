//
//  KKDyDetailHeadView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailHeadView.h"

#import "YYText.h"
#import "KKDynamicHeadItem.h"
#import "KKPersonalPageController.h"

#define cellWH 35

@interface KKDyDetailHeadView ()
/** 头像 */
@property (nonatomic,weak)UIImageView *headImage;
/** 昵称 */
@property (nonatomic, weak)YYLabel *nickName;
/** 简介 */
@property (nonatomic,weak)UILabel *fromeLabel;

@property (nonatomic,weak)UIButton *focuseBtn;
@end

@implementation KKDyDetailHeadView

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
    //    nickName.userInteractionEnabled = YES;
    [self addSubview:nickName];
    self.nickName = nickName;
    //
    //    UITapGestureRecognizer *nickNametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    //    [self.nickName addGestureRecognizer:nickNametap];
    //简介 时间+（来源）
    UILabel *fromeLabel = [[UILabel alloc]init];
    fromeLabel.text = @"简介";
    fromeLabel.textColor = RGB(200, 200, 200);
    fromeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:fromeLabel];
    self.fromeLabel = fromeLabel;
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [focusBtn setImage:[UIImage imageNamed:@"focused_icon"] forState:UIControlStateSelected];
    [focusBtn setImage:[UIImage imageNamed:@"focus_icon"] forState:UIControlStateNormal];
    [focusBtn addTarget:self action:@selector(focusAction:) forControlEvents:UIControlEventTouchUpInside];
    self.focuseBtn = focusBtn;
    [self addSubview:focusBtn];
    
    
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
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@46);
        make.centerY.mas_equalTo(headImage.mas_centerY);
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
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dyHeadItem.userLogoUrl] placeholderImage:nil];
    
    self.nickName.text = dyHeadItem.userName;
    
    self.fromeLabel.text = dyHeadItem.showDate;
    
    self.focuseBtn.selected = dyHeadItem.focus;
    
    if ([dyHeadItem.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        self.focuseBtn.hidden = YES;
    }else{
        self.focuseBtn.hidden = NO;
    }
    
}

- (void)focusAction:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(KKDyDetailHeadViewDidFocus:withDyHeadItem:withFocus:)]) {
        [self.delegate KKDyDetailHeadViewDidFocus:self withDyHeadItem:self.dyHeadItem withFocus:!sender.selected];
    }
    
}
- (void)clickAction:(UITapGestureRecognizer *)tap{
    KKPersonalPageController *personalPageVC = [[KKPersonalPageController alloc]init];
//    personalPageVC.personalPageType = PERSONAL_PAGE_OTHER;
    
    if ([_dyHeadItem.commonObjectTypeName isEqualToString:@"USER"]) {
        personalPageVC.personalPageType = PERSONAL_PAGE_OTHER;
        
    }else if([_dyHeadItem.commonObjectTypeName isEqualToString:@"GUILD_INDEX"]){
        personalPageVC.personalPageType = PERSONAL_PAGE_GUILD;
        
    }
    
    personalPageVC.userId = _dyHeadItem.userId;
    [self.viewController.navigationController pushViewController:personalPageVC animated:YES];
}
@end
