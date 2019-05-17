//
//  KKContactCell.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
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
        _headPicImageView = [[UIImageView alloc] init];
        _headPicImageView.left = 14;
        _headPicImageView.top = 15;
        _headPicImageView.size = CGSizeMake(32, 32);
        _headPicImageView.layer.cornerRadius = 16;
        _headPicImageView.clipsToBounds = YES;
        [self.contentView addSubview:_headPicImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.left = 55;
        _nameLabel.top = 20;
        _nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 40, 17);
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}
- (void)setUserInfo:(id)userInfo {
    if ([userInfo isKindOfClass:[KKContactUserInfo class]]) {
        ///
        [self.headPicImageView sd_setImageWithURL:[NSURL URLWithString:((KKContactUserInfo *)userInfo).userLogoUrl]];
        /// 用户名 赋值.
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:((KKContactUserInfo *)userInfo).loginName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 18],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        _nameLabel.attributedText = string;
        
    }else if ([userInfo isKindOfClass:[KKGroupMember class]]) {
        ///
        [self.headPicImageView sd_setImageWithURL:[NSURL URLWithString:((KKGroupMember *)userInfo).userLogoUrl]];
        /// 用户名 赋值.
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:((KKGroupMember *)userInfo).loginName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 18],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
        _nameLabel.attributedText = string;
    }
    _nameLabel.numberOfLines = 0;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
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
