//
//  KKMyRecommendCell.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyRecommendCell.h"

@implementation KKMyRecommendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /// 头像
        _headPicImageView = [[UIImageView alloc] init];
        _headPicImageView.left = 15;
        _headPicImageView.top = 11;
        _headPicImageView.size = CGSizeMake(50, 50);
        [self.contentView addSubview:_headPicImageView];
        _headPicImageView.backgroundColor = [UIColor cyanColor];
        /// 新朋友的名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.left = 78;
        _nameLabel.top = 18;
        _nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 80, 17);
        [self.contentView addSubview:_nameLabel];
        _nameLabel.backgroundColor = [UIColor redColor];
        /// 手机号
        _phoneNumLabel = [[UILabel alloc] init];
        _phoneNumLabel.left = _nameLabel.left;
        _phoneNumLabel.top = _nameLabel.top + _nameLabel.height + 10;
        _phoneNumLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 80, 11);
        [self.contentView addSubview:_phoneNumLabel];
        _phoneNumLabel.backgroundColor = [UIColor blueColor];
        ///
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.left = SCREEN_WIDTH - 33 - 15;
        _timeLabel.top = 15;
        _timeLabel.size = CGSizeMake(33, 9);
        _timeLabel.text = @"1小时前";
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:9];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
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
