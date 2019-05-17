//
//  KKMyGroupCell.m
//  kk_buluo
//
//  Created by new on 2019/3/20.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyGroupCell.h"

@implementation KKMyGroupCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /// 头像
        _headPicImageView = [[UIImageView alloc] init];
        _headPicImageView.left = 15;
        _headPicImageView.top = 11;
        _headPicImageView.size = CGSizeMake(50, 50);
        _headPicImageView.clipsToBounds = YES;
        _headPicImageView.layer.cornerRadius = 25;
        [self.contentView addSubview:_headPicImageView];
        /// 新朋友的名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.left = 78;
        _nameLabel.top = 10;
        _nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 20, 33);
        [self.contentView addSubview:_nameLabel];
        
        /// 新朋友的名字
        _memoLabel = [[UILabel alloc] init];
        _memoLabel.left = 78;
        _memoLabel.top = _nameLabel.bottom;
        _memoLabel.size = CGSizeMake(_nameLabel.width, 20);
        _memoLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_memoLabel];
    }
    return self;
}
- (void)setMyGroup:(KKMyGroup *)myGroup {
    
    [_headPicImageView sd_setImageWithURL:[NSURL URLWithString:myGroup.groupLogoUrl]];
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)", myGroup.groupName, myGroup.groupMembers];
    _nameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
    _nameLabel.textColor = COLOR_BLACK_TEXT;
    
    _memoLabel.text = myGroup.memo;
    _memoLabel.textColor = COLOR_GRAY_TEXT;

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
