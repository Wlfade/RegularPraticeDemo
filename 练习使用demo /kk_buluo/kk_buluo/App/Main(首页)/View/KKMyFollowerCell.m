//
//  KKMyFollowerCell.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKMyFollowerCell.h"
#import "KKFollowerItem.h"

@interface KKMyFollowerCell ()

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation KKMyFollowerCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    UIImageView *imageView = [[UIImageView alloc]init];
    
    imageView.frame = CGRectMake(5, 5, self.width-10, self.width-10);
    
    imageView.layer.cornerRadius = (self.width-10)/2;
    
    imageView.layer.masksToBounds = YES;
    
    self.imageView = imageView;
    
    [self.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    
    titleLabel.frame = CGRectMake(0, self.width, self.width, self.height - self.width);
    titleLabel.font = [UIFont systemFontOfSize:11];
    
    titleLabel.textColor = rgba(51, 51, 51, 1);
    
//    titleLabel.lineBreakMode = NSLineBreakByClipping;
    titleLabel.lineBreakMode =NSLineBreakByTruncatingTail;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel = titleLabel;
    
    [self.contentView addSubview:titleLabel];
    
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setFollowerItem:(KKFollowerItem *)followerItem{
    _followerItem = followerItem;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:followerItem.commonObjectLogoUrl]];
    
    if (followerItem.commonObjectLogoUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:followerItem.commonObjectLogoUrl]];
    }else{
        self.imageView.image = followerItem.placeholdImage;
    }
    
    if (followerItem.titleColor) {
        self.titleLabel.textColor = followerItem.titleColor;
    }else{
        self.titleLabel.textColor = rgba(51, 51, 51, 1);
    }
    self.titleLabel.text = _followerItem.commonObjectName;
}
@end
