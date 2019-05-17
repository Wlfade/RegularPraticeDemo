//
//  KKContactCell.m
//  kk_buluo
//
//  Created by summerxx on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKContactCell.h"

@interface KKContactCell ()


@end

@implementation KKContactCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ///
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //1.头像
        _headPicImageView = [[UIImageView alloc] init];
        _headPicImageView.backgroundColor = [UIColor whiteColor];
        _headPicImageView.left = [ccui getRH:14];
        _headPicImageView.top = [ccui getRH:15];
        _headPicImageView.size = CGSizeMake([ccui getRH:32], [ccui getRH:32]);
        _headPicImageView.layer.cornerRadius = 16;
        _headPicImageView.clipsToBounds = YES;
        [self.contentView addSubview:_headPicImageView];
        _headPicImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderViewAction)];
        [_headPicImageView addGestureRecognizer:tap];
        /// 有新朋友申请, 显示红色点点
        //2.名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.left = [ccui getRH:55];
        _nameLabel.top = 0;
        _nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - [ccui getRH:40], [ccui getRH:56]);
        _nameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}
- (void)setUserInfo:(id)userInfo {
    _nameLabel.textColor = COLOR_BLACK_TEXT;
    _nameLabel.numberOfLines = 0;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([userInfo isKindOfClass:[KKContactUserInfo class]]) {
        if (((KKContactUserInfo *)userInfo).loginName == nil || [((KKContactUserInfo *)userInfo).loginName isEqualToString:@""]) {
            return;
        }
        [self.headPicImageView sd_setImageWithURL:[NSURL URLWithString:((KKContactUserInfo *)userInfo).userLogoUrl]];
        
        if (((KKContactUserInfo *)userInfo).loginName.length != 0) {
            
            _nameLabel.text = ((KKContactUserInfo *)userInfo).loginName;
        }
    }else if ([userInfo isKindOfClass:[KKGroupMember class]]) {
      
        [self.headPicImageView sd_setImageWithURL:[NSURL URLWithString:((KKGroupMember *)userInfo).userLogoUrl]];
        
        if (((KKGroupMember *)userInfo).loginName.length != 0) {
            
            _nameLabel.text = ((KKGroupMember *)userInfo).loginName;
        }
    }
}

- (void)tapHeaderViewAction {
    if (self.tapHeaderBlock) {
        self.tapHeaderBlock();
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
