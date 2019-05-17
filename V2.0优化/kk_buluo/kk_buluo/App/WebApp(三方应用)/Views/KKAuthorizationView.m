//
//  KKAuthorizationView.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKAuthorizationView.h"

@implementation KKAuthorizationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - [ccui getRH:273] - STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, [ccui getRH:273])];
        whiteBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteBgView];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:20], [ccui getRH:21], [ccui getRH:24], [ccui getRH:24])];
        [whiteBgView addSubview:_iconImageView];
        
        _webAppNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + [ccui getRH:9], [ccui getRH:24], SCREEN_WIDTH - _iconImageView.right - [ccui getRH:19], [ccui getRH:16])];
        _webAppNameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
        [whiteBgView addSubview:_webAppNameLabel];
        
        UILabel *discriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:16], [ccui getRH:70], SCREEN_WIDTH - [ccui getRH:32], [ccui getRH:60])];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"获取您的公开信息(昵称、头像、地区及性别)" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: [ccui getRH:20]],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        discriptionLabel.attributedText = string;
        discriptionLabel.numberOfLines = 0;
        [whiteBgView addSubview:discriptionLabel];
        
        UIButton *rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rejectButton.frame = CGRectMake([ccui getRH:21], [ccui getRH:181], (SCREEN_WIDTH - 2 * [ccui getRH:21] - 10) / 2, [ccui getRH:40]);
        [rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
        rejectButton.backgroundColor = RGB(237, 237, 237);
        [rejectButton setTitleColor:COLOR_BLACK_TEXT forState:UIControlStateNormal];
        rejectButton.layer.cornerRadius = [ccui getRH:4];
        [rejectButton addTarget:self action:@selector(rejectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [whiteBgView addSubview:rejectButton];
        
        
        UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        agreeButton.frame = CGRectMake(rejectButton.right + 10, [ccui getRH:181], (SCREEN_WIDTH - 2 * [ccui getRH:21] - 10) / 2, [ccui getRH:40]);
        [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        agreeButton.backgroundColor = RGB(43, 63, 255);
        [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        agreeButton.layer.cornerRadius = [ccui getRH:4];
        [agreeButton addTarget:self action:@selector(agreeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [whiteBgView addSubview:agreeButton];
    }
    return self;
}

- (void)rejectButtonAction:(UIButton *)obj {
    CCLOG(@"rejectButtonAction");
    if ([self.delegate respondsToSelector:@selector(authorizationViewDidSelectedReject)]) {
        [self.delegate authorizationViewDidSelectedReject];
    }
}

- (void)agreeButtonAction {
    CCLOG(@"agreeButtonAction");
    if ([self.delegate respondsToSelector:@selector(authorizationViewDidSelectedAgree)]) {
        [self.delegate authorizationViewDidSelectedAgree];
    }
}

@end
