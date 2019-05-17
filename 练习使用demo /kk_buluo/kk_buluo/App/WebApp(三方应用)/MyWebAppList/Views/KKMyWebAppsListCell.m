//
//  KKMyWebAppsListCell.m
//  kk_buluo
//
//  Created by 景天 on 2019/4/24.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKMyWebAppsListCell.h"
#import "KKApplicationInfo.h"
@implementation KKMyWebAppsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.headPicImageView.frame = CGRectMake([ccui getRH:12], [ccui getRH:15], [ccui getRH:52], [ccui getRH:52]);
        self.nameLabel.frame = CGRectMake([ccui getRH:78], [ccui getRH:22], SCREEN_WIDTH - [ccui getRH:78] - [ccui getRH:12], [ccui getRH:16]);
        self.phoneNumLabel.frame = CGRectMake([ccui getRH:78], [ccui getRH:48], self.nameLabel.width, [ccui getRH:13]);
        
    }
    return self;
}

- (void)setAppInfo:(KKApplicationInfo *)appInfo {
    [self.headPicImageView sd_setImageWithURL:[NSURL URLWithString:appInfo.logoUrl]];
    self.nameLabel.text = appInfo.name;
    self.phoneNumLabel.text = appInfo.descs;
    self.phoneNumLabel.adjustsFontSizeToFitWidth = NO;
    self.phoneNumLabel.font = [UIFont systemFontOfSize:[ccui getRH:13]];
    self.headPicImageView.layer.cornerRadius = 0;
    self.headPicImageView.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
