//
//  KKDyDetailAccessView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetailAccessView.h"
#import "KKDyDetailAccessCountItem.h"

@interface KKDyDetailAccessView ()

@property (nonatomic,weak) UIButton *accessBtn;

@end

@implementation KKDyDetailAccessView

- (instancetype)init{
    if (self = [super init]) {
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{

    UIButton *accessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accessBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [accessBtn setImage:[UIImage imageNamed:@"accessCount_icon"] forState:UIControlStateNormal];
    [accessBtn setTitleColor:rgba(153, 153, 153, 1) forState:UIControlStateNormal];
    accessBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    self.accessBtn = accessBtn;
    [self addSubview:accessBtn];
    
//
    [accessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
-(void)setDyDetailAccItem:(KKDyDetailAccessCountItem *)dyDetailAccItem{
    _dyDetailAccItem = dyDetailAccItem;
    [self.accessBtn setTitle:[NSString stringWithFormat:@" %ld",(long)dyDetailAccItem.accessCount] forState:UIControlStateNormal];
}

@end
