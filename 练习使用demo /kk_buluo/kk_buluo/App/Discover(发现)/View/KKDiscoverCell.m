//
//  KKDiscoverCell.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/22.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKDiscoverCell.h"
#import "UIView+LSCore.h"
#import "KKApplicationInfo.h"


@interface KKDiscoverCell()
@property (nonatomic, strong) UIImageView *applicationIconImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *appDescLabel;

@end

@implementation KKDiscoverCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        
        [self setSubViews];
    }
    return self;
}
- (void)setSubViews {
    
    _applicationIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:15], 0, SCREEN_WIDTH - [ccui getRH:30], [ccui getRH:150])];
    [_applicationIconImageView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight withRadii:CGSizeMake(20, 20)];
    [self.contentView addSubview:_applicationIconImageView];
    
    _appNameLabel = [[UILabel alloc] init];
    _appNameLabel.top = [ccui getRH:33];
    _appNameLabel.left = [ccui getRH:20];
    _appNameLabel.size = CGSizeMake(_applicationIconImageView.width - [ccui getRH:40], [ccui getRH:20]);
    [_applicationIconImageView addSubview:_appNameLabel];
    
    _appNameLabel.font = [UIFont systemFontOfSize:21];
    _appNameLabel.textColor = [UIColor whiteColor];
    _appDescLabel = [[UILabel alloc] init];
    _appDescLabel.numberOfLines = 2;
    [_applicationIconImageView addSubview:_appDescLabel];
    
    [_appDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appNameLabel.mas_bottom).offset([ccui getRH:12]);
        make.left.mas_equalTo([ccui getRH:20]);
        make.width.mas_equalTo(self.applicationIconImageView.width - [ccui getRH:40]);
    }];
    
    _appDescLabel.font = [UIFont systemFontOfSize:[ccui getRH:15]];
    _appDescLabel.textColor = [UIColor whiteColor];

}

- (void)setAppInfo:(KKApplicationInfo *)appInfo {
//    [_applicationIconImageView sd_setImageWithURL:[NSURL URLWithString:appInfo.logoUrl]];
    _applicationIconImageView.image = [UIImage imageNamed:@"test_app"];
    _appNameLabel.text = appInfo.name;
    _appDescLabel.text = appInfo.descs;
}

- (CGFloat)labelTextAttributed:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    if (!text) {
        return 0;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:[ccui getRH:fontSize]],NSParagraphStyleAttributeName:paragraphStyle};
    return [[[NSAttributedString alloc]initWithString:text attributes:attributes] boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
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
