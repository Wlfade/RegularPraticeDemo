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
        _headPicImageView.backgroundColor = [UIColor redColor];
        _headPicImageView.left = 15;
        _headPicImageView.top = 11;
        _headPicImageView.size = CGSizeMake(50, 50);
        _headPicImageView.clipsToBounds = YES;
        _headPicImageView.layer.cornerRadius = 25;
        [self.contentView addSubview:_headPicImageView];
        /// 新朋友的名字
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.left = 78;
        _nameLabel.top = 18;
        _nameLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 80, 17);
        _nameLabel.font = [UIFont systemFontOfSize:18];
        
        [self.contentView addSubview:_nameLabel];
        /// 手机号
        _phoneNumLabel = [[UILabel alloc] init];
        _phoneNumLabel.left = _nameLabel.left;
        _phoneNumLabel.top = _nameLabel.top + _nameLabel.height + 10;
        _phoneNumLabel.size = CGSizeMake(SCREEN_WIDTH - _nameLabel.left - 80, 11);
        [self.contentView addSubview:_phoneNumLabel];
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

- (void)setMyRecommend:(KKMyRecommend *)myRecommend {
    [_headPicImageView sd_setImageWithURL:[NSURL URLWithString:myRecommend.userLogoUrl]];
    
    if (myRecommend.loginName.length != 0) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:myRecommend.loginName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 18],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        _nameLabel.attributedText = string;
    }
    if (myRecommend.cell.length != 0) {
        
        NSMutableAttributedString *cellAtt = [[NSMutableAttributedString alloc] initWithString:myRecommend.cell attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];    
        _phoneNumLabel.attributedText = cellAtt;
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
