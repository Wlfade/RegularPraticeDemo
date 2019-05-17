//
//  KKDyDetailCommentHeadView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailCommentHeadView.h"
#import "KKLikeOrCancelLikeQuery.h"
#import "YYText.h"
#import "KKDynamicHeadItem.h"
#import "KKPersonalPageController.h"
#define cellWH 35

@interface KKDyDetailCommentHeadView ()

/** 头像 */
@property (nonatomic,weak)UIImageView *headImage;
/** 昵称 */
@property (nonatomic, weak)YYLabel *nickName;
/** 简介 */
@property (nonatomic,weak)UILabel *fromeLabel;

@property (nonatomic,weak)UIButton *likeBtn;

@end

@implementation KKDyDetailCommentHeadView
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
    nickName.userInteractionEnabled = YES;
    [self addSubview:nickName];
    self.nickName = nickName;
    //
    UITapGestureRecognizer *nickNametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [self.nickName addGestureRecognizer:nickNametap];
    //简介 时间+（来源）
    UILabel *fromeLabel = [[UILabel alloc]init];
    fromeLabel.text = @"简介";
    fromeLabel.textColor = RGB(200, 200, 200);
    fromeLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:fromeLabel];
    self.fromeLabel = fromeLabel;
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:[UIImage imageNamed:@"like_gray_icon"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"like_red_icon"] forState:UIControlStateSelected];

    [likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
//    likeBtn.titleLabel.textColor = [UIColor blackColor];
    [likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.likeBtn = likeBtn;
    [self addSubview:likeBtn];
    
    
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
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(@20);
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
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dyHeadItem.userLogoUrl] placeholderImage:[UIImage imageNamed:@"userLogo_defualt"]];
    
    self.nickName.text = dyHeadItem.userName;
    
    self.fromeLabel.text = dyHeadItem.showDate;
    
    self.likeBtn.selected = dyHeadItem.liked;
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)dyHeadItem.likeCount] forState:UIControlStateNormal];
    
}

- (void)likeAction:(UIButton *)sender{
    WS(weakSelf);
    [KKLikeOrCancelLikeQuery requestIsClickLike:_dyHeadItem.liked withLikeCount:_dyHeadItem.likeCount withObjectId:_dyHeadItem.commentId withType:@"COMMENT" withFinish:^(BOOL liked, NSInteger count) {
        KKDynamicHeadItem *headItem = weakSelf.dyHeadItem;
        headItem.liked = liked;
        if (liked == YES) {
            headItem.likeCount +=1;
        }else{
            headItem.likeCount -=1;
        }
        weakSelf.dyHeadItem = headItem;
    }];
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
