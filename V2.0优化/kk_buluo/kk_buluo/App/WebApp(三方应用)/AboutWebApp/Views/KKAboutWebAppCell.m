//
//  KKAboutWebAppCell.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKAboutWebAppCell.h"

@interface KKAboutWebAppCell()
@property (nonatomic, strong) UIImageView *webAppIconImageView;
@property (nonatomic, strong) UILabel *webAppNameLabel;
@property (nonatomic, strong) UILabel *webAppDiscriptionLabel;
@property (nonatomic, strong) UIButton *operationButton;
@property (nonatomic, strong) UIButton *operationButtonToSend;

@end

@implementation KKAboutWebAppCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /// 20 + 80 + 10 + 20 + 10 + textHeight + 10
        _webAppIconImageView = [[UIImageView alloc] init];
        _webAppIconImageView.top = [ccui getRH:20];
        _webAppIconImageView.centerX = SCREEN_WIDTH / 2 - [ccui getRH:40];
        _webAppIconImageView.size = CGSizeMake([ccui getRH:80], [ccui getRH:80]);
        [self.contentView addSubview:_webAppIconImageView];
        
        ///
        _webAppNameLabel = [[UILabel alloc] init];
        _webAppNameLabel.textAlignment = NSTextAlignmentCenter;
        _webAppNameLabel.top = _webAppIconImageView.bottom + [ccui getRH:10];
        _webAppNameLabel.left = 0;
        _webAppNameLabel.size = CGSizeMake(SCREEN_WIDTH, [ccui getRH:20]);
        [self.contentView addSubview:_webAppNameLabel];
        
        ///
        _webAppDiscriptionLabel = [[UILabel alloc] init];
        _webAppDiscriptionLabel.top = _webAppNameLabel.bottom + [ccui getRH:10];
        _webAppDiscriptionLabel.left = [ccui getRH:60];
        _webAppDiscriptionLabel.textAlignment = NSTextAlignmentCenter;
        _webAppDiscriptionLabel.size = CGSizeMake(SCREEN_WIDTH - [ccui getRH:120], [ccui getRH:50]);
        _webAppDiscriptionLabel.font = [UIFont systemFontOfSize:[ccui getRH:13]];
        _webAppDiscriptionLabel.numberOfLines = 0;
        _webAppDiscriptionLabel.textColor = COLOR_GRAY_TEXT;
        [self.contentView addSubview:_webAppDiscriptionLabel];

        ///
        _operationButtonToSend = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButtonToSend.frame = CGRectMake(0, _webAppDiscriptionLabel.bottom + [ccui getRH:10], SCREEN_WIDTH / 2, 50);
        [_operationButtonToSend setTitle:@"推荐给朋友" forState:UIControlStateNormal];
        [_operationButtonToSend setTitleColor:RGB(87, 107, 149) forState:UIControlStateNormal];
        [_operationButtonToSend setImage:Img(@"send_webApp_tofriends") forState:UIControlStateNormal];
        [self.contentView addSubview:_operationButtonToSend];
        [_operationButtonToSend addTarget:self action:@selector(operationButtonToSendAction) forControlEvents:UIControlEventTouchUpInside];
        ///
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_operationButtonToSend.right - 1, 14, 1, 24)];
        line.backgroundColor = RGB(216, 216, 216);
        [_operationButtonToSend addSubview:line];
        ///
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.frame = CGRectMake(_operationButtonToSend.right, _webAppDiscriptionLabel.bottom + [ccui getRH:10], SCREEN_WIDTH / 2, 50);
        [_operationButton setTitle:@"添加到我的应用" forState:UIControlStateNormal];
        [_operationButton setTitleColor:RGB(87, 107, 149) forState:UIControlStateNormal];
        _operationButton.titleLabel.font = [ccui getRFS:15];
        [self.contentView addSubview:_operationButton];
        [_operationButton addTarget:self action:@selector(operationButtonAddOrDeleteWebAppAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)setAppInfo:(KKApplicationInfo *)appInfo {
    if (appInfo.collect.integerValue == 0) {
        [_operationButton setTitle:@"添加到我的应用" forState:UIControlStateNormal];
        [_operationButton setImage:Img(@"add_wepApp_to_myCollection") forState:UIControlStateNormal];
    }else {
        [_operationButton setTitle:@"从我的应用中移除" forState:UIControlStateNormal];
        [_operationButton setImage:Img(@"delete_wepApp_from_myCollection") forState:UIControlStateNormal];

    }
    [_webAppIconImageView sd_setImageWithURL:[NSURL URLWithString:appInfo.logoUrl]];
    _webAppNameLabel.text = appInfo.name;
    _webAppDiscriptionLabel.text = appInfo.descs;
}

- (void)setDesHeight:(CGFloat)desHeight {
    _webAppDiscriptionLabel.size = CGSizeMake(SCREEN_WIDTH - [ccui getRH:120], desHeight);
    _operationButtonToSend.frame = CGRectMake(0, _webAppDiscriptionLabel.bottom + [ccui getRH:10], SCREEN_WIDTH / 2, 50);
    _operationButton.frame = CGRectMake(_operationButtonToSend.right, _webAppDiscriptionLabel.bottom + [ccui getRH:10], SCREEN_WIDTH / 2, 50);
}

- (void)operationButtonToSendAction {
    if (self.didSelectedToSendFriendBlock) {
        self.didSelectedToSendFriendBlock();
    }
}

- (void)operationButtonAddOrDeleteWebAppAction:(UIButton *)obj {
    if (self.didSelectedDeleteOrAddWebAppBlock) {
        self.didSelectedDeleteOrAddWebAppBlock(obj);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
