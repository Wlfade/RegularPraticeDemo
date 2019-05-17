//
//  KKGroupMemberCollectionViewCell.m
//  kk_buluo
//
//  Created by new on 2019/3/21.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGroupMemberCollectionViewCell.h"

@implementation KKGroupMemberCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerPic = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerPic.size = CGSizeMake([ccui getRH:50], [ccui getRH:50]);
        _headerPic.center = self.contentView.center;
        _headerPic.clipsToBounds = YES;
        _headerPic.userInteractionEnabled = NO;
        _headerPic.layer.cornerRadius = [ccui getRH:25];
        [self addSubview:_headerPic];
        
        _nickName = [[UILabel alloc] init];
        _nickName.left = [ccui getRH:5];
        _nickName.top = _headerPic.bottom + [ccui getRH:5];
        _nickName.size = CGSizeMake(self.contentView.width - [ccui getRH:10], [ccui getRH:13]);
        _nickName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nickName];
    }
    return self;
}
@end
