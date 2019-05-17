//
//  KKNewFriendsCell.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKNewFriendsCell.h"

@implementation KKNewFriendsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /// 头像
        _headPicImageView = [[UIImageView alloc] init];
        _headPicImageView.left = 13;
        _headPicImageView.top = 16;
        _headPicImageView.size = CGSizeMake(33, 33);
        [self.contentView addSubview:_headPicImageView];
        _headPicImageView.layer.cornerRadius = 16;
        _headPicImageView.clipsToBounds = YES;
        /// 新朋友的名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.left = 58;
        _nameLabel.top = 21;
        _nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 80, 17);
        
        [self.contentView addSubview:_nameLabel];
        /// 新朋友当前的状态
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.left = SCREEN_WIDTH - 47 - 15;
        _statusButton.top = 15;
        _statusButton.size = CGSizeMake(47, 21);
        _statusButton.clipsToBounds = YES;
        _statusButton.layer.cornerRadius = 2.5;
        [_statusButton setTitle:@"同意" forState:UIControlStateNormal];
        [self.contentView addSubview:_statusButton];
        [_statusButton addTarget:self action:@selector(agreeAddAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setFriendsModel:(KKNewFriendsModel *)friendsModel {
    /*
     APPLYING => 申请中
     AGREED => 已同意
     REFUSED => 已拒绝
     EXPRIED => 已过期
     */
    [_headPicImageView sd_setImageWithURL:[NSURL URLWithString:friendsModel.userLogoUrl]];
    ///
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:friendsModel.loginName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 18],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    _nameLabel.attributedText = string;
    
    _statusButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _statusButton.backgroundColor = [UIColor whiteColor];
    [_statusButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    if ([friendsModel.status.name isEqualToString:@"APPLYING"]) {
        [_statusButton setTitle:@"同意" forState:UIControlStateNormal];
        _statusButton.backgroundColor = [UIColor colorWithRed:60/255.0 green:82/255.0 blue:245/255.0 alpha:1.0];
    }else if ([friendsModel.status.name isEqualToString:@"AGREED"]){
        [_statusButton setTitle:@"同意" forState:UIControlStateNormal];
    }else if ([friendsModel.status.name isEqualToString:@"REFUSED"]){
        [_statusButton setTitle:@"已过期" forState:UIControlStateNormal];
    }else if ([friendsModel.status.name isEqualToString:@"EXPRIED"]){
        [_statusButton setTitle:@"已拒绝" forState:UIControlStateNormal];
    }
}
- (void)agreeAddAction {
    if ([_statusButton.titleLabel.text isEqualToString:@"同意"]) {
        CCLOG(@"同意");
    }else {
        /// 其他状态点击不生效
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
