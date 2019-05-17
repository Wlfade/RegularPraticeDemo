//
//  KKContactSelectedCollectionViewCell.m
//  kk_buluo
//
//  Created by summerxx on 2019/3/17.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKContactSelectedCollectionViewCell.h"

@implementation KKContactSelectedCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _ivAva = [[UIImageView alloc] initWithFrame:CGRectZero];
        _ivAva.clipsToBounds = YES;
        _ivAva.layer.cornerRadius = 18.0;
        _ivAva.translatesAutoresizingMaskIntoConstraints = NO;
        [_ivAva setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_ivAva];
        [self.contentView
         addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_ivAva]|"
                                                                options:kNilOptions
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_ivAva)]];
        [self.contentView
         addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_ivAva]|"
                                                                options:kNilOptions
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(_ivAva)]];
        _ivAva.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

- (void)setUserInfo:(KKContactUserInfo *)userInfo {
    [self.ivAva sd_setImageWithURL:[NSURL URLWithString:userInfo.userLogoUrl]];
}

@end
