//
//  KKNewFriendsCell.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKNewFriendsCell.h"

@interface KKNewFriendsCell ()
@property (nonatomic, strong) KKNewFriendsModel *model;
@end


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
        _nameLabel.top = 0;
        _nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 80, 56);
        _nameLabel.textColor = RGB(51, 51, 51);
        _nameLabel.font = [UIFont systemFontOfSize:[ccui getRH:17]];
        
        [self.contentView addSubview:_nameLabel];
        /// 新朋友当前的状态
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.left = SCREEN_WIDTH - 47 - 15;
        _statusButton.top = 17;
        _statusButton.size = CGSizeMake(47, 21);
        _statusButton.clipsToBounds = YES;
        _statusButton.layer.cornerRadius = 2.5;
        [_statusButton setTitle:@"同意" forState:UIControlStateNormal];
        _statusButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_statusButton];
        [_statusButton addTarget:self action:@selector(agreeAddAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setFriendsModel:(KKNewFriendsModel *)friendsModel {
    self.model = friendsModel;
    /*
     APPLYING => 申请中
     AGREED => 已同意
     REFUSED => 已拒绝
     EXPRIED => 已过期
     */
    [_headPicImageView sd_setImageWithURL:[NSURL URLWithString:friendsModel.userLogoUrl]];
    ///
    if (friendsModel.loginName.length != 0) {
        
        _nameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
        _nameLabel.textColor = COLOR_BLACK_TEXT;
        _nameLabel.text = friendsModel.loginName;
    }
    
    _statusButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _statusButton.backgroundColor = [UIColor whiteColor];
    [_statusButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    if ([friendsModel.status.name isEqualToString:@"APPLYING"]) {
        
        [_statusButton setTitle:@"同意" forState:UIControlStateNormal];
        [_statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _statusButton.backgroundColor = RGB(60, 82, 245);
    }else if ([friendsModel.status.name isEqualToString:@"AGREED"]){
        
        [_statusButton setTitle:@"已同意" forState:UIControlStateNormal];
    }else if ([friendsModel.status.name isEqualToString:@"REFUSED"]){
        
        [_statusButton setTitle:@"已拒绝" forState:UIControlStateNormal];
    }else if ([friendsModel.status.name isEqualToString:@"EXPRIED"]){
        
        [_statusButton setTitle:@"已过期" forState:UIControlStateNormal];
    }
}
- (void)agreeAddAction {
    if ([_statusButton.titleLabel.text isEqualToString:@"同意"]) {
        if (self.agreeAddFriendBlock) {
            self.agreeAddFriendBlock(self.model);
        }
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
