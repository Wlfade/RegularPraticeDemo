//
//  KKAddAddFriendShareView.m
//  kk_buluo
//
//  Created by 樊星 on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKAddAddFriendShareView.h"
#import "UIImage+Extension.h"

@implementation KKAddAddFriendShareView{
    UILabel *contentLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self configSubView];
    }
    return self;
}

-(void)setPhoneNum:(NSString *)phoneNum{
    _phoneNum = phoneNum;
    contentLabel.text = [NSString stringWithFormat:@"你的好友（%@）还未加入KK部落，是否发送邀请Ta加入KK部落？", _phoneNum];
}

-(void)configSubView{
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [ccui getRH:67], SCREEN_WIDTH, [ccui getRH:194])];
    bgImageView.contentMode = UIViewContentModeCenter;
    bgImageView.image = [UIImage imageNamed:@"add_friend_bg_image"];
    [self addSubview:bgImageView];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:55], bgImageView.bottom+[ccui getRH:30], [ccui getRH:270], [ccui getRH:38])];
    contentLabel.textColor = RGB(0, 0, 0);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:contentLabel];

    UIButton *wxBtn = [[UIButton alloc] initWithFrame:CGRectMake([ccui getRH:75], contentLabel.bottom+[ccui getRH:35], [ccui getRH:225], [ccui getRH:38])];
    wxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [wxBtn setBackgroundImage:[UIImage imageWithColor:RGB(9, 187, 7) size:CGSizeMake([ccui getRH:225], [ccui getRH:38])] forState:UIControlStateNormal];
    [wxBtn setBackgroundImage:[UIImage imageWithColor:RGBA(9, 187, 7, 0.5) size:CGSizeMake([ccui getRH:225], [ccui getRH:38])] forState:UIControlStateHighlighted];
    wxBtn.layer.cornerRadius = [ccui getRH:3];
//    wxBtn.layer.masksToBounds = YES;
    [wxBtn setImage:[UIImage imageNamed:@"add_friend_wx_share"] forState:UIControlStateNormal];
    [wxBtn setImage:[UIImage imageNamed:@"add_friend_wx_share"] forState:UIControlStateHighlighted];
    [wxBtn setTitle:@"通过微信邀请" forState:UIControlStateNormal];
    [wxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wxBtn.titleEdgeInsets = UIEdgeInsetsMake(0, [ccui getRH:15], 0, 0);
    
    wxBtn.layer.shadowColor = RGBA(96, 135, 225, 0.55).CGColor;
    wxBtn.layer.shadowOffset = CGSizeMake(0,3);
    wxBtn.layer.shadowOpacity = 1;
    wxBtn.layer.shadowRadius = [ccui getRH:3];
    wxBtn.userInteractionEnabled = YES;
    [self addSubview:wxBtn];
    [wxBtn addTarget:self action:@selector(wxClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake([ccui getRH:75], wxBtn.bottom+[ccui getRH:17], [ccui getRH:225], [ccui getRH:38])];
    messageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [messageBtn setBackgroundImage:[UIImage imageWithColor:RGB(22, 119, 210) size:CGSizeMake([ccui getRH:225], [ccui getRH:38])] forState:UIControlStateNormal];
    [messageBtn setBackgroundImage:[UIImage imageWithColor:RGBA(22, 119, 210, 0.5) size:CGSizeMake([ccui getRH:225], [ccui getRH:38])] forState:UIControlStateHighlighted];
    messageBtn.layer.cornerRadius = [ccui getRH:3];
    messageBtn.userInteractionEnabled = YES;
    [messageBtn setImage:[UIImage imageNamed:@"add_friend_message_share"] forState:UIControlStateNormal];
    [messageBtn setImage:[UIImage imageNamed:@"add_friend_message_share"] forState:UIControlStateHighlighted];
    [messageBtn setTitle:@"发送短信邀请" forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, [ccui getRH:15], 0, 0);
    
    messageBtn.layer.shadowColor = [UIColor colorWithRed:96/255.0 green:135/255.0 blue:225/255.0 alpha:0.55].CGColor;
    messageBtn.layer.shadowOffset = CGSizeMake(0,3);
    messageBtn.layer.shadowOpacity = 1;
    messageBtn.layer.shadowRadius =  [ccui getRH:3];;
    [self addSubview:messageBtn];
    [messageBtn addTarget:self action:@selector(dxClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)wxClick{
    
    self.clickTitle(@"微信");
}

-(void)dxClick{
    
    self.clickTitle(@"短信");
}
@end
