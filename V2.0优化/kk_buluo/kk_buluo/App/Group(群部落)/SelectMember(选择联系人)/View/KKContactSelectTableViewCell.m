//
//  KKContactSelectTableViewCell.m
//  kk_buluo
//
//  Created by new on 2019/3/17.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKContactSelectTableViewCell.h"

@interface KKContactSelectTableViewCell()
@property (nonatomic, strong) KKGroupMember *member;
@end

@implementation KKContactSelectTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedImageView = [[UIImageView alloc] init];
        self.selectedImageView.left = [ccui getRH:16];
        self.selectedImageView.top = [ccui getRH:22];
        self.selectedImageView.size = CGSizeMake([ccui getRH:16], [ccui getRH:16]);
        [self.contentView addSubview:self.selectedImageView];
        
        self.portraitImageView = [[UIImageView alloc] init];
        self.portraitImageView.left = [ccui getRH:36];
        self.portraitImageView.top = [ccui getRH:13];
        self.portraitImageView.size = CGSizeMake([ccui getRH:33], [ccui getRH:33]);
        self.portraitImageView.layer.cornerRadius = [ccui getRH:16];
        self.portraitImageView.clipsToBounds = YES;
        /// d NO
        self.portraitImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.portraitImageView];
        
        /// 头像可以点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortraitImageViewAction)];
        [self.portraitImageView addGestureRecognizer:tap];
        
        self.nicknameLabel = [[UILabel alloc] init];
        self.nicknameLabel.left = [ccui getRH:79];
        self.nicknameLabel.top = [ccui getRH:21];
        self.nicknameLabel.size = CGSizeMake(SCREEN_WIDTH - [ccui getRH:79 + 20], 17);
        [self.contentView addSubview:self.nicknameLabel];
    }
    return self;
}

- (void)setUserInfo:(KKGroupMember *)userInfo {
    _member = userInfo;
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.userLogoUrl]];
    /// 用户名 赋值.
    if (userInfo.loginName.length != 0) {
        
        self.nicknameLabel.text = userInfo.loginName;
        self.nicknameLabel.textColor = COLOR_DARK_GRAY_TEXT;
        self.nicknameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
    }
    self.nicknameLabel.numberOfLines = 0;
    self.nicknameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)tapPortraitImageViewAction {
    if (self.tapPortraitImageViewBlock) {
        self.tapPortraitImageViewBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _selectedImageView.image = [UIImage imageNamed:@"checkmark_round_blueBg"];
    }else {
        _selectedImageView.image = [UIImage imageNamed:@"checkmark_onlyCircle_gray"];
    }
    if (_member == nil) {
        return;
    }
    if (_member.isExist == YES) { /// nocheckmark_gray
        _selectedImageView.image = [UIImage imageNamed:@"nocheckmark_gray"];
    }
}

@end
