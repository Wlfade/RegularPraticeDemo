//
//  KKMyRecommendCell.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyRecommendCell.h"

@interface KKMyRecommendCell ()
//@property (nonatomic, strong) KKMyRecommend *recommend;

@end


@implementation KKMyRecommendCell

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
            phoneNumLabel.adjustsFontSizeToFitWidth = YES;
            phoneNumLabel;
        });
        [self.contentView addSubview:_phoneNumLabel];
        
        /// 时间暂时没有数据
        _timeLabel =({
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.left = SCREEN_WIDTH - [ccui getRH:85];
            timeLabel.top = 15;
            timeLabel.size = CGSizeMake([ccui getRH:70], [ccui getRH:9]);
            timeLabel.textAlignment = NSTextAlignmentRight;
            timeLabel.adjustsFontSizeToFitWidth = YES;
            timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
            timeLabel.font = [UIFont systemFontOfSize:9];
            timeLabel.hidden = YES;
            timeLabel;
        });
        [self.contentView addSubview:_timeLabel];
        
        ///关注按钮
        _attentionButton = ({
           UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            attentionButton.left = SCREEN_WIDTH - [ccui getRH:57];
            attentionButton.top = 24;
            attentionButton.size = CGSizeMake([ccui getRH:47], [ccui getRH:24]);
            [attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
            attentionButton.titleLabel.font = [UIFont systemFontOfSize:13];
            attentionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            attentionButton.hidden = YES;
            [attentionButton setTitleColor:RGB(43, 63, 255) forState:UIControlStateNormal];
            [attentionButton addTarget:self action:@selector(attentionButtonAction) forControlEvents:UIControlEventTouchUpInside];
            attentionButton;
        });
        [self.contentView addSubview:_attentionButton];
    
    }
    return self;
}
- (void)attentionButtonAction {
    if (self.attentionButtonActionBlock) {
        self.attentionButtonActionBlock(_myRecommend,self);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void)setMyRecommend:(KKMyRecommend *)myRecommend {
    /// 默认交互是开的
    _attentionButton.userInteractionEnabled = YES;
    _myRecommend = myRecommend;

    if (myRecommend.isHasFocus == NO) {
        _attentionButton.hidden = YES;
    }else{
       _attentionButton.hidden = NO;
    }

    /// 登录的头像
    [_headPicImageView sd_setImageWithURL:[NSURL URLWithString:myRecommend.userLogoUrl]];
    
    /// 登录名字
    if (myRecommend.loginName.length != 0) {

        _nameLabel.textColor = COLOR_BLACK_TEXT;
        _nameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
        _nameLabel.text = myRecommend.loginName;
    }else{
        
        _nameLabel.text = @"";
    }
    /// 推荐的手机号
    if (myRecommend.cell.length != 0) {
        
        _phoneNumLabel.textColor = COLOR_GRAY_TEXT;
        _phoneNumLabel.font = [UIFont systemFontOfSize:[ccui getRH:14]];
        _phoneNumLabel.text = myRecommend.cell;
    }else {
        
        _phoneNumLabel.text = @"";
    }
    /// 是否关注
    if (_myRecommend.focus == YES) {
        
        [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        _attentionButton.backgroundColor = [UIColor whiteColor];
        [_attentionButton setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        _attentionButton.layer.cornerRadius = 1;
        _attentionButton.layer.borderWidth = 0.5;
        _attentionButton.layer.borderColor = RGB(226, 226, 226).CGColor;
        _attentionButton.userInteractionEnabled = NO;
    }else {
        
        [_attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentionButton setTitleColor:RGB(43, 63, 255) forState:UIControlStateNormal];
        _attentionButton.layer.cornerRadius = 0;
        _attentionButton.layer.borderWidth = 0;
        _attentionButton.backgroundColor = [UIColor whiteColor];
    }
    /// 这部分可以优化, 都用了一套cell, 可以用枚举控制显示哪部分数据
    /// 简介
    if (myRecommend.commonObjectMemo.length != 0) {
        self.phoneNumLabel.text = myRecommend.commonObjectMemo;
    }
    if (myRecommend.type ==  commonObjectCertType) {
        self.phoneNumLabel.text = myRecommend.commonObjectCert;
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
