//
//  KKGuildGroupListCell.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/25.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGuildGroupListCell.h"

@implementation KKGuildGroupListCell

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
            phoneNumLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - [ccui getRH:30], 11);
            phoneNumLabel.font = [UIFont systemFontOfSize:13];
            phoneNumLabel.textColor = COLOR_DARK_GRAY_TEXT;
            phoneNumLabel;
        });
        [self.contentView addSubview:_phoneNumLabel];
        
        _joinedStatus = [[UILabel alloc] init];
        _joinedStatus.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_joinedStatus];
        _joinedStatus.top = 15;
        _joinedStatus.left = SCREEN_WIDTH - 120;
        _joinedStatus.size = CGSizeMake(80, 20);
        _joinedStatus.font = [ccui getRFS:12];
        _joinedStatus.textColor = COLOR_GRAY_TEXT;
        
    }
    return self;
}
- (void)setInfo:(KKPersonalPageGroupModel *)info {
    [_headPicImageView sd_setImageWithURL:[NSURL URLWithString:info.groupLogoUrl]];
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)", info.groupName, info.groupMembers];
    _phoneNumLabel.text = info.memo;
    if (info.userJoined.integerValue == 1) {
        _joinedStatus.text = @"✔️ 已加入";
    }else {
        _joinedStatus.text = @"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
