//
//  KKGuildListCell.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGuildListCell.h"

@implementation KKGuildListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /// 头像
        _headPicImageView = ({
            UIImageView  *headPicImageView = [[UIImageView alloc] init];
            headPicImageView.left = 15;
            headPicImageView.top = 11;
            headPicImageView.size = CGSizeMake(50, 50);
            headPicImageView.clipsToBounds = YES;
            headPicImageView.layer.cornerRadius = 25;
            headPicImageView;
        });
        [self.contentView addSubview:_headPicImageView];
        
        /// 新朋友的名字
        _nameLabel = ({
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.left = 78;
            nameLabel.top = 20;
            nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - [ccui getRH:80], 20);
            nameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
            nameLabel;
        });
        [self.contentView addSubview:_nameLabel];
        
        /// 手机号
        _phoneNumLabel = ({
            UILabel *phoneNumLabel = [[UILabel alloc] init];
            phoneNumLabel.left = _nameLabel.left;
            phoneNumLabel.top = _nameLabel.bottom + [ccui getRH:6];
            phoneNumLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - [ccui getRH:80], 11);
            phoneNumLabel.font = [UIFont systemFontOfSize:13];
            phoneNumLabel.textColor = COLOR_DARK_GRAY_TEXT;
            phoneNumLabel;
        });
        [self.contentView addSubview:_phoneNumLabel];
        
    }
    return self;
}
- (void)setInfo:(KKWepAppAboutDetailInfo *)info {
    [_headPicImageView sd_setImageWithURL:[NSURL URLWithString:info.guildLogoUrl]];
    _nameLabel.text = info.guildName;
    _phoneNumLabel.text = info.guildCert;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
